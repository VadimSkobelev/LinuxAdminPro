# Задание 13 (Практика с SELinux)

### 1. Необходимо запустить nginx на нестандартном порту 3-мя разными способами:

- используя переключатели setsebool
- через добавление нестандартного порта в имеющийся тип
- через формирование и установку модуля SELinux

Все вышеописанные действия автоматизированы.

Лог выполнения выводиться в консоль при разворачивании виртуальной машины из Vagrantfile командой:

```bash
$ vagrant up
```

### 2. Обеспечить работоспособность приложения при включенном SELinux.

#### SELinux: проблема с удаленным обновлением зоны DNS

Инженер настроил следующую схему:

- ns01 - DNS-сервер (192.168.50.10);
- client - клиентская рабочая станция (192.168.50.15).

При попытке удаленно (с рабочей станции) внести изменения в зону ddns.lab происходит следующее:
```bash
[vagrant@client ~]$ nsupdate -k /etc/named.zonetransfer.key
> server 192.168.50.10
> zone ddns.lab
> update add www.ddns.lab. 60 A 192.168.50.15
> send
update failed: SERVFAIL
>
```
Инженер перепроверил содержимое конфигурационных файлов и, убедившись, что с ними всё в порядке, предположил, что данная ошибка связана с SELinux.

Необходимо выяснить причину неработоспособности механизма обновления зоны.

#### Решение

На клиенской машине проверяем лог файл (audit.log) на наличие ошибок. Ошибки отсутствуют:
```bash
[root@client ~]# cat /var/log/audit/audit.log | audit2why
[root@client ~]# 
```
Подключаемся к серверу и аналогично проверяем наличие ошибок:
```bash
[root@ns01 ~]# cat /var/log/audit/audit.log | audit2why
type=AVC msg=audit(1722584843.338:2058): avc:  denied  { create } for  pid=5438 comm="isc-worker0000" name="named.ddns.lab.view1.jnl" scontext=system_u:system_r:named_t:s0 tcontext=system_u:object_r:etc_t:s0 tclass=file permissive=0

	Was caused by:
		Missing type enforcement (TE) allow rule.

		You can use audit2allow to generate a loadable module to allow this access.

[root@ns01 ~]# 
```

Результат вывода говорит нам об отсутствии доступа для создания файла `named.ddns.lab.view1.jnl`, т.к. контекст безопасности неправильный.

Контекст SELinux процесса, который попытался выполнить отклоненное действие `named_t`.

Контекст SELinux объекта (цели), к которому процесс пытался получить доступ `etc_t`.

Тип `etc_t` недоступен для процессов, работающих в домене `named_t`.

```bash
[root@ns01 ~]# ls -lZ /etc/named
drw-rwx---. root named unconfined_u:object_r:etc_t:s0   dynamic
-rw-rw----. root named system_u:object_r:etc_t:s0       named.50.168.192.rev
-rw-rw----. root named system_u:object_r:etc_t:s0       named.dns.lab
-rw-rw----. root named system_u:object_r:etc_t:s0       named.dns.lab.view1
-rw-rw----. root named system_u:object_r:etc_t:s0       named.newdns.lab
[root@ns01 ~]# 
```
Чтобы понять, в каком каталоге должны лежать конфигурационные файлы воспользуемся командой:

```bash
[root@ns01 ~]# semanage fcontext -l | grep named
/etc/rndc.*                                        regular file       system_u:object_r:named_conf_t:s0 
/var/named(/.*)?                                   all files          system_u:object_r:named_zone_t:s0 
/etc/unbound(/.*)?                                 all files          system_u:object_r:named_conf_t:s0 
/var/run/bind(/.*)?                                all files          system_u:object_r:named_var_run_t:s0 
/var/log/named.*                                   regular file       system_u:object_r:named_log_t:s0 
/var/run/named(/.*)?                               all files          system_u:object_r:named_var_run_t:s0 
/var/named/data(/.*)?                              all files          system_u:object_r:named_cache_t:s0 
/dev/xen/tapctrl.*                                 named pipe         system_u:object_r:xenctl_t:s0 
/var/run/unbound(/.*)?                             all files          system_u:object_r:named_var_run_t:s0 
/var/lib/softhsm(/.*)?                             all files          system_u:object_r:named_cache_t:s0 
/var/lib/unbound(/.*)?                             all files          system_u:object_r:named_cache_t:s0 
/var/named/slaves(/.*)?                            all files          system_u:object_r:named_cache_t:s0 
/var/named/chroot(/.*)?                            all files          system_u:object_r:named_conf_t:s0 
...
```

Изменим тип контекста безопасности для каталога /etc/named:

```bash
[root@ns01 ~]# chcon -R -t named_zone_t /etc/named
[root@ns01 ~]# ls -lZ /etc/named
drw-rwx---. root named unconfined_u:object_r:named_zone_t:s0 dynamic
-rw-rw----. root named system_u:object_r:named_zone_t:s0 named.50.168.192.rev
-rw-rw----. root named system_u:object_r:named_zone_t:s0 named.dns.lab
-rw-rw----. root named system_u:object_r:named_zone_t:s0 named.dns.lab.view1
-rw-rw----. root named system_u:object_r:named_zone_t:s0 named.newdns.lab
[root@ns01 ~]# 
```

Попробуем снова внести изменения с клиента:

```bash
[root@client ~]# nsupdate -k /etc/named.zonetransfer.key
> server 192.168.50.10
> zone ddns.lab
> update add www.ddns.lab. 60 A 192.168.50.15
> send
> quit
[root@client ~]# 
[root@client ~]# dig www.ddns.lab

; <<>> DiG 9.11.4-P2-RedHat-9.11.4-26.P2.el7_9.16 <<>> www.ddns.lab
;; global options: +cmd
;; Got answer:
;; ->>HEADER<<- opcode: QUERY, status: NOERROR, id: 52152
;; flags: qr aa rd ra; QUERY: 1, ANSWER: 1, AUTHORITY: 1, ADDITIONAL: 2

;; OPT PSEUDOSECTION:
; EDNS: version: 0, flags:; udp: 4096
;; QUESTION SECTION:
;www.ddns.lab.			IN	A

;; ANSWER SECTION:
www.ddns.lab.		60	IN	A	192.168.50.15

;; AUTHORITY SECTION:
ddns.lab.		3600	IN	NS	ns01.dns.lab.

;; ADDITIONAL SECTION:
ns01.dns.lab.		3600	IN	A	192.168.50.10

;; Query time: 3 msec
;; SERVER: 192.168.50.10#53(192.168.50.10)
;; WHEN: Fri Aug 02 08:51:07 UTC 2024
;; MSG SIZE  rcvd: 96

[root@client ~]# 
```
После перезагрузки работоспособность сохраняется.