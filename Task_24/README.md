# Задание 24 (Настраиваем split-dns)

Первоначальный стенд необходимо взять с https://github.com/erlong15/vagrant-bind
    
Далее необходимо:

    - добавить еще один сервер client2
    
    - завести в зоне dns.lab имена
    
        - web1 - смотрит на клиент1
    
        - web2 смотрит на клиент2
    
    - завести еще одну зону newdns.lab
    
    - завести в ней запись
    
        - www - смотрит на обоих клиентов
    
    - настроить split-dns
    
        - клиент1 - видит обе зоны, но в зоне dns.lab только web1
    
        - клиент2 видит только dns.lab
    
    * настроить все без выключения selinux


Первоначальный стенд отредактирован согласно требованиям выше.

Разворачиваем получившуюся конфигурацию командой `vagrant up`, и проверяем результат:

**client**

```bash
[root@client ~]# ping www.newdns.lab
PING www.newdns.lab (192.168.50.15) 56(84) bytes of data.
64 bytes from client (192.168.50.15): icmp_seq=1 ttl=64 time=0.172 ms
64 bytes from client (192.168.50.15): icmp_seq=2 ttl=64 time=0.088 ms
64 bytes from client (192.168.50.15): icmp_seq=3 ttl=64 time=0.223 ms
^C
--- www.newdns.lab ping statistics ---
3 packets transmitted, 3 received, 0% packet loss, time 2001ms
rtt min/avg/max/mdev = 0.088/0.161/0.223/0.055 ms
[root@client ~]# 
[root@client ~]# ping web1.dns.lab
PING web1.dns.lab (192.168.50.15) 56(84) bytes of data.
64 bytes from client (192.168.50.15): icmp_seq=1 ttl=64 time=0.035 ms
64 bytes from client (192.168.50.15): icmp_seq=2 ttl=64 time=0.738 ms
64 bytes from client (192.168.50.15): icmp_seq=3 ttl=64 time=0.722 ms
^C
--- web1.dns.lab ping statistics ---
3 packets transmitted, 3 received, 0% packet loss, time 2005ms
rtt min/avg/max/mdev = 0.035/0.498/0.738/0.328 ms
[root@client ~]# 
[root@client ~]# ping web2.dns.lab
ping: web2.dns.lab: Name or service not known
[root@client ~]# 
```

Видим, что client видит обе зоны (dns.lab и newdns.lab), однако информацию о хосте
web2.dns.lab он получить не может.

**client2**

```bash
[root@client2 ~]# ping www.newdns.lab
ping: www.newdns.lab: Name or service not known
[root@client2 ~]# 
[root@client2 ~]# ping web1.dns.lab
PING web1.dns.lab (192.168.50.15) 56(84) bytes of data.
64 bytes from 192.168.50.15 (192.168.50.15): icmp_seq=1 ttl=64 time=33.0 ms
64 bytes from 192.168.50.15 (192.168.50.15): icmp_seq=2 ttl=64 time=2.34 ms
64 bytes from 192.168.50.15 (192.168.50.15): icmp_seq=3 ttl=64 time=2.44 ms
^C
--- web1.dns.lab ping statistics ---
3 packets transmitted, 3 received, 0% packet loss, time 2004ms
rtt min/avg/max/mdev = 2.345/12.604/33.022/14.437 ms
[root@client2 ~]# 
[root@client2 ~]# ping web2.dns.lab
PING web2.dns.lab (192.168.50.16) 56(84) bytes of data.
64 bytes from client2 (192.168.50.16): icmp_seq=1 ttl=64 time=0.226 ms
64 bytes from client2 (192.168.50.16): icmp_seq=2 ttl=64 time=0.102 ms
64 bytes from client2 (192.168.50.16): icmp_seq=3 ttl=64 time=0.199 ms
^C
--- web2.dns.lab ping statistics ---
3 packets transmitted, 3 received, 0% packet loss, time 2001ms
rtt min/avg/max/mdev = 0.102/0.175/0.226/0.055 ms
[root@client2 ~]# 
```

client2 видит всю зону dns.lab и не видит зону newdns.lab

Аналогичным образом проверяем работу slave сервера.
Для этого на клиентах удаляем master сервер `nameserver 192.168.50.10` из файла /etc/resolv.conf, и перезапускаем `named`.
При повторении проверок получаем такой же результат.