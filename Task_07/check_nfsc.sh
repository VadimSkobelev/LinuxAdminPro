#!/bin/bash

echo Проверка RPC на NFS-клиенте:
showmount -a 192.168.50.10
echo Создание файла client_file на NFS-клиенте:
ls -l /mnt/upload
touch /mnt/upload/client_file
ls -l /mnt/upload