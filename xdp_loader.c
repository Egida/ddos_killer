// SPDX-License-Identifier: GPL-2.0
static const char *__doc__ = "XDP sample packet\n";

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <linux/bpf.h>
#include <bpf/libbpf.h>
#include <bpf/bpf.h>
#include <sys/resource.h>
#include <linux/if_link.h>
#include "perf-sys.h"
#include "common/common_params.h"
#include "common/common_user_bpf_xdp.h"
#include "libbpf/src/bpf_endian.h"
#include "bpf_util.h"
#include <linux/ip.h>
#include <linux/if_ether.h>
#include <linux/ipv6.h>
#include <arpa/inet.h>
#include <time.h>
#include <math.h>

#ifndef __packed
#define __packed __attribute__((packed))
#endif

struct flow
{
	u_int32_t ip_src;
	u_int32_t ip_dest;
	__u32 packet_count;
	double entropy;
} __packed;

struct interval
{
	struct flow flow[1000];
} __packed;

struct lpm_v4_key
{
	__u32 prefixlen;
	__u32 address;
};

struct metadata
{
	__u32 packet_count2;
	__u32 packet_count;
};

static const struct option_wrapper long_options[] = {
	{{"help", no_argument, NULL, 'h'},
	 "Show help",
	 false},

	{{"force", no_argument, NULL, 'F'},
	 "Force install, replacing existing program on interface"},

	{{"dev", required_argument, NULL, 'd'},
	 "Operate on device <ifname>",
	 "<ifname>",
	 true},

	{{"filename", required_argument, NULL, 1},
	 "Store packet sample into <file>",
	 "<file>"},

	{{"quiet", no_argument, NULL, 'q'},
	 "Quiet mode (no output)"},

	{{"unload", no_argument, NULL, 'U'},
	 "Unload XDP program instead of loading"},
	{{"udef", no_argument, NULL, 'i'},
	 "Add user defined filter"},
	{{0, 0, NULL, 0}, NULL, false}};

struct bpf_object *__load_bpf_object_file(const char *filename, int ifindex)
{
	int first_prog_fd = -1;
	struct bpf_object *obj;
	int err;

	struct bpf_prog_load_attr prog_load_attr = {
		.prog_type = BPF_PROG_TYPE_XDP,
		.ifindex = ifindex,
	};
	prog_load_attr.file = "xdp_prog_kern.o";

	err = bpf_prog_load_xattr(&prog_load_attr, &obj, &first_prog_fd);
	if (err)
	{
		fprintf(stderr, "ERR: loading BPF-OBJ file(%s) (%d): %s\n",
				filename, err, strerror(-err));
		return NULL;
	}

	return obj;
}

struct bpf_object *__load_bpf_and_xdp_attach(struct config *cfg)
{
	struct bpf_program *bpf_prog;
	struct bpf_object *bpf_obj;
	int offload_ifindex = 0;
	int prog_fd = -1;
	int err;

	if (cfg->xdp_flags & XDP_FLAGS_HW_MODE)
		offload_ifindex = cfg->ifindex;

	bpf_obj = __load_bpf_object_file(cfg->filename, offload_ifindex);
	if (!bpf_obj)
	{
		fprintf(stderr, "ERR: loading file: %s\n", cfg->filename);
		exit(EXIT_FAIL_BPF);
	}

	/* Find a matching BPF prog section name */
	bpf_prog = bpf_object__find_program_by_title(bpf_obj, cfg->progsec);
	if (!bpf_prog)
	{
		fprintf(stderr, "ERR: finding progsec: %s\n", cfg->progsec);
		exit(EXIT_FAIL_BPF);
	}

	prog_fd = bpf_program__fd(bpf_prog);
	if (prog_fd <= 0)
	{
		fprintf(stderr, "ERR: bpf_program__fd failed\n");
		exit(EXIT_FAIL_BPF);
	}

	err = xdp_link_attach(cfg->ifindex, cfg->xdp_flags, prog_fd);
	if (err)
		exit(err);

	return bpf_obj;
}

const char *pin_basedir = "/sys/fs/bpf";
const char *map_name = "map";

int pin_maps_in_bpf_object(struct bpf_object *bpf_obj, const char *subdir)
{
	char map_filename[4096];
	char pin_dir[4096];
	int err, len;

	len = snprintf(pin_dir, 4096, "%s/%s", pin_basedir, subdir);
	if (len < 0)
	{
		fprintf(stderr, "ERR: creating pin dirname\n");
		return EXIT_FAIL_OPTION;
	}

	len = snprintf(map_filename, 4096, "%s/%s/%s",
				   pin_basedir, subdir, map_name);
	if (len < 0)
	{
		fprintf(stderr, "ERR: creating map_name\n");
	}

	if (access(map_filename, F_OK) == 0)
	{
		printf(" - Unpinning (remove) prev maps in %s/\n", pin_dir);

		err = bpf_object__unpin_maps(bpf_obj, pin_dir);
		if (err)
		{
			fprintf(stderr, "ERR: Unpinning maps in %s\n", pin_dir);
			return EXIT_FAIL_BPF;
		}
	}

	if (verbose)
		printf(" - Pinning maps in %s/\n", pin_dir);

	err = bpf_object__pin_maps(bpf_obj, pin_dir);
	if (err)
		return EXIT_FAIL_BPF;

	return 0;
}

static int packet_count_alltime = 0;
static int prev_packet_count = 0;
static int cur_packet_count = 0;
static int beta = 0;

static int holder = 0;

void calculate_entropy(int logger_fd, int blacklist_fd)
{
	struct interval *invl_prev = malloc(sizeof(struct interval));
	int key_invl = 0;
	int e = bpf_map_lookup_elem(logger_fd, &key_invl, invl_prev);
	if (e == -1)
	{
		printf("Error in fetching log data\n");
		return;
	}

	struct interval *invl_cur = malloc(sizeof(struct interval));
	key_invl = 1;
	e = bpf_map_lookup_elem(logger_fd, &key_invl, invl_cur);
	if (e == -1)
	{
		printf("Error in fetching log data\n");
		return;
	}

	// Refresh the log to accept new data
	struct interval *invl_new = malloc(sizeof(struct interval));
	key_invl = 1;
	bpf_map_update_elem(logger_fd, &key_invl, invl_new, BPF_ANY);

	// implement code to calculate based on fast entropy approach
	double value = 0.0;
	double tau = 0.0;
	printf("==Interval==\n");
	for (int num_of_flow = 0; num_of_flow < 1000; num_of_flow++)
	{
		if (invl_prev->flow[num_of_flow].packet_count != 0)
		{
			cur_packet_count += invl_prev->flow[num_of_flow].packet_count;
		}
		else
		{
			break;
		}
	}

	// int average_packet_per_flow = cur_packet_count / num_of_flow;

	for (int i = 0; i < 1000; i++)
	{
		if (invl_prev->flow[i].packet_count != 0)
		{
			packet_count_alltime += invl_prev->flow[i].packet_count;
			double p = (double)invl_prev->flow[i].packet_count / cur_packet_count; //(metadata->packet_count);
			value = -1 * log10(p);
			int next_int_packet_count = 0;
			for (int j = 0; j < 1000; j++)
			{
				if (invl_prev->flow[i].ip_src == invl_cur->flow[j].ip_src)
				{
					if (invl_prev->flow[i].ip_src >= invl_prev->flow[j].ip_src)
					{
						next_int_packet_count = invl_cur->flow[j].packet_count;
						tau = log10((double)invl_cur->flow[j].packet_count / next_int_packet_count);
						break;
					}
					else
					{
						next_int_packet_count = invl_cur->flow[j].packet_count;
						tau = log10((double)next_int_packet_count / invl_cur->flow[j].packet_count);
						break;
					}
				}
			}
			// Printing the entropy values
			struct in_addr in;
			in.s_addr = invl_prev->flow[i].ip_src;
			char *ip = inet_ntoa(in);
			if (tau < 0)
			{
				tau = -1 * tau;
			}
			invl_prev->flow[i].entropy = value + tau;
			printf("IP:%s prv: %d cur: %d etp:%f\n", ip, invl_prev->flow[i].packet_count, next_int_packet_count, invl_prev->flow[i].entropy);
			holder += invl_prev->flow[i].packet_count;
		}
		else
		{
			break;
		}
	}

	double avg_entropy = 0.0;
	double sum_of_entropy = 0.0;
	int num_of_flow = 0;
	for (num_of_flow = 0; num_of_flow < 1000; num_of_flow++)
	{
		if (invl_prev->flow[num_of_flow].packet_count != 0)
		{
			sum_of_entropy += invl_prev->flow[num_of_flow].entropy;
		}
		else
		{
			break;
		}
	}
	avg_entropy = sum_of_entropy / num_of_flow;
	double deviation = 0.0;

	for (int i = 0; i <= num_of_flow; i++)
	{
		deviation += abs(invl_prev->flow[i].entropy - avg_entropy) * abs(invl_prev->flow[i].entropy - avg_entropy);
	}

	double std_deviation = sqrt(deviation / (double)num_of_flow);
	printf("calculated standard deviation %f\n", std_deviation);

	for (int i = 0; i <= num_of_flow; i++)
	{
		if (invl_prev->flow[i].entropy > 1.5 * avg_entropy)
		{
			beta++;
		}
		else if (invl_prev->flow[i].entropy < 0.5 * avg_entropy)
		{
			beta--;
		}

		if (abs(avg_entropy - invl_prev->flow[i].entropy) > beta * std_deviation)
		{
			struct lpm_v4_key *key = malloc(sizeof(struct lpm_v4_key));
			key->prefixlen = 32;
			key->address = invl_prev->flow[i].ip_src;
			int i = 0;

			struct in_addr in;
			in.s_addr = invl_prev->flow[i].ip_src;
			char *ip = inet_ntoa(in);

			int e = bpf_map_update_elem(blacklist_fd, key, &i, BPF_NOEXIST);
			if (e < 0)
			{
				printf("Adding new filter settings failed IP: %s\n", ip);
			}
			else
			{
				printf("Blocked IP: %s\n", ip);
			}
		}
	}

	cur_packet_count = 0;
	//  copy invl->intervals[1] to invl->intervals[0], and update bpf map
	memcpy(invl_prev, invl_cur, sizeof(struct interval));
	key_invl = 0;
	bpf_map_update_elem(logger_fd, &key_invl, invl_prev, BPF_ANY);
}

int main(int argc, char **argv)
{
	struct rlimit r = {RLIM_INFINITY, RLIM_INFINITY};
	struct bpf_object *obj;
	struct bpf_map *logger;
	struct bpf_map *blacklist;
	struct bpf_map *data;
	char filename[256];
	struct config cfg = {
		.xdp_flags = XDP_FLAGS_UPDATE_IF_NOEXIST | XDP_FLAGS_DRV_MODE,
		.ifindex = -1,
		.do_unload = false,
	};
	char *default_progsec = "xdp_filter";

	strncpy(cfg.progsec, default_progsec, sizeof(cfg.progsec));

	parse_cmdline_args(argc, argv, long_options, &cfg, __doc__);

	/* Required option */
	if (cfg.ifindex == -1)
	{
		fprintf(stderr, "ERR: required option --dev missing\n");
		usage(argv[0], __doc__, long_options, (argc == 1));
		return EXIT_FAIL_OPTION;
	}

	if (setrlimit(RLIMIT_MEMLOCK, &r))
	{
		perror("setrlimit(RLIMIT_MEMLOCK)");
		return 1;
	}

	snprintf(cfg.filename, sizeof(cfg.filename), "xdp_prog_kern.o");

	if (cfg.do_unload)
		return xdp_link_detach(cfg.ifindex, cfg.xdp_flags, 0);

	obj = __load_bpf_and_xdp_attach(&cfg);
	if (!obj)
		return EXIT_FAIL_BPF;
	printf("eBPF program has been successfully attached to XDP.\n");

	pin_maps_in_bpf_object(obj, cfg.ifname);

	logger = bpf_map__next(NULL, obj);
	if (!logger)
	{
		printf("finding a map in obj file failed\n");
		return 1;
	}
	int logger_fd = bpf_map__fd(logger);

	blacklist = bpf_map__next(logger, obj);
	if (!blacklist)
	{
		printf("finding a map in obj file failed\n");
		return 1;
	}
	int blacklist_fd = bpf_map__fd(blacklist);

	/*int data_fd = 0;
	data = bpf_map__next(blacklist, obj);
	if (!data)
	{
		printf("finding a map in obj file failed\n");
		return 1;
	}*/
	int count = 0;

	while (1)
	{
		sleep(1);
		calculate_entropy(logger_fd, blacklist_fd);
		count++;
		if (count == 10)
		{
			printf("Roudup of past 10 seconds %d\n", holder);
			count = 0;
			holder = 0;
		}
	}
}
