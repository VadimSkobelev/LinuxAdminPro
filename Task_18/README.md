# Задание 18 (Настраиваем бэкапы)

Необходимо настроить стенд Vagrant с двумя виртуальными машинами: backup_server и client.

Настроить удаленный бекап каталога /etc c сервера client при помощи borgbackup.

Резервные копии должны соответствовать следующим критериям:

    - Директория для резервных копий /var/backup. Это должна быть отдельная точка монтирования.
    
    - Репозиторий для резервных копий должен быть зашифрован ключом или паролем. Имя бекапа должно содержать информацию о времени снятия бекапа.
    
    - Глубина бекапа должна быть год, хранить можно по последней копии на конец месяца, кроме последних трех. Последние три месяца должны содержать копии на каждый день.
    
    - Резервная копия снимается каждые 5 минут.
    
    - Написан скрипт для снятия резервных копий. Скрипт запускается из соответствующей Cron джобы, либо systemd timer-а.
    
    - Настроено логирование процесса бекапа.


Командой `vagrant up` разворачиваем две виртуальные машины: `backup-server` и 'client`, и ждём ~ 30 минут.

Дальнейшие проверки корректности работы выполняем на машине `client`.

Проверяем работу таймера:

```bash
root@client:~# systemctl list-timers --all
NEXT                        LEFT          LAST                        PASSED       UNIT                           ACTIVATES                       
Thu 2024-09-05 17:05:22 UTC 2min 53s left Thu 2024-09-05 17:00:22 UTC 2min 6s ago  borg-backup.timer              borg-backup.service
...
```

Логи можем посмотреть в /var/log/syslog

```bash
root@client:~# tail -f /var/log/syslog 
...
Sep  5 17:05:27 client systemd[1]: Starting Borg Backup...
Sep  5 17:05:40 client borgbackup[3629]: ------------------------------------------------------------------------------
Sep  5 17:05:40 client borgbackup[3629]: Repository: ssh://borg@192.168.56.10/var/backup
Sep  5 17:05:40 client borgbackup[3629]: Archive name: etc-2024-09-05_17:05:28
Sep  5 17:05:40 client borgbackup[3629]: Archive fingerprint: 862418e098c738c48206706f252832dbbe4c33b45ba90d5f12010fc5c53681d0
Sep  5 17:05:41 client borgbackup[3629]: Time (start): Thu, 2024-09-05 17:05:39
Sep  5 17:05:41 client borgbackup[3629]: Time (end):   Thu, 2024-09-05 17:05:40
Sep  5 17:05:41 client borgbackup[3629]: Duration: 1.20 seconds
Sep  5 17:05:41 client borgbackup[3629]: Number of files: 696
Sep  5 17:05:41 client borgbackup[3629]: Utilization of max. archive size: 0%
Sep  5 17:05:41 client borgbackup[3629]: ------------------------------------------------------------------------------
Sep  5 17:05:41 client borgbackup[3629]:                        Original size      Compressed size    Deduplicated size
Sep  5 17:05:41 client borgbackup[3629]: This archive:                2.11 MB            939.60 kB                608 B
Sep  5 17:05:41 client borgbackup[3629]: All archives:                6.34 MB              2.82 MB            985.13 kB
Sep  5 17:05:41 client borgbackup[3629]:                        Unique chunks         Total chunks
Sep  5 17:05:41 client borgbackup[3629]: Chunk index:                     667                 2061
Sep  5 17:05:41 client borgbackup[3629]: ------------------------------------------------------------------------------
Sep  5 17:06:00 client systemd[1]: borg-backup.service: Deactivated successfully.
Sep  5 17:06:00 client systemd[1]: Finished Borg Backup.
Sep  5 17:06:00 client systemd[1]: borg-backup.service: Consumed 15.379s CPU time.
```

Демонстрация возможности восстановления из бэкапа:

```bash
root@client:/# pwd
/
root@client:/# ls /etc | wc -l
177
root@client:/# rm -rf /etc/*
root@client:/# ls /etc | wc -l
0
root@client:/# borg list borg@192.168.56.10:/var/backup
Remote: No user exists for uid 0
Connection closed by remote host. Is borg working on the server?
root@client:/# touch /etc/passwd
root@client:/# chmod 644 /etc/passwd 
root@client:/# echo "root:x:0:0:root:/root:/bin/bash" > /etc/passwd 
root@client:/# borg list borg@192.168.56.10:/var/backup
Enter passphrase for key ssh://borg@192.168.56.10/var/backup: 
etc-2024-09-05_15:42:43              Thu, 2024-09-05 15:42:49 [567433f67f2e60d7c1849ebff1af2e2fcc4456b27009870aab07bce9bc01ddbe]
etc-2024-09-05_17:05:28              Thu, 2024-09-05 17:05:39 [862418e098c738c48206706f252832dbbe4c33b45ba90d5f12010fc5c53681d0]
root@client:/# borg extract borg@192.168.56.10:/var/backup/::etc-2024-09-05_17:05:28 etc/
Enter passphrase for key ssh://borg@192.168.56.10/var/backup: 
root@client:/# ls /etc | wc -l
177
root@client:/# 
```