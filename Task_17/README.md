# Задание 17 (Настраиваем центральный сервер для сбора логов)

1. В Vagrant разворачиваем 2 виртуальные машины web и log
2. На web настраиваем nginx
3. На log настраиваем центральный лог сервер при помощи rsyslog
4. Настраиваем аудит, следящий за изменением конфигов nginx

Командой `vagrant up` разворачиваем виртуальные машины `web` с nginx и `log` с уже необходимыми для логирования настройками.

```bash
root@web:~# ss -tln |grep 80
LISTEN 0      511          0.0.0.0:80        0.0.0.0:*          
LISTEN 0      511             [::]:80           [::]:*          
root@web:~# 
root@web:~# curl 192.168.56.10
<!DOCTYPE html>
<html>
<head>
<title>Welcome to nginx!</title>
<style>
    body {
        width: 35em;
        margin: 0 auto;
        font-family: Tahoma, Verdana, Arial, sans-serif;
    }
</style>
</head>
<body>
<h1>Welcome to nginx!</h1>
<p>If you see this page, the nginx web server is successfully installed and
working. Further configuration is required.</p>

<p>For online documentation and support please refer to
<a href="http://nginx.org/">nginx.org</a>.<br/>
Commercial support is available at
<a href="http://nginx.com/">nginx.com</a>.</p>

<p><em>Thank you for using nginx.</em></p>
</body>
</html>
root@web:~# 
```

```bash
root@log:~# ss -tuln |grep 514
udp   UNCONN 0      0               0.0.0.0:514       0.0.0.0:*          
udp   UNCONN 0      0                  [::]:514          [::]:*          
tcp   LISTEN 0      25              0.0.0.0:514       0.0.0.0:*          
tcp   LISTEN 0      25                 [::]:514          [::]:*          
root@log:~# 
```

Попробуем несколько раз зайти по адресу http://192.168.56.10 и проверям наличие записи в логах:

```bash
root@log:~# cat /var/log/rsyslog/web/nginx_access.log
Aug 28 18:46:01 web nginx_access: 192.168.56.10 - - [28/Aug/2024:18:46:01 +0000] "GET / HTTP/1.1" 200 612 "-" "curl/7.81.0"
Aug 28 18:47:30 web nginx_access: 192.168.56.1 - - [28/Aug/2024:18:47:30 +0000] "GET / HTTP/1.1" 200 396 "-" "Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:129.0) Gecko/20100101 Firefox/129.0"
Aug 28 18:49:17 web nginx_access: 192.168.56.1 - - [28/Aug/2024:18:49:17 +0000] "GET / HTTP/1.1" 200 396 "-" "Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:129.0) Gecko/20100101 Firefox/129.0"
Aug 28 18:49:17 web nginx_access: 192.168.56.1 - - [28/Aug/2024:18:49:17 +0000] "GET /favicon.ico HTTP/1.1" 404 134 "http://192.168.56.10/" "Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:129.0) Gecko/20100101 Firefox/129.0"
Aug 28 18:49:19 web nginx_access: 192.168.56.1 - - [28/Aug/2024:18:49:19 +0000] "GET / HTTP/1.1" 304 0 "-" "Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:129.0) Gecko/20100101 Firefox/129.0"
Aug 28 18:49:20 web nginx_access: 192.168.56.1 - - [28/Aug/2024:18:49:20 +0000] "GET / HTTP/1.1" 304 0 "-" "Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:129.0) Gecko/20100101 Firefox/129.0"
Aug 28 18:49:21 web nginx_access: 192.168.56.1 - - [28/Aug/2024:18:49:21 +0000] "GET / HTTP/1.1" 304 0 "-" "Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:129.0) Gecko/20100101 Firefox/129.0"
root@log:~# 
```

Поскольку наше приложение работает без ошибок, файл nginx_error.log не будет создан. Чтобы сгенерировать ошибку, можно переместить файл веб-страницы, который открывает nginx - `mv /var/www/html/index.nginx-debian.html /var/www/`

После этого мы получим 403 ошибку.

Видим, что логи отправляются корректно:

```bash
root@log:~# cat /var/log/rsyslog/web/nginx_error.log
Aug 28 18:52:08 web nginx_error: 2024/08/28 18:52:08 [error] 3317#3317: *4 directory index of "/var/www/html/" is forbidden, client: 192.168.56.1, server: _, request: "GET / HTTP/1.1", host: "192.168.56.10"
root@log:~# 
```

Поменяем атрибут у файла /etc/nginx/nginx.conf и проверим на log-сервере, что пришла информация об изменении атрибута:

```bash
root@web:~# chmod g+w /etc/nginx/nginx.conf
```

```bash
root@log:~# cat /var/log/rsyslog/web/audisp-syslog.log 
Aug 28 19:03:26 web audisp-syslog: type=SYSCALL msg=audit(1724871806.719:135): arch=c000003e syscall=268 success=yes exit=0 a0=ffffff9c a1=55d0d30901b0 a2=1b4 a3=0 items=1 ppid=3881 pid=3958 auid=1000 uid=0 gid=0 euid=0 suid=0 fsuid=0 egid=0 sgid=0 fsgid=0 tty=pts1 ses=5 comm="chmod" exe="/usr/bin/chmod" subj=unconfined key="nginx_conf" ARCH=x86_64 SYSCALL=fchmodat AUID="vagrant" UID="root" GID="root" EUID="root" SUID="root" FSUID="root" EGID="root" SGID="root" FSGID="root"
Aug 28 19:03:26 web audisp-syslog: type=CWD msg=audit(1724871806.719:135): cwd="/etc/rsyslog.d"
Aug 28 19:03:26 web audisp-syslog: type=PATH msg=audit(1724871806.719:135): item=0 name="/etc/nginx/nginx.conf" inode=256054 dev=08:01 mode=0100644 ouid=0 ogid=0 rdev=00:00 nametype=NORMAL cap_fp=0 cap_fi=0 cap_fe=0 cap_fver=0 cap_frootid=0 OUID="root" OGID="root"
Aug 28 19:03:26 web audisp-syslog: type=PROCTITLE msg=audit(1724871806.719:135): proctitle=63686D6F6400672B77002F6574632F6E67696E782F6E67696E782E636F6E66
Aug 28 19:03:26 web audisp-syslog: type=EOE msg=audit(1724871806.719:135):
root@log:~# 
```