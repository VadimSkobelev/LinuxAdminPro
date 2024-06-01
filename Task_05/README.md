# Задание 5 (Работа с LVM)

Vagrantfile разворачивает виртуальную машину.

Далее на этой виртуальной машине последовательно происходит:

- уменьшение тома под / до 8G
- выделение тома под /var с зеркалированием
- выделение тома под /home
- генерируются файлы в /home/ в качестве полезной нагрузки
- снимается снэпшот для /home
- затем часть файлов в /home удаляется
- далее происходит восстановление удалённых файлов из снэпшота

Лог выполнения указанных операций отображается при разворачивании виртуальной машины командой:

```bash
$ vagrant up
```

Первоначальное состояние виртуальной машины:

```
NAME                    MAJ:MIN RM  SIZE RO TYPE MOUNTPOINT
sda                       8:0    0   40G  0 disk
├─sda1                    8:1    0    1M  0 part
├─sda2                    8:2    0    1G  0 part /boot
└─sda3                    8:3    0   39G  0 part
  ├─VolGroup00-LogVol00 253:0    0 37.5G  0 lvm  /
  └─VolGroup00-LogVol01 253:1    0  1.5G  0 lvm  [SWAP]
sdb                       8:16   0   10G  0 disk
sdc                       8:32   0    2G  0 disk
sdd                       8:48   0    1G  0 disk
sde                       8:64   0    1G  0 disk
************************************************************
Filesystem                       Size  Used Avail Use% Mounted on
/dev/mapper/VolGroup00-LogVol00   38G  676M   37G   2% /
devtmpfs                         235M     0  235M   0% /dev
tmpfs                            244M     0  244M   0% /dev/shm
tmpfs                            244M  4.5M  240M   2% /run
tmpfs                            244M     0  244M   0% /sys/fs/cgroup
/dev/sda2                       1014M   63M  952M   7% /boot
tmpfs                             49M     0   49M   0% /run/user/1000
```

Ожидаемый результат:

```
NAME                       MAJ:MIN RM  SIZE RO TYPE MOUNTPOINT
sda                          8:0    0   40G  0 disk
├─sda1                       8:1    0    1M  0 part
├─sda2                       8:2    0    1G  0 part /boot
└─sda3                       8:3    0   39G  0 part
  ├─VolGroup00-LogVol00    253:0    0    8G  0 lvm  /
  ├─VolGroup00-LogVol01    253:1    0  1.5G  0 lvm  [SWAP]
  └─VolGroup00-LogVol_Home 253:7    0    2G  0 lvm  /home
sdb                          8:16   0   10G  0 disk
sdc                          8:32   0    2G  0 disk
├─vg_var-lv_var_rmeta_0    253:2    0    4M  0 lvm
│ └─vg_var-lv_var          253:6    0  952M  0 lvm  /var
└─vg_var-lv_var_rimage_0   253:3    0  952M  0 lvm
  └─vg_var-lv_var          253:6    0  952M  0 lvm  /var
sdd                          8:48   0    1G  0 disk
├─vg_var-lv_var_rmeta_1    253:4    0    4M  0 lvm
│ └─vg_var-lv_var          253:6    0  952M  0 lvm  /var
└─vg_var-lv_var_rimage_1   253:5    0  952M  0 lvm
  └─vg_var-lv_var          253:6    0  952M  0 lvm  /var
sde                          8:64   0    1G  0 disk
************************************************************
Filesystem                          Size  Used Avail Use% Mounted on
/dev/mapper/VolGroup00-LogVol00     8.0G  897M  7.2G  11% /
devtmpfs                            236M     0  236M   0% /dev
tmpfs                               244M     0  244M   0% /dev/shm
tmpfs                               244M  4.6M  240M   2% /run
tmpfs                               244M     0  244M   0% /sys/fs/cgroup
/dev/mapper/vg_var-lv_var           922M  272M  586M  32% /var
/dev/sda2                          1014M   61M  954M   6% /boot
tmpfs                                49M     0   49M   0% /run/user/1000
/dev/mapper/VolGroup00-LogVol_Home  2.0G   33M  2.0G   2% /home
************************************************************
  --- Logical volume ---
  LV Path                /dev/vg_var/lv_var
  LV Name                lv_var
  VG Name                vg_var
  LV UUID                WibwDl-osUz-Qjx9-fEog-VBMR-kbwI-ME1Nbt
  LV Write Access        read/write
  LV Creation host, time lvm, 2024-06-01 15:46:12 +0000
  LV Status              available
  # open                 1
  LV Size                952.00 MiB
  Current LE             238
  Mirrored volumes       2
  Segments               1
  Allocation             inherit
  Read ahead sectors     auto
  - currently set to     8192
  Block device           253:6
```