#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>
#include <string.h>
#include <arpa/inet.h>
#include <asm/types.h>
#include "libbpf/src/bpf.h"
#include <linux/bpf.h>
#include "common/common_params.h"
#include "common/common_user_bpf_xdp.h"
#include "common/common_kern_user.h"
#include <time.h>
#include <sys/time.h>
#include <unistd.h>
#include <assert.h>
#include <poll.h>
#include <linux/perf_event.h>
#include "libbpf/src/bpf_endian.h"
#include <sys/mman.h>
#include "bpf_util.h"
#include <bpf/libbpf.h>
#include "perf-sys.h"

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

struct lpm_v4_key
{
    __u32 prefixlen;
    __u8 address[4];
};

const char *pin_basedir = "/sys/fs/bpf";
static struct perf_event_mmap_page *headers[128];
static int done = 0;
static int pmu_fds[128];
static int filter_settings_fd;
static int threshold = 5000;

void add_new_filter(struct settings *sourceinfo, int count)
{
    struct lpm_v4_key key;
    key.prefixlen = 32;
    memcpy(&key.address, &sourceinfo->data.ip_src, sizeof(key.address));
    int value = 0;
    bpf_map_update_elem(filter_settings_fd, &key, &value, BPF_ANY);

    struct in_addr in;
    in.s_addr = sourceinfo->data.ip_src;
    char *ip = inet_ntoa(in);

    char *protocol;

    if (sourceinfo->data.protocol == 17)
    {
        protocol = "UDP";
    }
    else if (sourceinfo->data.protocol == 6)
    {
        protocol = "TCP";
    }
    else if (sourceinfo->data.protocol == 1)
    {
        protocol = "ICMP";
    }
    else if (sourceinfo->data.protocol == 0)
    {
        protocol = "Not specified";
    }
    else
    {
        protocol = "Unknown";
    }
    struct timeval tv;
    gettimeofday(&tv, NULL);
    time_t ltime = tv.tv_sec;
    struct tm *p;
    struct tm buf;
    char timestring[100];

    if (NULL != (p = localtime_r(&ltime, &buf)))
    {
        strftime(timestring, sizeof(timestring), "%c", p);
        printf("%s\n", timestring);
    }
    printf("Detected abnormal number of packets(%d). \nSending filter data: IP %s Protocol %s Port %d\n",
           count, ip, protocol, sourceinfo->data.port_src, key);
}

static struct timeval last_log;
static struct log_and_count log_copy[1000];

static int monitor_packets(void *data, int size)
{

    struct timeval tv;
    gettimeofday(&tv, NULL);
    time_t ltime = tv.tv_sec;
    struct tm *p;
    struct tm buf;
    char timestring[100];

    if (NULL != (p = localtime_r(&ltime, &buf)))
    {
        strftime(timestring, sizeof(timestring), "%c", p);
        printf("%s", timestring);
    }

    struct log *e = data;
    int i, err;

    if (e->cookie != 0xdead)
    {
        printf("BUG cookie %x sized %d\n",
               e->cookie, size);
        return LIBBPF_PERF_EVENT_ERROR;
    }

    for (int i = 0; i < 1000; i++)
    {
        if (log_copy[i].log.data.ip_dest == e->data.ip_dest &&
            log_copy[i].log.data.ip_src == e->data.ip_src &&
            log_copy[i].log.data.ip6_src.__in6_u.__u6_addr32[0] == log_copy[i].log.data.ip6_src.__in6_u.__u6_addr32[0] &&
            log_copy[i].log.data.ip6_src.__in6_u.__u6_addr32[1] == log_copy[i].log.data.ip6_src.__in6_u.__u6_addr32[1] &&
            log_copy[i].log.data.ip6_src.__in6_u.__u6_addr32[2] == log_copy[i].log.data.ip6_src.__in6_u.__u6_addr32[2] &&
            log_copy[i].log.data.ip6_src.__in6_u.__u6_addr32[3] == log_copy[i].log.data.ip6_src.__in6_u.__u6_addr32[3] &&
            log_copy[i].log.data.port_dest == e->data.port_dest &&
            log_copy[i].log.data.port_src == e->data.port_src &&
            log_copy[i].log.data.protocol == e->data.protocol)
        {
            log_copy[i].count++;
            break;
        }
        else if (log_copy[i].log.cookie == 0)
        {
            log_copy[i].log = *e;
            break;
        }
    }

    if (last_log.tv_sec + 1 <= tv.tv_sec)
    {
        for (int i = 0; i < threshold; i++)
        {
            if (log_copy[i].log.cookie != 0)
            {
                if (log_copy[i].count > 5000)
                {
                    struct settings *s = malloc(sizeof(struct settings));
                    s->data = log_copy[i].log.data;
                    s->state = 1;
                    add_new_filter(s, log_copy[i].count);
                }
            }
            else
            {
                break;
            }
        }
        last_log = tv;
        memset(log_copy, 0, sizeof(log_copy));
    }

    struct in_addr inadr;
    inadr.s_addr = e->data.ip_src;

    char *protocol;
    if (e->data.protocol == 17)
    {
        protocol = "UDP";
    }
    else if (e->data.protocol == 6)
    {
        protocol = "TCP";
    }
    else if (e->data.protocol == 1)
    {
        protocol = "ICMP";
    }
    else if (e->data.protocol == 0)
    {
        protocol = "Not specified";
    }
    else
    {
        protocol = e->data.protocol;
    }

    if (e->data.ip_version == 6)
    {
        char *ipv6_src = malloc(256);
        inet_ntop(AF_INET6, e->data.ip6_src.__in6_u.__u6_addr16, ipv6_src, INET6_ADDRSTRLEN);

        if (e->data.protocol == 58)
        {
            printf(" IPv6: %s, Protocol: ICMPv6, length: %u %llu\n",
                   ipv6_src, e->pkt_len, e->ts_post - e->ts_pre);
        }
        else
        {
            printf(" IPv6: %s, Protocol: %s, Source port: %u, Destination Port: %u, length: %u %llu\n",
                   ipv6_src, protocol, htons(e->data.port_src), htons(e->data.port_dest), e->pkt_len, e->ts_post - e->ts_pre);
        }
    }
    else if (e->data.ip_version == 4)
    {
        if (e->data.protocol == 1)
        {
            printf(" IP: %s, Protocol: %s, Seq: %u, length: %u %llu\n",
                   inet_ntoa(inadr), protocol, htons(e->data.icmp_sequence), e->pkt_len, e->ts_post - e->ts_pre);
        }
        else
        {
            printf(" IP: %s, Protocol: %s, Source port: %u, Destination Port: %u, length: %u %llu\n",
                   inet_ntoa(inadr), protocol, htons(e->data.port_src), htons(e->data.port_dest), e->pkt_len, e->ts_post - e->ts_pre);
        }
    }
}

typedef enum bpf_perf_event_ret (*perf_event_print_fn)(void *data, int size);
struct perf_event_sample
{
    struct perf_event_header header;
    __u32 size;
    char data[];
};

static enum bpf_perf_event_ret
bpf_perf_event_print(struct perf_event_header *hdr, void *private_data)
{
    struct perf_event_sample *e = (struct perf_event_sample *)hdr;
    perf_event_print_fn fn = private_data;
    int ret;

    if (e->header.type == PERF_RECORD_SAMPLE)
    {
        ret = fn(e->data, e->size);
        if (ret != LIBBPF_PERF_EVENT_CONT)
            return ret;
    }
    else if (e->header.type == PERF_RECORD_LOST)
    {
        struct
        {
            struct perf_event_header header;
            __u64 id;
            __u64 lost;
        } *lost = (void *)e;
        printf("lost %lld events\n", lost->lost);
    }
    else
    {
        printf("unknown event type=%d size=%d\n",
               e->header.type, e->header.size);
    }

    return LIBBPF_PERF_EVENT_CONT;
}

static int page_size;
static int page_cnt = 16;

int perf_event_mmap_header(int fd, struct perf_event_mmap_page **header)
{
    void *base;
    int mmap_size;

    page_size = getpagesize();
    mmap_size = page_size * (page_cnt + 1);

    base = mmap(NULL, mmap_size, PROT_READ | PROT_WRITE, MAP_SHARED, fd, 0);
    if (base == MAP_FAILED)
    {
        printf("mmap err\n");
        return -1;
    }

    *header = base;
    return 0;
}

int perf_event_poller_multi(int *fds, struct perf_event_mmap_page **headers,
                            int num_fds, perf_event_print_fn output_fn,
                            int *done)
{
    enum bpf_perf_event_ret ret;
    struct pollfd *pfds;
    void *buf = NULL;
    size_t len = 0;
    int i;

    pfds = calloc(num_fds, sizeof(*pfds));
    if (!pfds)
        return LIBBPF_PERF_EVENT_ERROR;

    for (i = 0; i < num_fds; i++)
    {
        pfds[i].fd = fds[i];
        pfds[i].events = POLLIN;
    }
    while (!*done)
    {
        poll(pfds, num_fds, 1);
        for (i = 0; i < num_fds; i++)
        {
            ret = bpf_perf_event_read_simple(headers[i],
                                             page_cnt * page_size,
                                             page_size, &buf, &len,
                                             bpf_perf_event_print,
                                             output_fn);
            if (ret != LIBBPF_PERF_EVENT_CONT)
            {
                break;
            }
        }
    }
    free(buf);
    free(pfds);

    return ret;
}

int main(int argc, char **argv)
{
    int threshold = 500;
    int interval = 5;
    char *device = malloc(256);

    if (argc >= 2)
    {
        device = argv[1];
    }
    else
    {
        printf("Please specify the network device.\n");
        return;
    }
    /*
        for (int i = 1; i < argc; i++)
        {
            if (!strcmp(argv[i - 1], "--inv"))
            {
                interval = atoi(argv[i]);
            }
            else if (!strcmp(argv[i - 1], "--th"))
            {
                threshold = atoi(argv[i]);
            }
        }
    */
    struct bpf_map_info map_expect = {0};
    struct bpf_map_info info = {0};
    char pin_dir[4096];
    int len, err;

    len = snprintf(pin_dir, 4096, "%s", pin_basedir);
    if (len < 0)
    {
        fprintf(stderr, "ERR: creating pin dirname\n");
        return EXIT_FAIL_OPTION;
    }

    char *directory = malloc(256);
    strcpy(directory, device);
    strcat(directory, "/blacklist");
    filter_settings_fd = open_bpf_map_file(pin_dir, directory, &info);
    if (filter_settings_fd < 0)
    {
        return EXIT_FAIL_BPF;
    }

    strcpy(directory, device);
    strcat(directory, "/logger");
    int logger_fd = 0;
    logger_fd = open_bpf_map_file(pin_dir, directory, &info);
    if (logger_fd < 0)
    {
        return EXIT_FAIL_BPF;
    }

    struct perf_event_attr attr = {
        .sample_type = PERF_SAMPLE_RAW,
        .type = PERF_TYPE_SOFTWARE,
        .config = PERF_COUNT_SW_BPF_OUTPUT,
        .wakeup_events = 1,
    };

    int i;
    int num = libbpf_num_possible_cpus();
    for (i = 0; i < num; i++)
    {
        int key = i;

        pmu_fds[i] = sys_perf_event_open(&attr, -1, i, -1, 0);

        assert(pmu_fds[i] >= 0);
        assert(bpf_map_update_elem(logger_fd, &key, &pmu_fds[i], BPF_ANY) == 0);
        ioctl(pmu_fds[i], PERF_EVENT_IOC_ENABLE, 0);
    }

    for (i = 0; i < num; i++)
    {
        if (perf_event_mmap_header(pmu_fds[i], &headers[i]) < 0)
        {
            return 1;
        }
    }

    gettimeofday(&last_log, NULL);
    memset(log_copy, 0, sizeof(log_copy));
    int ret = perf_event_poller_multi(pmu_fds, headers, num, monitor_packets, &done);

    return 0;
}