# Задание 7 (Vagrant стенд длч NFS)

Vagrantfile последовательно разворачивает две виртуальные машины:
    
- NFS-сервер
- NFS-клиент

На NFS-сервере:
- происходит настройка экспортирования директории /srv/share с созданием поддиректории upload с полными правами доступа;
- в директории upload создаётся тестовый файл check_file, для последующей проверки работоспособности.


На NFS-клиенте:
- настраивается автоматическое монтирование директории /srv/share/ с NFS-сервера в /mnt;
- в примонтированной директории (/mnt/upload) создаётся тестовый файл first_client_file, для последующей проверки работоспособности;
- далее, для проверки работоспособности, на NFS-клиенте запускается скрипт check_nfsc.sh (вывод команды showmount и создание второго тестового файла client_file).


Лог выполнения указанных операций отображается при разворачивании виртуальной машины командой:

```bash
$ vagrant up
```