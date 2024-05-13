# Задание 1 (Настройка ПК)

Подготовлена хостовая машина:
```
$ lsb_release -a

No LSB modules are available.
Distributor ID: Ubuntu
Description:    Ubuntu 22.04.4 LTS
Release:        22.04
Codename:       jammy


$ vagrant version

Installed Version: 2.4.1
Latest Version: 2.4.1


$ ansible --version

ansible 2.10.8
  config file = None
  configured module search path = ['/home/vadim/.ansible/plugins/modules', '/usr/share/ansible/plugins/modules']
  ansible python module location = /usr/lib/python3/dist-packages/ansible
  executable location = /usr/bin/ansible
  python version = 3.10.12 (main, Nov 20 2023, 15:14:05) [GCC 11.4.0]



$ virtualbox --help

Oracle VM VirtualBox VM Selector v7.0.18


$ traceroute --version

Modern traceroute for Linux, version 2.1.0
Copyright (c) 2016  Dmitry Butskoy,   License: GPL v2 or any later


$ tcpdump --version

tcpdump version 4.99.1
libpcap version 1.10.1 (with TPACKET_V3)
OpenSSL 3.0.2 15 Mar 2022
```

Образ (box) для виртуальной машины можно скачать по ссылке https://cloud.centos.org/centos/8-stream/x86_64/images/CentOS-Stream-Vagrant-8-20230501.0.x86_64.vagrant-virtualbox.box


Для импорта данного образа необходимо воспользоваться коммандой вида:

```
$ vagrant box add --name 'centos/stream8' /<путь к образу>/CentOS-Stream-Vagrant-8-20230501.0.x86_64.vagrant-virtualbox.box
```

Проверка наличия локального образа:

```
$ vagrant box list
```

В качестве проверки развёрнута виртуальная машина из Vagrantfile:

```
$ vagrant up        - создание виртуальной машины
$ vagrant status    - просмотр статуса виртуальной машины
$ vagrant ssh       - подключение к виртуальной машине
$ vagrant halt      - выключение виртуальной машины
$ vagrant destroy   - полное удаление виртуальной машины

```