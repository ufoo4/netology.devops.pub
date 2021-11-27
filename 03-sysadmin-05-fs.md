# Домашнее задание к занятию "3.5. Файловые системы"

1. Узнайте о [sparse](https://ru.wikipedia.org/wiki/%D0%A0%D0%B0%D0%B7%D1%80%D0%B5%D0%B6%D1%91%D0%BD%D0%BD%D1%8B%D0%B9_%D1%84%D0%B0%D0%B9%D0%BB) (разряженных) файлах.  
Ответ: Узнал. Хорошее решение для дисков виртуальных машин.
2. Могут ли файлы, являющиеся жесткой ссылкой на один объект, иметь разные права доступа и владельца? Почему?  
Ответ: Нет! Данные ссылки имеют ту же информацию inode и набор разрешений, владельца что и исходный файл.    
Каждая из таких ссылок - это отдельный файл, подобные ссылки могут работать только в пределах одной файловой системы.   
Нельзя ссылаться на каталоги, можно перемещать или переименовывать исходный файл и даже удалять без вреда ссылке.
5. Сделайте `vagrant destroy` на имеющийся инстанс Ubuntu. Замените содержимое Vagrantfile следующим:
    ```bash
    Vagrant.configure("2") do |config|
      config.vm.box = "bento/ubuntu-20.04"
      config.vm.provider :virtualbox do |vb|
        lvm_experiments_disk0_path = "/tmp/lvm_experiments_disk0.vmdk"
        lvm_experiments_disk1_path = "/tmp/lvm_experiments_disk1.vmdk"
        vb.customize ['createmedium', '--filename', lvm_experiments_disk0_path, '--size', 2560]
        vb.customize ['createmedium', '--filename', lvm_experiments_disk1_path, '--size', 2560]
        vb.customize ['storageattach', :id, '--storagectl', 'SATA Controller', '--port', 1, '--device', 0, '--type', 'hdd', '--medium', lvm_experiments_disk0_path]
        vb.customize ['storageattach', :id, '--storagectl', 'SATA Controller', '--port', 2, '--device', 0, '--type', 'hdd', '--medium', lvm_experiments_disk1_path]
      end
    end
    ```
Данная конфигурация создаст новую виртуальную машину с двумя дополнительными неразмеченными дисками по 2.5 Гб.  
Ответ:
```bash
vagrant@vagrant:~$ lsblk
NAME                 MAJ:MIN RM  SIZE RO TYPE MOUNTPOINT
sda                    8:0    0   64G  0 disk
├─sda1                 8:1    0  512M  0 part /boot/efi
├─sda2                 8:2    0    1K  0 part
└─sda5                 8:5    0 63.5G  0 part
  ├─vgvagrant-root   253:0    0 62.6G  0 lvm  /
  └─vgvagrant-swap_1 253:1    0  980M  0 lvm  [SWAP]
sdb                    8:16   0  2.5G  0 disk
sdc                    8:32   0  2.5G  0 disk
```
4. Используя `fdisk`, разбейте первый диск на 2 раздела: 2 Гб, оставшееся пространство.  
Ответ:
```bash
vagrant@vagrant:~$ sudo su
root@vagrant:/home/vagrant# fdisk /dev/sdb
Command (m for help): p
Disk /dev/sdb: 2.51 GiB, 2684354560 bytes, 5242880 sectors
Disk model: VBOX HARDDISK
Units: sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes
Disklabel type: dos
Disk identifier: 0x5d2e5fb8

Command (m for help): n
Partition type
   p   primary (0 primary, 0 extended, 4 free)
   e   extended (container for logical partitions)
Select (default p): p
Partition number (1-4, default 1):
First sector (2048-5242879, default 2048):
Last sector, +/-sectors or +/-size{K,M,G,T,P} (2048-5242879, default 5242879): +2G
Created a new partition 1 of type 'Linux' and of size 2 GiB.

Command (m for help): n
Partition type
   p   primary (1 primary, 0 extended, 3 free)
   e   extended (container for logical partitions)
Select (default p): p
Partition number (2-4, default 2):
First sector (4196352-5242879, default 4196352):
Last sector, +/-sectors or +/-size{K,M,G,T,P} (4196352-5242879, default 5242879):
Created a new partition 2 of type 'Linux' and of size 511 MiB.

Command (m for help): p
Disk /dev/sdb: 2.51 GiB, 2684354560 bytes, 5242880 sectors
Disk model: VBOX HARDDISK
Units: sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes
Disklabel type: dos
Disk identifier: 0x5d2e5fb8
Device     Boot   Start     End Sectors  Size Id Type
/dev/sdb1          2048 4196351 4194304    2G 83 Linux
/dev/sdb2       4196352 5242879 1046528  511M 83 Linux

Command (m for help): w
The partition table has been altered.
Calling ioctl() to re-read partition table.
Syncing disks.

root@vagrant:/home/vagrant# lsblk
NAME                 MAJ:MIN RM  SIZE RO TYPE MOUNTPOINT
sda                    8:0    0   64G  0 disk
├─sda1                 8:1    0  512M  0 part /boot/efi
├─sda2                 8:2    0    1K  0 part
└─sda5                 8:5    0 63.5G  0 part
  ├─vgvagrant-root   253:0    0 62.6G  0 lvm  /
  └─vgvagrant-swap_1 253:1    0  980M  0 lvm  [SWAP]
sdb                    8:16   0  2.5G  0 disk
├─sdb1                 8:17   0    2G  0 part
└─sdb2                 8:18   0  511M  0 part
sdc                    8:32   0  2.5G  0 disk
```
5. Используя `sfdisk`, перенесите данную таблицу разделов на второй диск.  
Ответ:
```bash
root@vagrant:/home/vagrant# sfdisk -d /dev/sdb | sfdisk /dev/sdc
Checking that no-one is using this disk right now ... OK
Disk /dev/sdc: 2.51 GiB, 2684354560 bytes, 5242880 sectors
Disk model: VBOX HARDDISK
Units: sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes
>>> Script header accepted.
>>> Script header accepted.
>>> Script header accepted.
>>> Script header accepted.
>>> Created a new DOS disklabel with disk identifier 0x5d2e5fb8.
/dev/sdc1: Created a new partition 1 of type 'Linux' and of size 2 GiB.
/dev/sdc2: Created a new partition 2 of type 'Linux' and of size 511 MiB.
/dev/sdc3: Done.
New situation:
Disklabel type: dos
Disk identifier: 0x5d2e5fb8
Device     Boot   Start     End Sectors  Size Id Type
/dev/sdc1          2048 4196351 4194304    2G 83 Linux
/dev/sdc2       4196352 5242879 1046528  511M 83 Linux
The partition table has been altered.
Calling ioctl() to re-read partition table.
Syncing disks.

root@vagrant:/home/vagrant# lsblk
NAME                 MAJ:MIN RM  SIZE RO TYPE MOUNTPOINT
sda                    8:0    0   64G  0 disk
├─sda1                 8:1    0  512M  0 part /boot/efi
├─sda2                 8:2    0    1K  0 part
└─sda5                 8:5    0 63.5G  0 part
  ├─vgvagrant-root   253:0    0 62.6G  0 lvm  /
  └─vgvagrant-swap_1 253:1    0  980M  0 lvm  [SWAP]
sdb                    8:16   0  2.5G  0 disk
├─sdb1                 8:17   0    2G  0 part
└─sdb2                 8:18   0  511M  0 part
sdc                    8:32   0  2.5G  0 disk
├─sdc1                 8:33   0    2G  0 part
└─sdc2                 8:34   0  511M  0 part
```
6. Соберите `mdadm` RAID1 на паре разделов 2 Гб.  
Ответ:
```bash
root@vagrant:/home/vagrant# mdadm --create /dev/md0 --level 1 --raid-devices=2 /dev/sdb1 /dev/sdc1
mdadm: Note: this array has metadata at the start and
    may not be suitable as a boot device.  If you plan to
    store '/boot' on this device please ensure that
    your boot-loader understands md/v1.x metadata, or use
    --metadata=0.90
Continue creating array? (y/n) y
mdadm: Defaulting to version 1.2 metadata
mdadm: array /dev/md0 started.
root@vagrant:/home/vagrant# cat /proc/mdstat
Personalities : [linear] [multipath] [raid0] [raid1] [raid6] [raid5] [raid4] [raid10]
md0 : active raid1 sdc1[1] sdb1[0]
      2094080 blocks super 1.2 [2/2] [UU]
unused devices: <none>
```
7. Соберите `mdadm` RAID0 на второй паре маленьких разделов.  
Ответ:
```bash
root@vagrant:/home/vagrant# mdadm --create /dev/md1 --level 0 --raid-devices=2 /dev/sdb2 /dev/sdc2
mdadm: Defaulting to version 1.2 metadata
mdadm: array /dev/md1 started.
root@vagrant:/home/vagrant# cat /proc/mdstat
Personalities : [linear] [multipath] [raid0] [raid1] [raid6] [raid5] [raid4] [raid10]
md1 : active raid0 sdc2[1] sdb2[0]
      1042432 blocks super 1.2 512k chunks
md0 : active raid1 sdc1[1] sdb1[0]
      2094080 blocks super 1.2 [2/2] [UU]
unused devices: <none>

root@vagrant:/home/vagrant# lsblk
NAME                 MAJ:MIN RM  SIZE RO TYPE  MOUNTPOINT
sda                    8:0    0   64G  0 disk
├─sda1                 8:1    0  512M  0 part  /boot/efi
├─sda2                 8:2    0    1K  0 part
└─sda5                 8:5    0 63.5G  0 part
  ├─vgvagrant-root   253:0    0 62.6G  0 lvm   /
  └─vgvagrant-swap_1 253:1    0  980M  0 lvm   [SWAP]
sdb                    8:16   0  2.5G  0 disk
├─sdb1                 8:17   0    2G  0 part
│ └─md0                9:0    0    2G  0 raid1
└─sdb2                 8:18   0  511M  0 part
  └─md1                9:1    0 1018M  0 raid0
sdc                    8:32   0  2.5G  0 disk
├─sdc1                 8:33   0    2G  0 part
│ └─md0                9:0    0    2G  0 raid1
└─sdc2                 8:34   0  511M  0 part
  └─md1                9:1    0 1018M  0 raid0
```
8. Создайте 2 независимых PV на получившихся md-устройствах.  
Ответ:
```bash
root@vagrant:/home/vagrant# pvcreate /dev/md0
  Physical volume "/dev/md0" successfully created.
root@vagrant:/home/vagrant# pvcreate /dev/md1
  Physical volume "/dev/md1" successfully created.
root@vagrant:/home/vagrant# pvdisplay /dev/md0 /dev/md1
  "/dev/md0" is a new physical volume of "<2.00 GiB"
  --- NEW Physical volume ---
  PV Name               /dev/md0
  VG Name
  PV Size               <2.00 GiB
  Allocatable           NO
  PE Size               0
  Total PE              0
  Free PE               0
  Allocated PE          0
  PV UUID               KJv7uu-c5ms-KjSS-QR2i-eXBS-K1y8-FcdiEi

  "/dev/md1" is a new physical volume of "1018.00 MiB"
  --- NEW Physical volume ---
  PV Name               /dev/md1
  VG Name
  PV Size               1018.00 MiB
  Allocatable           NO
  PE Size               0
  Total PE              0
  Free PE               0
  Allocated PE          0
  PV UUID               boRGuE-FRTM-ns31-W7DD-9IMk-f67J-CsAxgm
```
9. Создайте общую volume-group на этих двух PV.  
Ответ:
```bash
root@vagrant:/home/vagrant# vgcreate vggeneral /dev/md0 /dev/md1
  Volume group "vggeneral" successfully created
root@vagrant:/home/vagrant# vgdisplay vggeneral
  --- Volume group ---
  VG Name               vggeneral
  System ID
  Format                lvm2
  Metadata Areas        2
  Metadata Sequence No  1
  VG Access             read/write
  VG Status             resizable
  MAX LV                0
  Cur LV                0
  Open LV               0
  Max PV                0
  Cur PV                2
  Act PV                2
  VG Size               <2.99 GiB
  PE Size               4.00 MiB
  Total PE              765
  Alloc PE / Size       0 / 0
  Free  PE / Size       765 / <2.99 GiB
  VG UUID               A04t5P-shsG-mj8U-HYzN-xA2y-UBBm-xPVOQY
```
10. Создайте LV размером 100 Мб, указав его расположение на PV с RAID0.  
Ответ:
```bash
root@vagrant:/home/vagrant# lvcreate -L 100m vggeneral /dev/md0
  Logical volume "lvol0" created.
root@vagrant:/home/vagrant# lvdisplay vggeneral
  --- Logical volume ---
  LV Path                /dev/vggeneral/lvol0
  LV Name                lvol0
  VG Name                vggeneral
  LV UUID                HZLHWp-4DYF-Gy90-Ec53-PgSG-8OtY-1yCDuK
  LV Write Access        read/write
  LV Creation host, time vagrant, 2021-11-27 04:49:55 +0000
  LV Status              available
  # open                 0
  LV Size                100.00 MiB
  Current LE             25
  Segments               1
  Allocation             inherit
  Read ahead sectors     auto
  - currently set to     256
  Block device           253:2
```
11. Создайте `mkfs.ext4` ФС на получившемся LV.  
Ответ:
```bash
root@vagrant:/home/vagrant# mkfs.ext4 /dev/vggeneral/lvol0
mke2fs 1.45.5 (07-Jan-2020)
Creating filesystem with 25600 4k blocks and 25600 inodes

Allocating group tables: done
Writing inode tables: done
Creating journal (1024 blocks): done
Writing superblocks and filesystem accounting information: done
```
12. Смонтируйте этот раздел в любую директорию, например, `/tmp/new`.  
Ответ:
```bash
root@vagrant:/home/vagrant# mkdir /tmp/new
root@vagrant:/home/vagrant# mount /dev/vggeneral/lvol0 /tmp/new
```
13. Поместите туда тестовый файл, например `wget https://mirror.yandex.ru/ubuntu/ls-lR.gz -O /tmp/new/test.gz`.  
Ответ:
```bash
root@vagrant:/home/vagrant# wget https://mirror.yandex.ru/ubuntu/ls-lR.gz -O /tmp/new/test.gz
--2021-11-27 08:49:56--  https://mirror.yandex.ru/ubuntu/ls-lR.gz
Resolving mirror.yandex.ru (mirror.yandex.ru)... 213.180.204.183, 2a02:6b8::183
Connecting to mirror.yandex.ru (mirror.yandex.ru)|213.180.204.183|:443... connected.
HTTP request sent, awaiting response... 200 OK
Length: 22616106 (22M) [application/octet-stream]
Saving to: ‘/tmp/new/test.gz’

/tmp/new/test.gz                               100%[====================================================================================================>]  21.57M  7.11MB/s    in 3.0s

2021-11-27 08:49:59 (7.11 MB/s) - ‘/tmp/new/test.gz’ saved [22616106/22616106]
```
14. Прикрепите вывод `lsblk`.  
Ответ:
```bash
root@vagrant:/home/vagrant# lsblk -f
NAME                  FSTYPE            LABEL     UUID                                   FSAVAIL FSUSE% MOUNTPOINT
sda
├─sda1                vfat                        7D3B-6BE4                                 511M     0% /boot/efi
├─sda2
└─sda5                LVM2_member                 Mx3LcA-uMnN-h9yB-gC2w-qm7w-skx0-OsTz9z
  ├─vgvagrant-root    ext4                        b527b79c-7f45-4e2b-a90f-1a4e9cb477c2     56.8G     2% /
  └─vgvagrant-swap_1  swap                        fad91b1f-6eed-4e4b-8dbf-913ba5bcacc7                  [SWAP]
sdb
├─sdb1                linux_raid_member vagrant:0 4aca886c-d46f-e9fd-0c99-72e00ba5a6f1
│ └─md0               LVM2_member                 c5PhrF-e6WX-bPXW-MN7u-PVB4-EJt5-1Y5UK2
│   └─vggeneral-lvol0 ext4                        e4bfabf5-fd44-450b-9820-18a55bbe7f7b     64.2M    23% /tmp/new
└─sdb2                linux_raid_member vagrant:1 5de6c25b-e4dd-8600-6d0a-053721a95148
  └─md1               LVM2_member                 bibN2Y-U9J4-CHB5-IsTn-nHGy-HH4V-s8DX9D
sdc
├─sdc1                linux_raid_member vagrant:0 4aca886c-d46f-e9fd-0c99-72e00ba5a6f1
│ └─md0               LVM2_member                 c5PhrF-e6WX-bPXW-MN7u-PVB4-EJt5-1Y5UK2
│   └─vggeneral-lvol0 ext4                        e4bfabf5-fd44-450b-9820-18a55bbe7f7b     64.2M    23% /tmp/new
└─sdc2                linux_raid_member vagrant:1 5de6c25b-e4dd-8600-6d0a-053721a95148
  └─md1               LVM2_member                 bibN2Y-U9J4-CHB5-IsTn-nHGy-HH4V-s8DX9D
```
15. Протестируйте целостность файла:
     ```bash
     root@vagrant:~# gzip -t /tmp/new/test.gz
     root@vagrant:~# echo $?
     0
     ```
Ответ:
```bash
root@vagrant:/home/vagrant# gzip -t /tmp/new/test.gz
root@vagrant:/home/vagrant# echo $?
0
```
16. Используя pvmove, переместите содержимое PV с RAID0 на RAID1.  
Ответ:
```bash
root@vagrant:/home/vagrant# pvmove /dev/md1
  /dev/md1: Moved: 4.00%
  /dev/md1: Moved: 100.00%
root@vagrant:/home/vagrant# lsblk
NAME                  MAJ:MIN RM  SIZE RO TYPE  MOUNTPOINT
sda                     8:0    0   64G  0 disk
├─sda1                  8:1    0  512M  0 part  /boot/efi
├─sda2                  8:2    0    1K  0 part
└─sda5                  8:5    0 63.5G  0 part
  ├─vgvagrant-root    253:0    0 62.6G  0 lvm   /
  └─vgvagrant-swap_1  253:1    0  980M  0 lvm   [SWAP]
sdb                     8:16   0  2.5G  0 disk
├─sdb1                  8:17   0    2G  0 part
│ └─md0                 9:0    0    2G  0 raid1
│   └─vggeneral-lvol0 253:2    0  100M  0 lvm   /tmp/new
└─sdb2                  8:18   0  511M  0 part
  └─md1                 9:1    0 1018M  0 raid0
sdc                     8:32   0  2.5G  0 disk
├─sdc1                  8:33   0    2G  0 part
│ └─md0                 9:0    0    2G  0 raid1
│   └─vggeneral-lvol0 253:2    0  100M  0 lvm   /tmp/new
└─sdc2                  8:34   0  511M  0 part
  └─md1                 9:1    0 1018M  0 raid0
```
17. Сделайте `--fail` на устройство в вашем RAID1 md.  
Ответ:
```bash
root@vagrant:/home/vagrant# cat /proc/mdstat
Personalities : [linear] [multipath] [raid0] [raid1] [raid6] [raid5] [raid4] [raid10]
md1 : active raid0 sdc2[1] sdb2[0]
      1042432 blocks super 1.2 512k chunks

md0 : active raid1 sdc1[1] sdb1[0]
      2094080 blocks super 1.2 [2/2] [UU]

unused devices: <none>
root@vagrant:/home/vagrant# mdadm --fail /dev/md0 /dev/sdb1
mdadm: set /dev/sdb1 faulty in /dev/md0
root@vagrant:/home/vagrant# cat /proc/mdstat
Personalities : [linear] [multipath] [raid0] [raid1] [raid6] [raid5] [raid4] [raid10]
md1 : active raid0 sdc2[1] sdb2[0]
      1042432 blocks super 1.2 512k chunks

md0 : active raid1 sdc1[1] sdb1[0](F)
      2094080 blocks super 1.2 [2/1] [_U]

unused devices: <none>
```
18. Подтвердите выводом `dmesg`, что RAID1 работает в деградированном состоянии.  
Ответ:
```bash
[ 3760.765632] md/raid1:md0: Disk failure on sdb1, disabling device.
               md/raid1:md0: Operation continuing on 1 devices.
```
19. Протестируйте целостность файла, несмотря на "сбойный" диск он должен продолжать быть доступен:
     ```bash
     root@vagrant:~# gzip -t /tmp/new/test.gz
     root@vagrant:~# echo $?
     0
     ```
Ответ:
```bash
root@vagrant:/home/vagrant# gzip -t /tmp/new/test.gz
root@vagrant:/home/vagrant# echo $?
0
```
20. Погасите тестовый хост, `vagrant destroy`.  
Ответ:
```bash
vagrant@vagrant:~$ exit
logout
Connection to 172.30.16.1 closed.
gnoy@LAPTOP-CHVMGVOQ:/mnt/c/Users/Gnoy/vagrant/ubuntu-20.04$ vagrant halt
==> default: Attempting graceful shutdown of VM...
gnoy@LAPTOP-CHVMGVOQ:/mnt/c/Users/Gnoy/vagrant/ubuntu-20.04$ vagrant destroy
    default: Are you sure you want to destroy the 'default' VM? [y/N] y
==> default: Destroying VM and associated drives...
```
