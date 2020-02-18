/* config.h.  Generated from config.h.in by configure.  */
/*
 * Copyright (c) 2017  Jordan Ritter <jpr5@darkridge.com>
 *
 * Please refer to the LICENSE file for more information.
 *
 */

#define USE_PCRE 0
#define USE_IPv6 0
#define USE_TCPKILL 0
#define USE_VLAN_HACK 1

#define HAVE_DLT_RAW 1
#define HAVE_DLT_PFLOG 1
#define HAVE_DLT_LOOP 1
#define HAVE_DLT_LINUX_SLL 1
#define HAVE_DLT_IEEE802_11 1
#define HAVE_DLT_IEEE802_11_RADIO 1
#define HAVE_DLT_IPNET 1

#define USE_PCAP_RESTART 0
#if USE_PCAP_RESTART
#define PCAP_RESTART_FUNC 
extern void PCAP_RESTART_FUNC();
#endif

#define USE_DROPPRIVS 1
#define DROPPRIVS_USER "nobody"
