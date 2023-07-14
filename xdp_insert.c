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

struct flow
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

const char *pin_basedir = "/sys/fs/bpf";

void print_filter_settings(int map_fd)
{
    struct settings *buf = malloc(sizeof(struct settings));
    __u32 key;

    printf("===List of filter settings===\n");
    for (int i = 50; i < 550; i++)
    {
        memset(buf, 0, sizeof(struct settings));
        key = i;
        int error = bpf_map_lookup_elem(map_fd, &key, buf);
        if (buf->state != 0)
        {
            char *packetAction;
            if (buf->state == 1)
            {
                packetAction = "BLOCK";
            }
            else if (buf->state == 2)
            {
                packetAction = "ALLOW";
            }
            else
            {
                packetAction = "ERROR";
            }

            struct in_addr *source = (struct in_addr *)malloc(sizeof(struct in_addr));
            struct in_addr *dest = (struct in_addr *)malloc(sizeof(struct in_addr));
            source->s_addr = buf->data.ip_src;
            dest->s_addr = buf->data.ip_dest;
            char *source_ip = inet_ntoa(*source);
            // printf("%s\n", source_ip);
            char *dest_ip = "Tempolarily unavailable"; // inet_ntoa(*dest);
            // printf("%s\n", source_ip);
            char *protocol;

            if (buf->data.protocol == 17)
            {
                protocol = "UDP";
            }
            else if (buf->data.protocol == 6)
            {
                protocol = "TCP";
            }
            else if (buf->data.protocol == 1)
            {
                protocol = "ICMP";
            }
            else if (buf->data.protocol == 0)
            {
                protocol = "Not specified";
            }
            else
            {
                protocol = "Unknown";
            }

            if (error < 0)
            {
                printf("Unable to read filter data");
            }
            else if (buf->data.ip_version == 4)
            {
                if (buf->data.protocol == 1)
                {
                    printf("%d: %s Source IP %s Destination IP %s Protocol %s\n",
                           key - 50, packetAction, source_ip, dest_ip, protocol);
                }
                else if (buf->data.source_cidr != 0)
                {
                    printf("%d: %s Source IP %s/%d Destination IP %s Protocol %s Source Port %d Destination Port %d\n",
                           key - 50, packetAction, source_ip, buf->data.source_cidr, dest_ip, protocol, buf->data.port_src, buf->data.port_dest);
                }
                else
                {
                    printf("%d: %s Source IP %s Destination IP %s Protocol %s Source Port %d Destination Port %d\n",
                           key - 50, packetAction, source_ip, dest_ip, protocol, buf->data.port_src, buf->data.port_dest);
                }
            }
            else if (buf->data.ip_version == 6)
            {
                char *ipv6_src = malloc(256);
                ipv6_src = inet_ntop(AF_INET6, buf->data.ip6_src.__in6_u.__u6_addr16, ipv6_src, INET6_ADDRSTRLEN);

                char *ipv6_dest = malloc(256);
                ipv6_dest = inet_ntop(AF_INET6, buf->data.ip6_dest.__in6_u.__u6_addr16, ipv6_dest, INET6_ADDRSTRLEN);

                if (buf->data.protocol == 58)
                {
                    printf("%d: %s Source IP %s Destination IP %s Protocol %s\n",
                           key - 50, packetAction, ipv6_src, ipv6_dest, protocol);
                }
                else if (buf->data.source_cidr != 0)
                {
                    printf("%d: %s Source IP %s/%d Destination IP %s Protocol %s Source Port %d Destination Port %d\n",
                           key - 50, packetAction, ipv6_src, buf->data.source_cidr, ipv6_dest, protocol, buf->data.port_src, buf->data.port_dest);
                }
                else
                {
                    printf("%d: %s Source IP %s Destination IP %s Protocol %s Source Port %d Destination Port %d\n",
                           key - 50, packetAction, ipv6_src, ipv6_dest, protocol, buf->data.port_src, buf->data.port_dest);
                }
            }
        }
        break;
    }
}

void add_new_filter_cmd(int map_fd, struct settings *udef)
{
    struct settings *buf = malloc(sizeof(struct settings));
    __u32 key;

    for (int i = 50; i < 550; i++)
    {
        key = i;
        bpf_map_lookup_elem(map_fd, &key, buf);
        if (buf->state == 0)
        {
            int err = bpf_map_update_elem(map_fd, &key, udef, BPF_ANY);

            char *packetAction;
            if (udef->state == 1)
            {
                packetAction = "BLOCK";
            }
            else if (udef->state == 2)
            {
                packetAction = "ALLOW";
            }
            else
            {
                packetAction = "";
            }

            struct in_addr *source = (struct in_addr *)malloc(sizeof(struct in_addr));
            struct in_addr *dest = (struct in_addr *)malloc(sizeof(struct in_addr));
            source->s_addr = udef->data.ip_src;
            dest->s_addr = udef->data.ip_dest;
            char *source_ip = inet_ntoa(*source);
            // printf("%s\n", source_ip);
            char *dest_ip = inet_ntoa(*dest); // inet_ntoa(*dest);
            // printf("%s\n", source_ip);
            char *protocol;

            if (udef->data.protocol == 17)
            {
                protocol = "UDP";
            }
            else if (udef->data.protocol == 6)
            {
                protocol = "TCP";
            }
            else if (udef->data.protocol == 1)
            {
                protocol = "ICMP";
            }
            else if (udef->data.protocol == 0)
            {
                protocol = "Not specified";
            }
            else
            {
                protocol = "Unknown";
            }

            if (err < 0)
            {
                printf("Unable to send filter data: IP %s Protocol %s Port %d\n",
                       source_ip, protocol, udef->data.port_src);
            }
            else
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
                    printf("%s\n", timestring);
                }

                if (udef->data.ip_version == 4)
                {
                    if (udef->data.protocol == 1)
                    {
                        printf("Adding to index %d: %s Source IP %s Destination IP %s Protocol %s\n",
                               key - 50, packetAction, source_ip, dest_ip, protocol);
                    }
                    else if (udef->data.source_cidr != 0)
                    {
                        printf("Adding to index %d: %s Source IP %s/%d Destination IP %s Protocol %s Source Port %d Destination Port %d\n",
                               key - 50, packetAction, source_ip, udef->data.source_cidr, dest_ip, protocol, udef->data.port_src, udef->data.port_dest);
                    }
                    else
                    {
                        printf("Adding to index %d: %s Source IP %s Destination IP %s Protocol %s Source Port %d Destination Port %d\n",
                               key - 50, packetAction, source_ip, dest_ip, protocol, udef->data.port_src, udef->data.port_dest);
                    }
                }
                else if (udef->data.ip_version == 6)
                {
                    char *ipv6_src = malloc(256);
                    ipv6_src = inet_ntop(AF_INET6, udef->data.ip6_src.__in6_u.__u6_addr16, ipv6_src, INET6_ADDRSTRLEN);

                    char *ipv6_dest = malloc(256);
                    ipv6_dest = inet_ntop(AF_INET6, udef->data.ip6_dest.__in6_u.__u6_addr16, ipv6_dest, INET6_ADDRSTRLEN);

                    if (udef->data.protocol == 58)
                    {
                        printf("Adding to index %d: %s Source IP %s Destination IP %s Protocol %s\n",
                               key - 50, packetAction, ipv6_src, ipv6_dest, protocol);
                    }
                    else if (udef->data.source_cidr != 0)
                    {
                        printf("Adding to index %d: %s Source IP %s/%d Destination IP %s Protocol %s Source Port %d Destination Port %d\n",
                               key - 50, packetAction, ipv6_src, udef->data.source_cidr, ipv6_dest, protocol, udef->data.port_src, udef->data.port_dest);
                    }
                    else
                    {
                        printf("Adding to index %d: %s Source IP %s Destination IP %s Protocol %s Source Port %d Destination Port %d\n",
                               key - 50, packetAction, ipv6_src, ipv6_dest, protocol, udef->data.port_src, udef->data.port_dest);
                    }
                }
            }
            break;
        }
        else if (udef->data.ip_src == buf->data.ip_src && udef->data.ip_dest == buf->data.ip_dest &&
                 udef->data.ip6_src.__in6_u.__u6_addr32[0] == buf->data.ip6_src.__in6_u.__u6_addr32[0] &&
                 udef->data.ip6_src.__in6_u.__u6_addr32[1] == buf->data.ip6_src.__in6_u.__u6_addr32[1] &&
                 udef->data.ip6_src.__in6_u.__u6_addr32[2] == buf->data.ip6_src.__in6_u.__u6_addr32[2] &&
                 udef->data.ip6_src.__in6_u.__u6_addr32[3] == buf->data.ip6_src.__in6_u.__u6_addr32[3] &&
                 udef->data.port_dest == buf->data.port_dest && udef->data.port_src == buf->data.port_src &&
                 udef->data.protocol == buf->data.protocol)
        {
            break;
        }
    }
}

void add_new_filter_file(int map_fd, char *path)
{
    struct settings *buf = malloc(sizeof(struct settings));
    memset(buf, 0, sizeof(struct settings));

    // read from file and add to map
    FILE *fp;              // file pointer
    char tmpline[256];     // temporary space
    fp = fopen(path, "r"); // open a file
    if (fp != NULL)
    {
        char *separator = " "; // collection of separator characters
                               // note that there is a space in the
                               // separators
        char *tmp;             // secure address to store current splitting position
        char *token;
        int count = 0;

        while (fgets(tmpline, 256, fp))
        {
            token = strtok_r(tmpline, separator, &tmp); // returns the first word.
            count = 0;
            memset(buf, 0, sizeof(struct settings));
            while (token != NULL)
            {
                if (count == 0)
                {
                    if (strcmp("BLOCK", token) == 0)
                    {
                        buf->state = 1;
                    }
                    else if (strcmp("ALLOW", token) == 0)
                    {
                        buf->state = 2;
                    }
                    else
                    {
                        printf("Unable to read filter setting.");
                        return;
                    }
                }
                else if (count == 1)
                {
                    if (strcmp("ANY", token) == 0)
                    {
                        buf->data.ip_src = 0;
                    }
                    else
                    {
                        char ip_address[120];
                        int cidr = 0;
                        char *slash = strchr(token, '/');

                        if (slash != NULL)
                        {
                            sscanf(token, "%15[^/]/%d", ip_address, &cidr);
                        }
                        else
                        {
                            strncpy(ip_address, token, sizeof(ip_address));
                            ip_address[sizeof(ip_address) - 1] = '\0';
                        }
                        if (inet_pton(AF_INET, ip_address, &buf->data.ip_src) == 1)
                        {
                            struct in_addr *temp = malloc(sizeof(struct in_addr));
                            int err = inet_aton(ip_address, temp);
                            buf->data.ip_src = temp->s_addr;
                            printf("%d", buf->data.ip_src);
                            buf->data.ip_version = 4;
                            buf->data.source_cidr = cidr;
                        }
                        else if (inet_pton(AF_INET6, ip_address, &buf->data.ip6_src) == 1)
                        {
                            buf->data.ip_version = 6;
                        }
                        else
                        {
                            printf("Input is not a valid IP address\n");
                        }
                    }
                }
                else if (count == 2)
                {
                    if (strcmp("ANY", token) == 0)
                    {
                        buf->data.ip_dest = 0;
                    }
                    else
                    {
                        char ip_address[16];
                        int cidr = 0;
                        char *slash = strchr(token, '/');

                        if (slash != NULL)
                        {
                            sscanf(token, "%15[^/]/%d", ip_address, &cidr);
                        }
                        else
                        {
                            strncpy(ip_address, token, sizeof(ip_address));
                            ip_address[sizeof(ip_address) - 1] = '\0';
                        }
                        struct in_addr *temp = malloc(sizeof(struct in_addr));
                        int err = inet_aton(ip_address, temp);
                        if (err == -1)
                        {
                            printf("Unable to read the IP address. Please check if the IP address is valid.");
                            return;
                        }
                        buf->data.ip_dest = temp->s_addr;
                        buf->data.dest_cidr = cidr;
                    }
                }
                else if (count == 3)
                {
                    if (strcmp("ANY", token) == 0)
                    {
                        buf->data.protocol = 0;
                    }
                    else
                    {
                        buf->data.protocol = atoi(token);
                    }
                }
                else if (count == 4)
                {
                    if (strcmp("ANY", token) == 0)
                    {
                        buf->data.port_src = 0;
                    }
                    else
                    {
                        buf->data.port_src = atoi(token);
                    }
                }
                else if (count == 5)
                {

                    if (strcmp("ANY", token) == 0)
                    {
                        buf->data.port_dest = 0;
                        // printf("Testing... Source IP %d Destination IP %d Protocol %d Source Port %d Destination Port %d\n",
                        //       buf->ip_src, buf->ip_dest, buf->protocol, buf->port_src, buf->port_dest);
                        add_new_filter_cmd(map_fd, buf);
                    }
                    else
                    {
                        buf->data.port_dest = atoi(token);
                        // printf("Testing... Source IP %d Destination IP %d Protocol %d Source Port %d Destination Port %d\n",
                        //        buf->ip_src, buf->ip_dest, buf->protocol, buf->port_src, buf->port_dest);
                        add_new_filter_cmd(map_fd, buf);
                    }
                }
                token = strtok_r(NULL, separator, &tmp);
                count++;
            }
            if (count != 6)
            {
                printf("Your filter setting does not follow the specified format. The filter setting must to be in the form of: ALLOW/BLOCK source_IP dest_IP PROTOCOL source_PORT dest_PORT");
            }
        }
        fclose(fp);
        return;
    }
}

int delete_filter_settings_index(int map_fd, int index)
{
    index += 50;
    __u32 *key = &index;
    struct settings *buf = malloc(sizeof(struct settings));
    memset(buf, 0, sizeof(struct settings));
    int error = 0;
    int prevIndex = 0;
    for (int i = *key + 1; i < 550; i++)
    {
        prevIndex = i - 1;
        memset(buf, 0, sizeof(struct settings));
        error = bpf_map_lookup_elem(map_fd, &i, buf);
        if (error < 0)
        {
            return error;
        }
        else if (buf->state == 0)
        {
            bpf_map_update_elem(map_fd, &prevIndex, buf, BPF_ANY);
            return 0;
        }

        error = bpf_map_update_elem(map_fd, &prevIndex, buf, BPF_ANY);
        if (error < 0)
        {
            return error;
        }
    }
    return 0;
}

int delete_filter_settings_all(int map_fd)
{
    struct settings *buf = malloc(sizeof(struct settings));
    memset(buf, 0, sizeof(struct settings));
    int error = 0;
    for (int key = 50; key < 550; key++)
    {
        memset(buf, 0, sizeof(struct settings));
        error = bpf_map_update_elem(map_fd, &key, buf, BPF_ANY);
        if (error < 0)
        {
            return error;
        }
    }
    return 0;
}

int main(int argc, char **argv)
{
    if (argc < 2)
    {
        printf("It is required to  have an option for this program.");
        return 0;
    }

    struct bpf_map_info map_expect = {0};
    struct bpf_map_info info = {0};
    char pin_dir[4096];
    int map_fd;
    int len, err;
    /* check map info, e.g. datarec is expected size */

    len = snprintf(pin_dir, 4096, "%s", pin_basedir);
    map_fd = open_bpf_map_file(pin_dir, "enp0s1/my_map", &info);
    if (map_fd < 0)
    {
        return EXIT_FAIL_BPF;
    }

    map_expect.key_size = sizeof(__u32);
    map_expect.value_size = sizeof(struct settings);
    map_expect.max_entries = 550;
    err = check_map_fd_info(&info, &map_expect);
    if (err)
    {
        fprintf(stderr, "ERR: map via FD not compatible\n");
        return err;
    }

    struct settings *buf = (struct settings *)malloc(sizeof(struct settings));

    for (int i = 1; i < argc; i++)
    {
        if (!strcmp(argv[i], "--A"))
        {
            for (int r = i + 1; r < i + 7; r++)
            {
                if (r == 2)
                {
                    if (strcmp("BLOCK", argv[r]) == 0)
                    {
                        buf->state = 1;
                    }
                    else if (strcmp("ALLOW", argv[r]) == 0)
                    {
                        buf->state = 2;
                    }
                    else
                    {
                        printf("Unable to read filter setting.");
                        return 0;
                    }
                }
                else if (r == 3)
                {
                    if (strcmp("ANY", argv[r]) == 0)
                    {
                        buf->data.ip_src = 0;
                        continue;
                    }

                    struct in_addr temp;
                    int err = inet_aton(argv[r], &temp);
                    if (err == -1)
                    {
                        printf("Unable to read the IP address. Please check if the IP address is valid.");
                        return 0;
                    }
                    buf->data.ip_src = temp.s_addr;
                }
                else if (r == 4)
                {
                    if (strcmp("ANY", argv[r]) == 0)
                    {
                        buf->data.ip_dest = 0;
                    }
                    else
                    {

                        struct in_addr temp;
                        int err = inet_aton(argv[r], &temp);
                        if (err == -1)
                        {
                            printf("Unable to read the IP address. Please check if the IP address is valid.");
                            return 0;
                        }
                        buf->data.ip_dest = temp.s_addr;
                    }
                }
                else if (r == 5)
                {
                    if (strcmp("ANY", argv[r]) == 0)
                    {
                        buf->data.protocol = 0;
                        continue;
                    }
                    else
                    {

                        buf->data.protocol = atoi(argv[r]);
                    }
                }
                else if (r == 6)
                {
                    if (strcmp("ANY", argv[r]) == 0)
                    {
                        buf->data.port_src = 0;
                        continue;
                    }
                    else
                    {

                        buf->data.port_src = atoi(argv[r]);
                    }
                }
                else if (r == 7)
                {

                    if (strcmp("ANY", argv[r]) == 0)
                    {
                        buf->data.port_dest = 0;
                        continue;
                    }
                    buf->data.port_dest = atoi(argv[r]);
                    add_new_filter_cmd(map_fd, buf);
                }
            }

            add_new_filter_cmd(map_fd, buf);
            break;
        }
        else if (!strcmp(argv[i], "--F"))
        {
            if (i + 1 < argc)
            {
                char *path = argv[i + 1];
                add_new_filter_file(map_fd, path);
                print_filter_settings(map_fd);
            }
            else
            {
                printf("Please specify the file path.\n");
                return 0;
            }
        }
        else if (!strcmp(argv[i], "--L"))
        {
            print_filter_settings(map_fd);
        }
        else if (!strcmp(argv[i], "--D"))
        {
            if (argc >= i + 1)
            {
                i++;
                int error = 0;
                if (!strcmp(argv[i], "ALL"))
                {
                    error = delete_filter_settings_all(map_fd);
                    if (error == -1)
                    {
                        printf("Unable to reset filter settings");
                    }
                }
                else
                {
                    error = delete_filter_settings_index(map_fd, atoi(argv[i]));
                    if (error == -1)
                    {
                        printf("Unable to delete a filter setting at index %d\n", atoi(argv[i]));
                    }
                }
                print_filter_settings(map_fd);
            }
        }
    }
}