# Задание 23 (VPN)

Стенд состоит из двух виртульных машин `servervpn` и `clientvpn`.
    
Необходимо:

1. Настроить VPN между этим виртальными машинами в tun/tap режимах. Замерить скорость в туннелях и сделать вывод об отличающихся показателях.

2. Поднять RAS на базе OpenVPN с клиентскими сертификатами и подключиься с локальной машины к VM.

После выполнения команды `vagrant up`, стенд поднимается с настроеным OpenVPN в режиме `tap`.

Выполним замер скорости в туннел:

```bash
root@servervpn:~# ip a |grep tap
5: tap0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc fq_codel state UNKNOWN group default qlen 1000
    inet 10.10.10.1/24 scope global tap0
root@servervpn:~# iperf3 -s &
[1] 3278
root@servervpn:~# -----------------------------------------------------------
Server listening on 5201
-----------------------------------------------------------
Accepted connection from 10.10.10.2, port 44668
[  5] local 10.10.10.1 port 5201 connected to 10.10.10.2 port 44680
[ ID] Interval           Transfer     Bitrate
[  5]   0.00-1.00   sec   467 KBytes  3.82 Mbits/sec                  
[  5]   1.00-2.00   sec   470 KBytes  3.84 Mbits/sec                  
[  5]   2.00-3.00   sec   493 KBytes  4.05 Mbits/sec                  
[  5]   3.00-4.01   sec   644 KBytes  5.24 Mbits/sec                  
[  5]   4.01-5.01   sec   606 KBytes  4.97 Mbits/sec                  
[  5]   5.01-6.00   sec   639 KBytes  5.25 Mbits/sec                  
[  5]   6.00-7.00   sec   680 KBytes  5.56 Mbits/sec                  
[  5]   7.00-8.00   sec   706 KBytes  5.79 Mbits/sec                  
[  5]   8.00-9.00   sec   388 KBytes  3.18 Mbits/sec                  
[  5]   9.00-10.00  sec   437 KBytes  3.58 Mbits/sec                  
[  5]  10.00-11.00  sec   537 KBytes  4.39 Mbits/sec                  
[  5]  11.00-12.00  sec   618 KBytes  5.07 Mbits/sec                  
[  5]  12.00-13.00  sec   472 KBytes  3.86 Mbits/sec                  
[  5]  13.00-14.00  sec   254 KBytes  2.08 Mbits/sec                  
[  5]  14.00-15.01  sec  0.00 Bytes  0.00 bits/sec                  
[  5]  15.01-16.00  sec  1.43 MBytes  12.0 Mbits/sec                  
[  5]  16.00-17.01  sec   321 KBytes  2.61 Mbits/sec                  
[  5]  17.01-18.00  sec  1.04 MBytes  8.80 Mbits/sec                  
[  5]  18.00-19.01  sec   637 KBytes  5.18 Mbits/sec                  
[  5]  19.01-20.01  sec   888 KBytes  7.31 Mbits/sec                  
[  5]  20.01-21.00  sec  1.03 MBytes  8.65 Mbits/sec                  
[  5]  21.00-22.01  sec  1.15 MBytes  9.62 Mbits/sec                  
[  5]  22.01-23.01  sec   468 KBytes  3.82 Mbits/sec                  
[  5]  23.01-24.02  sec   492 KBytes  4.00 Mbits/sec                  
[  5]  24.02-25.01  sec  72.2 KBytes   596 Kbits/sec                  
[  5]  25.01-26.01  sec   762 KBytes  6.25 Mbits/sec                  
[  5]  26.01-27.00  sec   404 KBytes  3.33 Mbits/sec                  
[  5]  27.00-28.00  sec  72.2 KBytes   593 Kbits/sec                  
[  5]  28.00-29.00  sec  77.4 KBytes   633 Kbits/sec                  
[  5]  29.00-30.01  sec   750 KBytes  6.09 Mbits/sec                  
[  5]  30.01-31.02  sec   578 KBytes  4.68 Mbits/sec                  
[  5]  31.02-32.01  sec   900 KBytes  7.50 Mbits/sec                  
[  5]  32.01-33.00  sec   897 KBytes  7.39 Mbits/sec                  
[  5]  33.00-34.00  sec   742 KBytes  6.06 Mbits/sec                  
[  5]  34.00-35.00  sec   449 KBytes  3.69 Mbits/sec                  
[  5]  35.00-36.00  sec   418 KBytes  3.41 Mbits/sec                  
[  5]  36.00-37.00  sec   393 KBytes  3.23 Mbits/sec                  
[  5]  37.00-38.01  sec   810 KBytes  6.60 Mbits/sec                  
[  5]  38.01-39.00  sec  1.12 MBytes  9.44 Mbits/sec                  
[  5]  39.00-40.00  sec  1.18 MBytes  9.90 Mbits/sec                  
[  5]  40.00-40.26  sec   277 KBytes  8.63 Mbits/sec                  
- - - - - - - - - - - - - - - - - - - - - - - - -
[ ID] Interval           Transfer     Bitrate
[  5]   0.00-40.26  sec  24.3 MBytes  5.07 Mbits/sec                  receiver
-----------------------------------------------------------
Server listening on 5201
-----------------------------------------------------------
```

```bash
5: tap0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc fq_codel state UNKNOWN group default qlen 1000
    inet 10.10.10.2/24 scope global tap0
root@clientvpn:~# iperf3 -c 10.10.10.1 -t 40 -i 5
Connecting to host 10.10.10.1, port 5201
[  5] local 10.10.10.2 port 44680 connected to 10.10.10.1 port 5201
[ ID] Interval           Transfer     Bitrate         Retr  Cwnd
[  5]   0.00-5.01   sec  2.92 MBytes  4.89 Mbits/sec    0    163 KBytes       
[  5]   5.01-10.00  sec  2.96 MBytes  4.97 Mbits/sec    0    417 KBytes       
[  5]  10.00-15.01  sec  4.26 MBytes  7.14 Mbits/sec   35    721 KBytes       
[  5]  15.01-20.00  sec  3.58 MBytes  6.01 Mbits/sec  151    592 KBytes       
[  5]  20.00-25.00  sec  3.58 MBytes  6.00 Mbits/sec   14    522 KBytes       
[  5]  25.00-30.01  sec  2.47 MBytes  4.14 Mbits/sec  100    343 KBytes       
[  5]  30.01-35.01  sec  3.58 MBytes  6.01 Mbits/sec    0    413 KBytes       
[  5]  35.01-40.02  sec  3.58 MBytes  5.99 Mbits/sec    0    458 KBytes       
- - - - - - - - - - - - - - - - - - - - - - - - -
[ ID] Interval           Transfer     Bitrate         Retr
[  5]   0.00-40.02  sec  26.9 MBytes  5.65 Mbits/sec  300             sender
[  5]   0.00-40.26  sec  24.3 MBytes  5.07 Mbits/sec                  receiver

iperf Done.
root@clientvpn:~# 
```

Сменим режим работы на `tun` и снова измерим скорость:

```bash
root@servervpn:~# ip a |grep tun
6: tun0: <POINTOPOINT,MULTICAST,NOARP,UP,LOWER_UP> mtu 1500 qdisc fq_codel state UNKNOWN group default qlen 500
    inet 10.10.10.1/24 scope global tun0
root@servervpn:~# iperf3 -s &
[1] 3300
root@servervpn:~# -----------------------------------------------------------
Server listening on 5201
-----------------------------------------------------------
Accepted connection from 10.10.10.2, port 57664
[  5] local 10.10.10.1 port 5201 connected to 10.10.10.2 port 57674
[ ID] Interval           Transfer     Bitrate
[  5]   0.00-1.00   sec   579 KBytes  4.73 Mbits/sec                  
[  5]   1.00-2.00   sec   601 KBytes  4.93 Mbits/sec                  
[  5]   2.00-3.00   sec   492 KBytes  4.03 Mbits/sec                  
[  5]   3.00-4.00   sec   567 KBytes  4.63 Mbits/sec                  
[  5]   4.00-5.00   sec   596 KBytes  4.89 Mbits/sec                  
[  5]   5.00-6.00   sec   583 KBytes  4.78 Mbits/sec                  
[  5]   6.00-7.00   sec   729 KBytes  5.98 Mbits/sec                  
[  5]   7.00-8.00   sec   752 KBytes  6.15 Mbits/sec                  
[  5]   8.00-9.00   sec   548 KBytes  4.50 Mbits/sec                  
[  5]   9.00-10.00  sec   548 KBytes  4.47 Mbits/sec                  
[  5]  10.00-11.00  sec   581 KBytes  4.78 Mbits/sec                  
[  5]  11.00-12.00  sec   655 KBytes  5.37 Mbits/sec                  
[  5]  12.00-13.00  sec   588 KBytes  4.81 Mbits/sec                  
[  5]  13.00-14.00  sec   669 KBytes  5.48 Mbits/sec                  
[  5]  14.00-15.00  sec   687 KBytes  5.63 Mbits/sec                  
[  5]  15.00-16.00  sec   647 KBytes  5.30 Mbits/sec                  
[  5]  16.00-17.00  sec   645 KBytes  5.28 Mbits/sec                  
[  5]  17.00-18.00  sec   696 KBytes  5.70 Mbits/sec                  
[  5]  18.00-19.01  sec   682 KBytes  5.56 Mbits/sec                  
[  5]  19.01-20.00  sec   762 KBytes  6.27 Mbits/sec                  
[  5]  20.00-21.00  sec   507 KBytes  4.15 Mbits/sec                  
[  5]  21.00-22.00  sec  30.4 KBytes   249 Kbits/sec                  
[  5]  22.00-23.00  sec  1.09 MBytes  9.15 Mbits/sec                  
[  5]  23.00-24.02  sec   503 KBytes  4.05 Mbits/sec                  
[  5]  24.02-25.00  sec   817 KBytes  6.81 Mbits/sec                  
[  5]  25.00-26.01  sec   721 KBytes  5.86 Mbits/sec                  
[  5]  26.01-27.00  sec   455 KBytes  3.75 Mbits/sec                  
[  5]  27.00-28.00  sec   518 KBytes  4.24 Mbits/sec                  
[  5]  28.00-29.00  sec   473 KBytes  3.88 Mbits/sec                  
[  5]  29.00-30.00  sec   692 KBytes  5.68 Mbits/sec                  
[  5]  30.00-31.00  sec   595 KBytes  4.86 Mbits/sec                  
[  5]  31.00-32.01  sec   416 KBytes  3.40 Mbits/sec                  
[  5]  32.01-33.00  sec   342 KBytes  2.81 Mbits/sec                  
[  5]  33.00-34.00  sec   420 KBytes  3.45 Mbits/sec                  
[  5]  34.00-35.00  sec   938 KBytes  7.69 Mbits/sec                  
[  5]  35.00-36.01  sec   824 KBytes  6.69 Mbits/sec                  
[  5]  36.01-37.00  sec   690 KBytes  5.69 Mbits/sec                  
[  5]  37.00-38.00  sec  1.03 MBytes  8.67 Mbits/sec                  
[  5]  38.00-39.00  sec   821 KBytes  6.71 Mbits/sec                  
[  5]  39.00-40.01  sec   980 KBytes  8.00 Mbits/sec                  
[  5]  40.01-40.13  sec  44.9 KBytes  3.10 Mbits/sec                  
- - - - - - - - - - - - - - - - - - - - - - - - -
[ ID] Interval           Transfer     Bitrate
[  5]   0.00-40.13  sec  25.0 MBytes  5.22 Mbits/sec                  receiver
-----------------------------------------------------------
Server listening on 5201
-----------------------------------------------------------
```

```bash
root@clientvpn:~# ip a |grep tun
6: tun0: <POINTOPOINT,MULTICAST,NOARP,UP,LOWER_UP> mtu 1500 qdisc fq_codel state UNKNOWN group default qlen 500
    inet 10.10.10.2/24 scope global tun0
root@clientvpn:~# iperf3 -c 10.10.10.1 -t 40 -i 5
Connecting to host 10.10.10.1, port 5201
[  5] local 10.10.10.2 port 57674 connected to 10.10.10.1 port 5201
[ ID] Interval           Transfer     Bitrate         Retr  Cwnd
[  5]   0.00-5.00   sec  3.01 MBytes  5.05 Mbits/sec    0    165 KBytes       
[  5]   5.00-10.01  sec  3.28 MBytes  5.50 Mbits/sec   27    233 KBytes       
[  5]  10.01-15.00  sec  3.10 MBytes  5.20 Mbits/sec    0    254 KBytes       
[  5]  15.00-20.00  sec  3.53 MBytes  5.92 Mbits/sec    0    396 KBytes       
[  5]  20.00-25.01  sec  3.59 MBytes  6.02 Mbits/sec   78    281 KBytes       
[  5]  25.01-30.00  sec  2.85 MBytes  4.79 Mbits/sec   20    214 KBytes       
[  5]  30.00-35.00  sec  2.29 MBytes  3.84 Mbits/sec   90    217 KBytes       
[  5]  35.00-40.00  sec  4.52 MBytes  7.59 Mbits/sec    0    248 KBytes       
- - - - - - - - - - - - - - - - - - - - - - - - -
[ ID] Interval           Transfer     Bitrate         Retr
[  5]   0.00-40.00  sec  26.2 MBytes  5.49 Mbits/sec  215             sender
[  5]   0.00-40.13  sec  25.0 MBytes  5.22 Mbits/sec                  receiver

iperf Done.
root@clientvpn:~# 
```
Измерения показывают практически одинаковую скорость, но чуть более производительным оказался режим `tun`.

Разница между режимами `tap` и `tun` заключается в том, что режим `tap` работает на канальном уровне и оперирует Ethernet кадрами, а режим `tun` работает на сетевом уровне и оперирует IP пакетами. Если необходимо сделать сетевой мост, то используется режим `tap`, а если нужна IP маршрутизация, то режим `tun`.


## Поднимаем RAS на базе OpenVPN с клиентскими сертификатами и подключаемся с локальной машины к VM.

Стенд находится в папке RAS.

Для демострации разворачиваем стенд командой `vagrant up`.

При этом ключ и сертификаты копируются с OpenVPN сервера на хост в каталог /tmp.

Туда же необходимо скопировать файл конфигурации клиента `client.conf`.

### Проверяем результат.

Выполняем подключение:

```bash
vadim@vadim-VirtualBox:/tmp$ sudo openvpn --config client.conf
[sudo] password for vadim: 
2024-10-14 22:45:13 WARNING: Compression for receiving enabled. Compression has been used in the past to break encryption. Sent packets are not compressed unless "allow-compression yes" is also set.
2024-10-14 22:45:13 --cipher is not set. Previous OpenVPN version defaulted to BF-CBC as fallback when cipher negotiation failed in this case. If you need this fallback please add '--data-ciphers-fallback BF-CBC' to your configuration and/or add BF-CBC to --data-ciphers.
2024-10-14 22:45:13 WARNING: file './client.key' is group or others accessible
2024-10-14 22:45:13 OpenVPN 2.5.9 x86_64-pc-linux-gnu [SSL (OpenSSL)] [LZO] [LZ4] [EPOLL] [PKCS11] [MH/PKTINFO] [AEAD] built on Jun 27 2024
2024-10-14 22:45:13 library versions: OpenSSL 3.0.2 15 Mar 2022, LZO 2.10
2024-10-14 22:45:13 TCP/UDP: Preserving recently used remote address: [AF_INET]192.168.60.10:1207
2024-10-14 22:45:13 Socket Buffers: R=[212992->212992] S=[212992->212992]
2024-10-14 22:45:13 UDP link local (bound): [AF_INET][undef]:1194
2024-10-14 22:45:13 UDP link remote: [AF_INET]192.168.60.10:1207
2024-10-14 22:45:13 TLS: Initial packet from [AF_INET]192.168.60.10:1207, sid=d2339e0d cf1a1746
2024-10-14 22:45:13 VERIFY OK: depth=1, CN=rasvpn
2024-10-14 22:45:13 VERIFY KU OK
2024-10-14 22:45:13 Validating certificate extended key usage
2024-10-14 22:45:13 ++ Certificate has EKU (str) TLS Web Server Authentication, expects TLS Web Server Authentication
2024-10-14 22:45:13 VERIFY EKU OK
2024-10-14 22:45:13 VERIFY OK: depth=0, CN=rasvpn
2024-10-14 22:45:13 Control Channel: TLSv1.3, cipher TLSv1.3 TLS_AES_256_GCM_SHA384, peer certificate: 2048 bit RSA, signature: RSA-SHA256
2024-10-14 22:45:13 [rasvpn] Peer Connection Initiated with [AF_INET]192.168.60.10:1207
2024-10-14 22:45:13 PUSH: Received control message: 'PUSH_REPLY,topology net30,ping 10,ping-restart 120,ifconfig 10.10.10.6 10.10.10.5,peer-id 0,cipher AES-256-GCM'
2024-10-14 22:45:13 OPTIONS IMPORT: timers and/or timeouts modified
2024-10-14 22:45:13 OPTIONS IMPORT: --ifconfig/up options modified
2024-10-14 22:45:13 OPTIONS IMPORT: peer-id set
2024-10-14 22:45:13 OPTIONS IMPORT: adjusting link_mtu to 1625
2024-10-14 22:45:13 OPTIONS IMPORT: data channel crypto options modified
2024-10-14 22:45:13 Data Channel: using negotiated cipher 'AES-256-GCM'
2024-10-14 22:45:13 Outgoing Data Channel: Cipher 'AES-256-GCM' initialized with 256 bit key
2024-10-14 22:45:13 Incoming Data Channel: Cipher 'AES-256-GCM' initialized with 256 bit key
2024-10-14 22:45:13 net_route_v4_best_gw query: dst 0.0.0.0
2024-10-14 22:45:13 net_route_v4_best_gw result: via 10.0.2.2 dev enp0s3
2024-10-14 22:45:13 ROUTE_GATEWAY 10.0.2.2/255.255.255.0 IFACE=enp0s3 HWADDR=08:00:27:60:48:33
2024-10-14 22:45:13 TUN/TAP device tun0 opened
2024-10-14 22:45:13 net_iface_mtu_set: mtu 1500 for tun0
2024-10-14 22:45:13 net_iface_up: set tun0 up
2024-10-14 22:45:13 net_addr_ptp_v4_add: 10.10.10.6 peer 10.10.10.5 dev tun0
2024-10-14 22:45:13 net_route_v4_add: 192.168.60.0/24 via 10.10.10.5 dev [NULL] table 0 metric -1
2024-10-14 22:45:13 Initialization Sequence Completed
```

И проверяем доступность:

```bash
vadim@vadim-VirtualBox:/tmp$ ping -c 4 10.10.10.1
PING 10.10.10.1 (10.10.10.1) 56(84) bytes of data.

--- 10.10.10.1 ping statistics ---
4 packets transmitted, 0 received, 100% packet loss, time 3060ms

vadim@vadim-VirtualBox:/tmp$ ip a |grep -A 3 tun
7: tun0: <POINTOPOINT,MULTICAST,NOARP,UP,LOWER_UP> mtu 1500 qdisc fq_codel state UNKNOWN group default qlen 500
    link/none 
    inet 10.10.10.6 peer 10.10.10.5/32 scope global tun0
       valid_lft forever preferred_lft forever
    inet6 fe80::2c91:1963:e658:e8e2/64 scope link stable-privacy 
       valid_lft forever preferred_lft forever
vadim@vadim-VirtualBox:/tmp$ ip r
default via 10.0.2.2 dev enp0s3 proto dhcp metric 100 
10.0.2.0/24 dev enp0s3 proto kernel scope link src 10.0.2.15 metric 100 
10.10.10.5 dev tun0 proto kernel scope link src 10.10.10.6 
169.254.0.0/16 dev enp0s3 scope link metric 1000 
172.17.0.0/16 dev docker0 proto kernel scope link src 172.17.0.1 linkdown 
192.168.60.0/24 via 10.10.10.5 dev tun0 
vadim@vadim-VirtualBox:/tmp$ sudo ip r add 10.10.10.0/24 via 192.168.60.1
vadim@vadim-VirtualBox:/tmp$ ip r
default via 10.0.2.2 dev enp0s3 proto dhcp metric 100 
10.0.2.0/24 dev enp0s3 proto kernel scope link src 10.0.2.15 metric 100 
10.10.10.0/24 via 192.168.60.1 dev vboxnet2 
10.10.10.5 dev tun0 proto kernel scope link src 10.10.10.6 
169.254.0.0/16 dev enp0s3 scope link metric 1000 
172.17.0.0/16 dev docker0 proto kernel scope link src 172.17.0.1 linkdown 
192.168.60.0/24 via 10.10.10.5 dev tun0 
vadim@vadim-VirtualBox:/tmp$ ping -c 4 10.10.10.1
PING 10.10.10.1 (10.10.10.1) 56(84) bytes of data.
64 bytes from 10.10.10.1: icmp_seq=1 ttl=64 time=3.75 ms
64 bytes from 10.10.10.1: icmp_seq=2 ttl=64 time=0.533 ms
64 bytes from 10.10.10.1: icmp_seq=3 ttl=64 time=0.876 ms
64 bytes from 10.10.10.1: icmp_seq=4 ttl=64 time=0.894 ms

--- 10.10.10.1 ping statistics ---
4 packets transmitted, 4 received, 0% packet loss, time 3059ms
rtt min/avg/max/mdev = 0.533/1.514/3.753/1.300 ms
vadim@vadim-VirtualBox:/tmp$
```

Потребовалось дополнительно прописать маршрут `10.10.10.0/24 via 192.168.60.1 dev vboxnet2`.