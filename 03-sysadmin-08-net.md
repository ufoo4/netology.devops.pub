# Домашнее задание к занятию "3.8. Компьютерные сети, лекция 3"

1. Подключитесь к публичному маршрутизатору в интернет. Найдите маршрут к вашему публичному IP
```
telnet route-views.routeviews.org
Username: rviews
show ip route x.x.x.x/32
show bgp x.x.x.x/32
```
Ответ:  
```bash
route-views>sh ip route 193.150.xxx.xx
Routing entry for 193.150.xxx.0/24
  Known via "bgp 6447", distance 20, metric 0
  Tag 3356, type external
  Last update from 4.68.4.46 1w5d ago
  Routing Descriptor Blocks:
  * 4.68.4.46, from 4.68.4.46, 1w5d ago
      Route metric is 0, traffic share count is 1
      AS Hops 4
      Route tag 3356
      MPLS label: none
      
route-views>sh ip route 193.150.xxx.xx | in 193.*
Routing entry for 193.150.xxx.0/24

route-views>sh bgp 193.150.xxx.xx | in 193.*
BGP routing table entry for 193.150.xxx.0/24, version 1382938903
    193.0.0.56 from 193.0.0.56 (193.0.0.56)

route-views>sh bgp 193.150.xxx.xx
BGP routing table entry for 193.150.101.0/24, version 1382938903
Paths: (23 available, best #11, table default)
  Not advertised to any peer
  Refresh Epoch 3
  3303 20485 34241 57418
    217.192.89.50 from 217.192.89.50 (138.187.128.158)
      Origin IGP, localpref 100, valid, external
      Community: 3303:1004 3303:1006 3303:1030 3303:3056 20485:10074
      path 7FE130653E70 RPKI State not found
      rx pathid: 0, tx pathid: 0
  Refresh Epoch 1
  4901 6079 3356 20485 34241 57418
    162.250.137.254 from 162.250.137.254 (162.250.137.254)
      Origin IGP, localpref 100, valid, external
      Community: 65000:10100 65000:10300 65000:10400
      path 7FE0C03FCE28 RPKI State not found
      rx pathid: 0, tx pathid: 0
  Refresh Epoch 1
  7660 2516 6762 20485 34241 57418
    203.181.248.168 from 203.181.248.168 (203.181.248.168)
      Origin IGP, localpref 100, valid, external
      Community: 2516:1030 7660:9003
      path 7FE120DC50E8 RPKI State not found
      rx pathid: 0, tx pathid: 0
  Refresh Epoch 1
  3267 20485 34241 57418
    194.85.40.15 from 194.85.40.15 (185.141.126.1)
      Origin IGP, metric 0, localpref 100, valid, external
      path 7FE09D574D98 RPKI State not found
      rx pathid: 0, tx pathid: 0
  Refresh Epoch 1
  57866 6453 20485 34241 57418
    37.139.139.17 from 37.139.139.17 (37.139.139.17)
      Origin IGP, metric 0, localpref 100, valid, external
      Community: 6453:50 6453:2000 6453:2300 6453:2305
      path 7FE0EF246368 RPKI State not found
      rx pathid: 0, tx pathid: 0
  Refresh Epoch 1
  7018 1299 20485 34241 57418
    12.0.1.63 from 12.0.1.63 (12.0.1.63)
      Origin IGP, localpref 100, valid, external
      Community: 7018:5000 7018:37232
      path 7FE13B018BF0 RPKI State not found
      rx pathid: 0, tx pathid: 0
  Refresh Epoch 1
  3333 1103 20485 34241 57418
    193.0.0.56 from 193.0.0.56 (193.0.0.56)
      Origin IGP, localpref 100, valid, external
      Community: 0:3216 0:6697 0:8359 0:8492 0:8641 0:8732 0:8744 0:8764 0:9002 0:9031 0:12389 0:12695 0:12714 0:13002 0:13238 0:15169 0:15412 0:16265 0:20764 0:20940 0:25308 0:28917 0:29049 0:29076 0:29226 0:31133 0:31500 0:34123 0:34456 0:35320 0:35374 0:35805 0:39792 0:41733 0:42861 0:43268 0:43727 0:47541 0:47764 0:48166 0:49342 0:50384 0:58002 8714:8714 8714:65010 8714:65011 8714:65023 20485:10074
      unknown transitive attribute: flag 0xE0 type 0x20 length 0x24
        value 0000 220A 0000 03E8 0000 0002 0000 220A
              0000 03E9 0000 0001 0000 220A 0000 03E9
              0000 0002
      path 7FE0FAF86AF8 RPKI State not found
      rx pathid: 0, tx pathid: 0
  Refresh Epoch 1
  49788 12552 20485 34241 57418
    91.218.184.60 from 91.218.184.60 (91.218.184.60)
      Origin IGP, localpref 100, valid, external
      Community: 12552:12000 12552:12600 12552:12601 12552:22000
      Extended Community: 0x43:100:1
      path 7FE17AA28D20 RPKI State not found
      rx pathid: 0, tx pathid: 0
  Refresh Epoch 1
  20912 3257 3356 20485 34241 57418
    212.66.96.126 from 212.66.96.126 (212.66.96.126)
      Origin IGP, localpref 100, valid, external
      Community: 3257:8070 3257:30515 3257:50001 3257:53900 3257:53902 20912:65004
      path 7FE0D80EE6E8 RPKI State not found
      rx pathid: 0, tx pathid: 0
  Refresh Epoch 1
  8283 1299 20485 34241 57418
    94.142.247.3 from 94.142.247.3 (94.142.247.3)
      Origin IGP, metric 0, localpref 100, valid, external
      Community: 1299:30000 8283:1 8283:101
      unknown transitive attribute: flag 0xE0 type 0x20 length 0x18
        value 0000 205B 0000 0000 0000 0001 0000 205B
              0000 0005 0000 0001
      path 7FE043246B98 RPKI State not found
      rx pathid: 0, tx pathid: 0
  Refresh Epoch 1
  3356 20485 34241 57418
    4.68.4.46 from 4.68.4.46 (4.69.184.201)
      Origin IGP, metric 0, localpref 100, valid, external, best
      Community: 3356:2 3356:22 3356:100 3356:123 3356:501 3356:903 3356:2065 20485:10074
      path 7FE15A208818 RPKI State not found
      rx pathid: 0, tx pathid: 0x0
  Refresh Epoch 1
  1221 4637 6762 20485 34241 57418
    203.62.252.83 from 203.62.252.83 (203.62.252.83)
      Origin IGP, localpref 100, valid, external
      path 7FE0B36CA210 RPKI State not found
      rx pathid: 0, tx pathid: 0
  Refresh Epoch 1
  852 3356 20485 34241 57418
    154.11.12.212 from 154.11.12.212 (96.1.209.43)
      Origin IGP, metric 0, localpref 100, valid, external
      path 7FE0957A99B8 RPKI State not found
      rx pathid: 0, tx pathid: 0
  Refresh Epoch 1
  2497 3216 34241 34241 57418
    202.232.0.2 from 202.232.0.2 (58.138.96.254)
      Origin IGP, localpref 100, valid, external
      path 7FE0B6A63370 RPKI State not found
      rx pathid: 0, tx pathid: 0
  Refresh Epoch 1
  20130 6939 20485 34241 57418
    140.192.8.16 from 140.192.8.16 (140.192.8.16)
      Origin IGP, localpref 100, valid, external
      path 7FE151C8F750 RPKI State not found
      rx pathid: 0, tx pathid: 0
  Refresh Epoch 1
  701 5511 3216 34241 34241 57418
    137.39.3.55 from 137.39.3.55 (137.39.3.55)
      Origin IGP, localpref 100, valid, external
      path 7FE0C488BD38 RPKI State not found
      rx pathid: 0, tx pathid: 0
  Refresh Epoch 1
  6939 20485 34241 57418
    64.71.137.241 from 64.71.137.241 (216.218.252.164)
      Origin IGP, localpref 100, valid, external
      path 7FE09CA53940 RPKI State not found
      rx pathid: 0, tx pathid: 0
  Refresh Epoch 1
  3257 1299 20485 34241 57418
    89.149.178.10 from 89.149.178.10 (213.200.83.26)
      Origin IGP, metric 10, localpref 100, valid, external
      Community: 3257:8794 3257:30052 3257:50001 3257:54900 3257:54901
      path 7FE0CA439390 RPKI State not found
      rx pathid: 0, tx pathid: 0
  Refresh Epoch 1
  3549 3356 20485 34241 57418
    208.51.134.254 from 208.51.134.254 (67.16.168.191)
      Origin IGP, metric 0, localpref 100, valid, external
      Community: 3356:2 3356:22 3356:100 3356:123 3356:501 3356:903 3356:2065 3549:2581 3549:30840 20485:10074
      path 7FE10F527930 RPKI State not found
      rx pathid: 0, tx pathid: 0
  Refresh Epoch 1
  53767 174 3216 3216 34241 34241 57418
    162.251.163.2 from 162.251.163.2 (162.251.162.3)
      Origin IGP, localpref 100, valid, external
      Community: 174:21101 174:22010 53767:5000
      path 7FE0F9590858 RPKI State not found
      rx pathid: 0, tx pathid: 0
  Refresh Epoch 1
  1351 6939 20485 34241 57418
    132.198.255.253 from 132.198.255.253 (132.198.255.253)
      Origin IGP, localpref 100, valid, external
      path 7FE0163A1F90 RPKI State not found
      rx pathid: 0, tx pathid: 0
  Refresh Epoch 1
  101 3356 20485 34241 57418
    209.124.176.223 from 209.124.176.223 (209.124.176.223)
      Origin IGP, localpref 100, valid, external
      Community: 101:20100 101:20110 101:22100 3356:2 3356:22 3356:100 3356:123 3356:501 3356:903 3356:2065 20485:10074
      Extended Community: RT:101:22100
      path 7FE15FD53F48 RPKI State not found
      rx pathid: 0, tx pathid: 0
  Refresh Epoch 1
  3561 3910 3356 20485 34241 57418
    206.24.210.80 from 206.24.210.80 (206.24.210.80)
      Origin IGP, localpref 100, valid, external
      path 7FE0EBA927F0 RPKI State not found
      rx pathid: 0, tx pathid: 0
```
2. Создайте dummy0 интерфейс в Ubuntu. Добавьте несколько статических маршрутов. Проверьте таблицу маршрутизации.  
Ответ:  
```bash
root@vagrant:~# ip link add dummy0 type dummy
root@vagrant:~# ip addr add 10.2.2.2/24 dev dummy0
root@vagrant:~# ip link set dummy0 up
root@vagrant:~# ip -c -br a
lo               UNKNOWN        127.0.0.1/8 ::1/128
eth0             UP             10.0.2.15/24 fe80::a00:27ff:fe73:60cf/64
dummy0           UNKNOWN        10.2.2.2/24 fe80::ccf6:d6ff:fe65:b8ee/64
root@vagrant:~# ip -c -br l
lo               UNKNOWN        00:00:00:00:00:00 <LOOPBACK,UP,LOWER_UP>
eth0             UP             08:00:27:73:60:cf <BROADCAST,MULTICAST,UP,LOWER_UP>
dummy0           UNKNOWN        ce:f6:d6:65:b8:ee <BROADCAST,NOARP,UP,LOWER_UP>
root@vagrant:~# ip rou add 8.0.0.0/8 via 10.0.2.2
root@vagrant:~# ip rou add 8.8.0.0/16 via 10.0.2.2
root@vagrant:~# ip rou sh
default via 10.0.2.2 dev eth0 proto dhcp src 10.0.2.15 metric 100
8.0.0.0/8 via 10.0.2.2 dev eth0
8.8.0.0/16 via 10.0.2.2 dev eth0
10.0.2.0/24 dev eth0 proto kernel scope link src 10.0.2.15
10.0.2.0/24 dev dummy0 proto kernel scope link src 10.0.2.50
10.0.2.2 dev eth0 proto dhcp scope link src 10.0.2.15 metric 100
```
3. Проверьте открытые TCP порты в Ubuntu, какие протоколы и приложения используют эти порты? Приведите несколько примеров.  
Ответ:  Вот пример открытых портов: SSH и DNS, 22 и 53 порты.
```bash
itrm@netmon:~$ ss -4tna
State       Recv-Q       Send-Q             Local Address:Port              Peer Address:Port      Process
LISTEN      0            4096               127.0.0.53%lo:53                     0.0.0.0:*
LISTEN      0            128                      0.0.0.0:22                     0.0.0.0:*
LISTEN      0            128                  127.0.0.1:6010                     0.0.0.0:*
LISTEN      0            128                  127.0.0.1:6011                     0.0.0.0:*
ESTAB       0            0                   10.74.11.154:22                 10.74.13.14:9184
ESTAB       0            2400                10.74.11.154:22                 10.74.13.14:9183
ESTAB       0            0                   127.0.0.1:34640                   127.0.0.1:9090
ESTAB       0            48                  10.74.11.154:22                 10.74.13.14:6102
ESTAB       0            0                   10.74.11.154:22                 10.74.13.14:5958
```
4. Проверьте используемые UDP сокеты в Ubuntu, какие протоколы и приложения используют эти порты?  
Ответ:  Пример работы OpenVPN на порту 1194 и bootpc порт 68 (используется для dhcp)
```bash
[root@ovpn ~]# ss -4uan
State         Recv-Q        Send-Q                     Local Address:Port               Peer Address:Port        Process
UNCONN        0             0                              127.0.0.1:323                     0.0.0.0:*
ESTAB         0             0                     192.168.1.12%ens192:68                  192.168.1.1:67
UNCONN        0             0                               0.0.0.0:1194                     0.0.0.0:*
```
5. Используя diagrams.net, создайте L3 диаграмму вашей домашней сети или любой другой сети, с которой вы работали.  
Ответ: Вот пример подключения сетевого оборудования в филиале  
![fil_net](https://github.com/gnoy4eg/netology.devops.pub/blob/main/img/filial_net.png)
