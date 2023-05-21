/* SPDX-License-Identifier: GPL-2.0 */
#include <stdio.h>
#include <stdlib.h>
#include <linux/bpf.h>
#include "libbpf/src/bpf_helpers.h"
#include "libbpf/src/bpf_endian.h"
#include <linux/if_ether.h>
#include <linux/if_packet.h>
#include <netinet/ip.h>
#include <netinet/ip6.h>
#include <linux/ipv6.h>
#include <linux/icmpv6.h>
#include <linux/tcp.h>
#include <netinet/ip_icmp.h>
#include <linux/udp.h>
#include <string.h>
#include <netinet/in.h>
#include <arpa/inet.h>

#define MAX_MAP_INDEX 549
#define MAX_BUF_INDEX 49

#ifndef __packed
#define __packed __attribute__((packed))
#endif

#define SAMPLE_SIZE 1024ul

#define min(x, y) ((x) < (y) ? (x) : (y))

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

struct bpf_map_def SEC("maps") my_map = {
    .type = BPF_MAP_TYPE_ARRAY,
    .key_size = sizeof(__u32),
    .value_size = sizeof(struct settings),
    .max_entries = MAX_MAP_INDEX + 1,
};

struct bpf_map_def SEC("maps") logger = {
    .type = BPF_MAP_TYPE_PERF_EVENT_ARRAY,
    .key_size = sizeof(int),
    .value_size = sizeof(__u32),
    .max_entries = 128,
};

void __always_inline send_perf_event(struct xdp_md *ctx, struct log *tmp)
{
        void *data_end = (void *)(long)ctx->data_end;
        void *data = (void *)(long)ctx->data;

        if (data < data_end)
        {
                int ret;
                struct log *metadata = tmp;

                metadata->cookie = 0xdead;
                metadata->pkt_len = (__u16)(data_end - data);
                metadata->ts_post = bpf_ktime_get_ns();

                ret = bpf_perf_event_output(ctx, &logger, BPF_F_CURRENT_CPU, metadata, sizeof(struct log));
                if (ret)
                {
                        bpf_printk("ERROR: %d %lu %d\n", ret, BPF_F_CURRENT_CPU, metadata->ts_post - metadata->ts_pre);
                }
        }
}

SEC("xdp_filter")
int xdp_filter_func(struct xdp_md *ctx)
{
        struct log tm;
        memset(&tm, 0, sizeof(struct log));
        struct log *tmp = &tm;
        tmp->ts_pre = bpf_ktime_get_ns();

        struct ethhdr *eth = (void *)(long)ctx->data;
        if (ctx->data + sizeof(*eth) > ctx->data_end)
        {
                return XDP_PASS;
        }

        if (eth->h_proto == bpf_htons(ETH_P_IP))
        {

                struct iphdr *ip = (void *)(long)ctx->data + sizeof(*eth);
                if (ctx->data + sizeof(*eth) + sizeof(*ip) > ctx->data_end)
                {
                        return XDP_PASS;
                }

                tmp->data.protocol = ip->protocol;
                if (tmp->data.protocol == 6)
                {
                        struct tcphdr *tcp = (void *)ip + sizeof(*ip);
                        if (ctx->data + sizeof(*eth) + sizeof(*ip) + sizeof(*tcp) > ctx->data_end)
                        {
                                return XDP_ABORTED;
                        }
                        tmp->data.port_dest = tcp->dest;
                        tmp->data.port_src = tcp->source;
                }
                else if (tmp->data.protocol == 17)
                {
                        struct udphdr *udp = (void *)ip + sizeof(*ip);
                        if (ctx->data + sizeof(*eth) + sizeof(*ip) + sizeof(*udp) > ctx->data_end)
                        {
                                return XDP_ABORTED;
                        }
                        tmp->data.port_dest = udp->dest;
                        tmp->data.port_src = udp->source;
                }
                else if (tmp->data.protocol == 1)
                {
                        struct icmphdr *icmp = (void *)ip + sizeof(*ip);
                        if (ctx->data + sizeof(*eth) + sizeof(*ip) + sizeof(*icmp) > ctx->data_end)
                        {
                                return XDP_ABORTED;
                        }
                        tmp->data.icmp_sequence = icmp->un.echo.sequence;
                }

                tmp->data.ip_src = ip->saddr;
                tmp->data.ip_dest = ip->daddr;
                tmp->data.ip_version = 4;

        } else if (eth->h_proto == bpf_htons(ETH_P_IPV6)) {

                struct ipv6hdr *ip = (void *)(long)ctx->data + sizeof(*eth);
                if (ctx->data + sizeof(*eth) + sizeof(*ip) > ctx->data_end)
                {
                        return XDP_PASS;
                }

                tmp->data.protocol = ip->nexthdr;
                if (tmp->data.protocol == 6)
                {
                        struct tcphdr *tcp = (void *)ip + sizeof(*ip);
                        if (ctx->data + sizeof(*eth) + sizeof(*ip) + sizeof(*tcp) > ctx->data_end)
                        {
                                return XDP_ABORTED;
                        }
                        tmp->data.port_dest = tcp->dest;
                        tmp->data.port_src = tcp->source;
                }
                else if (tmp->data.protocol == 17)
                {
                        struct udphdr *udp = (void *)ip + sizeof(*ip);
                        if (ctx->data + sizeof(*eth) + sizeof(*ip) + sizeof(*udp) > ctx->data_end)
                        {
                                return XDP_ABORTED;
                        }
                        tmp->data.port_dest = udp->dest;
                        tmp->data.port_src = udp->source;
                }
                else if (tmp->data.protocol == 58)
                {
                        struct icmp6hdr *icmp = (void *)ip + sizeof(*ip);
                        if (ctx->data + sizeof(*eth) + sizeof(*ip) + sizeof(*icmp) > ctx->data_end)
                        {
                                return XDP_ABORTED;
                        }
                }
                tmp->data.ip6_src = ip->saddr;
                tmp->data.ip6_dest = ip->daddr;
                tmp->data.ip_version = 6;

        } else {
                return XDP_PASS;
        }

        for (int i = MAX_BUF_INDEX + 1; i <= MAX_MAP_INDEX; i++)
        {
                __u32 key = i;
                struct settings *rule = bpf_map_lookup_elem(&my_map, &key);
                if (!rule)
                { // check whether the map was able to find the key.
                        return XDP_PASS;
                }

                if (rule->state != 0)
                {
                        int check_match = 0;
                        if (rule->data.ip_src != 0)
                        {

                                if (rule->data.source_cidr != 0)
                                {
                                        unsigned int packet_ip_processed = bpf_htonl(tmp->data.ip_src) >> (32 - rule->data.source_cidr);
                                        unsigned int filter_ip_processed = bpf_htonl(rule->data.ip_src) >> (32 - rule->data.source_cidr);

                                        if (filter_ip_processed ^ packet_ip_processed)
                                        {
                                                check_match++;
                                        }
                                }
                                else if (tmp->data.ip_src != rule->data.ip_src)
                                {
                                        check_match++;
                                }
                        }
                        if (rule->data.ip_dest != 0)
                        {
                                if (rule->data.dest_cidr != 0)
                                {
                                        unsigned int packet_ip_processed = bpf_htonl(tmp->data.ip_dest) >> (32 - rule->data.dest_cidr);
                                        unsigned int filter_ip_processed = bpf_htonl(rule->data.ip_dest) >> (32 - rule->data.dest_cidr);

                                        if (filter_ip_processed ^ packet_ip_processed)
                                        {
                                                check_match++;
                                        }
                                }
                                else if (tmp->data.ip_dest != rule->data.ip_dest)
                                {
                                        check_match++;
                                }
                        }
/*
                        if (rule->data.ip6_src.__in6_u.__u6_addr16[0] != 0) {
                                if (    tmp->data.ip6_src.__in6_u.__u6_addr16[0] != rule->data.ip6_src.__in6_u.__u6_addr16[0] &&
                                        tmp->data.ip6_src.__in6_u.__u6_addr16[1] != rule->data.ip6_src.__in6_u.__u6_addr16[1] &&
                                        tmp->data.ip6_src.__in6_u.__u6_addr16[2] != rule->data.ip6_src.__in6_u.__u6_addr16[2] &&
                                        tmp->data.ip6_src.__in6_u.__u6_addr16[3] != rule->data.ip6_src.__in6_u.__u6_addr16[3])
                                {
                                        check_match++;
                                }
                        }

                        if (rule->data.ip6_dest.__in6_u.__u6_addr16[0] != 0) {
                                if (    tmp->data.ip6_dest.__in6_u.__u6_addr16[0] != rule->data.ip6_dest.__in6_u.__u6_addr16[0] &&
                                        tmp->data.ip6_dest.__in6_u.__u6_addr16[1] != rule->data.ip6_dest.__in6_u.__u6_addr16[1] &&
                                        tmp->data.ip6_dest.__in6_u.__u6_addr16[2] != rule->data.ip6_dest.__in6_u.__u6_addr16[2] &&
                                        tmp->data.ip6_dest.__in6_u.__u6_addr16[3] != rule->data.ip6_dest.__in6_u.__u6_addr16[3])
                                {
                                        check_match++;
                                }
                        }
*/
                        if (rule->data.protocol != 0)
                        {
                                if (tmp->data.protocol != rule->data.protocol)
                                {
                                        check_match++;
                                }
                        }

                        if (rule->data.port_src != 0)
                        {
                                if (tmp->data.port_src != rule->data.port_src)
                                {
                                        check_match++;
                                }
                        }

                        if (rule->data.port_dest != 0)
                        {
                                if (tmp->data.port_dest != rule->data.port_dest)
                                {
                                        check_match++;
                                }
                        }

                        if (check_match == 0)
                        {
                                if (rule->state == 1)
                                {
                                        return XDP_DROP;
                                }
                                else if (rule->state == 2)
                                {
                                        send_perf_event(ctx, tmp);
                                        return XDP_PASS;
                                }
                        }
                }
        }
        send_perf_event(ctx, tmp);
        return XDP_PASS;
}

char _license[] SEC("license") = "GPL";
