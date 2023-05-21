// SPDX-License-Identifier: GPL-2.0
static const char *__doc__ = "XDP sample packet\n";

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <linux/bpf.h>
#include <net/if.h>
#include <errno.h>
#include <signal.h>
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
#include <linux/icmpv6.h>
#include <linux/icmp.h>
#include <linux/udp.h>
#include <linux/tcp.h>
#include <time.h>
#include <sys/time.h>
#include <unistd.h>
#include <assert.h>
#include <poll.h>
#include <linux/perf_event.h>
#include <sys/mman.h>

#define SAMPLE_SIZE 1024
#ifndef __packed
#define __packed __attribute__((packed))
#endif

struct tuples
{
    uint8_t ip_version;
    u_int32_t ip_src;
    u_int32_t ip_dest;
    struct in6_addr ip6_src;
    struct in6_addr ip6_dest;
    uint8_t protocol;
    __u16 port_src;
    __u16 port_dest;
    u_int16_t icmp_sequence;
    unsigned char source_cidr;
    unsigned char dest_cidr;
};

struct log
{
	__u16 cookie;
	__u16 pkt_len;
	__u64 ts_pre;
	__u64 ts_post;
	struct tuples data;
} __packed;

struct settings
{
	u_int32_t state;
	struct tuples data;
};

struct log_and_count
{
    int count;
    struct log log;
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
	prog_load_attr.file = "/home/mirai/ebpf_pfilt/ebpf_pfilt_adv/xdp_prog_kern.o";

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
		return EXIT_FAIL_OPTION;
	}

	if (access(map_filename, F_OK) != -1)
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

static int filter_settings_fd;


int main(int argc, char **argv)
{
	struct rlimit r = {RLIM_INFINITY, RLIM_INFINITY};
	struct bpf_object *obj;
	struct bpf_map *map;
	struct bpf_map *logger;
	char filename[256];
	struct config cfg = {
		.xdp_flags = XDP_FLAGS_UPDATE_IF_NOEXIST | XDP_FLAGS_DRV_MODE,
		.ifindex = -1,
		.do_unload = false,
	};
	char *default_progsec = "xdp_filter";

	int udefupdated = 0;

	struct settings *udef = (struct settings *)malloc(sizeof(struct settings));

	for (int i = 1; i < argc; i++)
	{
		if (!strcmp(argv[i], "--udef"))
		{
			udef->data.port_src = 0;
			udef->data.protocol = 0;
			udef->data.ip_src = 0;
			udef->state = 1;

			for (int r = i + 1; r < argc - 1; r++)
			{
				if (!strcmp(argv[r], "ip") && r + 1 < argc)
				{
					struct in_addr temp;
					int err = inet_aton(argv[r + 1], &temp);
					if (err == 0)
					{
						printf("Unable to read the IP address. Please check if the IP address is valid.");
						return 0;
					}
					udef->data.ip_src = temp.s_addr;
					udefupdated++;
					break;
				}
				else if (!strcmp(argv[r], "protocol") && r + 2 < argc)
				{
					if (!strcmp(argv[r + 1], "udp"))
					{
						udef->data.protocol = 17;
						udef->data.port_src = atoi(argv[r + 2]);
						udefupdated++;
					}
					else if (!strcmp(argv[r + 1], "tcp"))
					{
						udef->data.protocol = 6;
						udef->data.port_src = atoi(argv[r + 2]);
						udefupdated++;
					}
					else if (!strcmp(argv[r + 1], "icmp"))
					{
						udef->data.protocol = 1;
						udefupdated++;
					}
				}
				else
				{
					printf("Please specify the IP address, protocol, or port.");
					return 0;
				}
			}
			break;
		}
	}

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

	map = bpf_map__next(NULL, obj);
	if (!map)
	{
		printf("finding a map in obj file failed\n");
		return 1;
	}
	filter_settings_fd = bpf_map__fd(map);

	if (udefupdated != 0)
	{
		printf("Sending user defined filter data\n");
		__u32 key = 50;
		bpf_map_update_elem(filter_settings_fd, &key, udef, 0);
	}

	int logger_fd = 0;
	logger = bpf_map__next(map, obj);
	if (!logger)
	{
		printf("finding a map in obj file failed\n");
		return 1;
	}
}
