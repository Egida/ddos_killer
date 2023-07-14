/* SPDX-License-Identifier: GPL-2.0 */
#include <stdio.h>
#include <stdlib.h>
#include <linux/bpf.h>
// #include <bpf/libbpf.h>
#include "libbpf/src/bpf_helpers.h"
#include "libbpf/src/bpf_endian.h"
#include <linux/if_ether.h>
#include <netinet/ip.h>
#include <math.h>

#ifndef __packed
#define __packed __attribute__((packed))
#endif

#ifndef lock_xadd
#define lock_xadd(ptr, val) ((void)__sync_fetch_and_add(ptr, val))
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

struct bpf_map_def SEC("maps") logger = {
    .type = BPF_MAP_TYPE_ARRAY,
    .key_size = sizeof(__u32),
    .value_size = sizeof(struct interval),
    .max_entries = 2,
};

struct bpf_map_def SEC("maps") blacklist = {
    .type = BPF_MAP_TYPE_LPM_TRIE,
    .key_size = sizeof(struct lpm_v4_key),
    .value_size = sizeof(__u32),
    .map_flags = BPF_F_NO_PREALLOC,
    .max_entries = 1000000,
};

/*struct bpf_map_def SEC("maps") data = {
    .type = BPF_MAP_TYPE_ARRAY,
    .key_size = sizeof(__u32),
    .value_size = sizeof(struct metadata),
    .max_entries = 1,
};*/

/*void __always_inline send_perf_event(struct xdp_md *ctx, struct log *tmp)
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
}*/

SEC("xdp_filter") // This is the typical "main" function replacement.
int xdp_filter_func(struct xdp_md *ctx)
{
        //__u64 ts = bpf_ktime_get_ns();
        //__u32 index = 0;
        /*struct metadata *metadata = bpf_map_lookup_elem(&data, &index);
        if (!metadata)
        { // check whether the map was able to find the key.
                return XDP_PASS;
        }*/

        //__u64 ts_initial = bpf_ktime_get_ns();
        struct flow tm;
        struct ethhdr *eth;
        struct iphdr *ip;
        __builtin_memset(&tm, 0, sizeof(struct flow));
        struct flow *tmp = &tm;

        // checks whether packet data format follows the definition of ethernet frame header
        eth = (void *)(long)ctx->data;
        // drop the packet if it doesn't
        if (ctx->data + sizeof(*eth) > ctx->data_end)
        {
                return XDP_DROP;
        }

        // Packet filtering process for IPv4
        if (eth->h_proto == bpf_htons(ETH_P_IP))
        {
                // checks whether packet data format follows the definition of ethernet frame header
                ip = (void *)(long)ctx->data + sizeof(*eth);
                // drop the packet if it doesn't
                if (ctx->data + sizeof(*eth) + sizeof(*ip) > ctx->data_end)
                {
                        return XDP_DROP;
                }

                // storing data for packet monitoring and other processing
                tmp->ip_src = ip->saddr;
                tmp->ip_dest = ip->daddr;

                // setting up variables to check if the IP for this packet is on the blacklist
                struct lpm_v4_key key;
                __builtin_memcpy(&key.address, &ip->saddr, sizeof(key.address));
                key.prefixlen = 32;
                if (bpf_map_lookup_elem(&blacklist, &key))
                {
                        return XDP_DROP;
                }

                // getting data from the bpf map
                __u32 invl_index = 1;
                struct interval *invl = bpf_map_lookup_elem(&logger, &invl_index);
                if (!invl)
                { // check whether the map was able to find the key.
                        return XDP_PASS;
                }

                // Checking to see if the interval is over
                /*if (ts > metadata->ts_initial + 1000000000)
                {
                        metadata->ts_initial = ts;
                        // For testing purposes
                        // bpf_printk("End of interval");

                        // implement code to calculate based on fast entropy approach
                        int packet_count = 0;
                        double value = 10.0;
                        for (int i = 0; i < 1000; i++)
                        {
                                if (invl->intervals[1].flow[i].packet_count > 0)
                                {
                                        packet_count = packet_count + invl->intervals[1].flow[i].packet_count;

                                        double p = (double)invl->intervals[1].flow[i].packet_count / metadata->packet_count;
                                        value = log10(p);

                                        invl->intervals[1].flow[i].entropy = value;
                                }
                                else
                                {
                                        break;
                                }
                        }
                        metadata->packet_count = packet_count;
                        // copy invl->intervals[1] to invl->intervals[0], and update bpf map
                }*/
                //int protocol = ip->protocol;
                for (int i = 0; i < 1000; i++)
                {
                        if (invl->flow[i].ip_src == tmp->ip_src)
                        {
                                //if (protocol == 17)
                                //{
                                        lock_xadd(&invl->flow[i].packet_count, 1);
                                        // bpf_printk("%d", invl->intervals[1].flow[i].ip_src);
                                //}
                                break;
                        }
                        else if (invl->flow[i].ip_src == 0)
                        {

                                //if (protocol == 17)
                                //{
                                        invl->flow[i].ip_src = tmp->ip_src;
                                        invl->flow[i].ip_dest = tmp->ip_dest;
                                        invl->flow[i].packet_count = 1;
                                        break;
                                //}
                        }
                }
                // bpf_printk("PASS %lld", bpf_ktime_get_ns() - ts_initial);

                // send_perf_event(ctx, tmp);
        }
        return XDP_PASS;
}

char _license[] SEC("license") = "GPL";
