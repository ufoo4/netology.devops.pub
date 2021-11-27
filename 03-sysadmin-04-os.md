# Домашнее задание к занятию "3.4. Операционные системы, лекция 2"

1. На лекции мы познакомились с [node_exporter](https://github.com/prometheus/node_exporter/releases). В демонстрации его исполняемый файл запускался в background. Этого достаточно для демо, но не для настоящей production-системы, где процессы должны находиться под внешним управлением. Используя знания из лекции по systemd, создайте самостоятельно простой [unit-файл](https://www.freedesktop.org/software/systemd/man/systemd.service.html) для node_exporter:

    * поместите его в автозагрузку,
    * предусмотрите возможность добавления опций к запускаемому процессу через внешний файл (посмотрите, например, на `systemctl cat cron`),
    * удостоверьтесь, что с помощью systemctl процесс корректно стартует, завершается, а после перезагрузки автоматически поднимается.  

Ответ:  
Службы запускаеются, в т.ч. после reboot'а:
```bash
root@netmon:~# ps -e | grep -E 'prom|node'
    807 ?        00:00:09 prometheus
  10145 ?        00:00:00 node_exporter
```
Автозагрузка включена:
```bash
root@netmon:~# ls -lh /etc/systemd/system/multi-user.target.wants | grep -E "prom|node"
lrwxrwxrwx 1 root root 41 Nov 23 15:29 node_exporter.service -> /etc/systemd/system/node_exporter.service
lrwxrwxrwx 1 root root 38 Nov 23 11:28 prometheus.service -> /etc/systemd/system/prometheus.service
```
Доступ к сервисам имеется, в браузере так же все хорошо:
```bash
root@netmon:~# curl -i http://localhost:9090 | head -1
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
100    29  100    29    0     0  14500      0 --:--:-- --:--:-- --:--:-- 14500
HTTP/1.1 302 Found
root@netmon:~# curl -i http://localhost:9100 | head -1
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
100   150  100   150    0     0  75000      0 --:--:-- --:--:-- --:--:-- 75000
HTTP/1.1 200 OK
```
Конфиг node_exporter.service + environment.file:
```bash
root@netmon:/usr/local/bin# cat /usr/local/bin/environment.file
APPLICATION_OPTIONS=
root@netmon:~# systemctl cat node_exporter
# /etc/systemd/system/node_exporter.service
[Unit]
Description=Node Exporter Service
After=network.target

[Service]
EnvironmentFile=/usr/local/bin/environment.file
User=nodeuser
Group=nodeuser
Type=simple
ExecStart=/usr/local/bin/node_exporter $APPLICATION_OPTIONS
ExecReload=/bin/kill -HUP $MAINPID
Restart=on-failure

[Install]
WantedBy=multi-user.target
```
2. Ознакомьтесь с опциями node_exporter и выводом `/metrics` по-умолчанию. Приведите несколько опций, которые вы бы выбрали для базового мониторинга хоста по CPU, памяти, диску и сети.  

Ответ:  Я бы выбрал следующие опции:  
CPU:
```bash
node_cpu_seconds_total{cpu="0",mode="idle"} 18614.92
node_cpu_seconds_total{cpu="0",mode="system"} 39.46
node_cpu_seconds_total{cpu="0",mode="user"} 47.6
```
Память:
```bash
node_memory_MemTotal_bytes 2.084237312e+09
node_memory_MemFree_bytes 1.377878016e+09
node_memory_MemAvailable_bytes 1.709387776e+09
```
Диск:
```bash
node_filesystem_size_bytes{device="/dev/mapper/ubuntu--vg-ubuntu--lv",fstype="ext4",mountpoint="/"} 1.9942490112e+10
node_filesystem_avail_bytes{device="/dev/mapper/ubuntu--vg-ubuntu--lv",fstype="ext4",mountpoint="/"} 1.3938896896e+10
node_disk_io_time_seconds_total{device="sda"} 41.672000000000004
node_disk_write_time_seconds_total{device="sda"} 43.498
```
Сеть:
```bash
node_network_up{device="ens160"} 1
node_network_receive_bytes_total{device="ens160"} 2.5661784e+07
node_network_transmit_bytes_total{device="ens160"} 8.947528e+06
node_network_address_assign_type{device="ens160"} 0
node_network_transmit_errs_total{device="ens160"} 0
```
3. Установите в свою виртуальную машину [Netdata](https://github.com/netdata/netdata). Воспользуйтесь [готовыми пакетами](https://packagecloud.io/netdata/netdata/install) для установки (`sudo apt install -y netdata`). После успешной установки:
    * в конфигурационном файле `/etc/netdata/netdata.conf` в секции [web] замените значение с localhost на `bind to = 0.0.0.0`,
    * добавьте в Vagrantfile проброс порта Netdata на свой локальный компьютер и сделайте `vagrant reload`:

    ```bash
    config.vm.network "forwarded_port", guest: 19999, host: 19999
    ```

    После успешной перезагрузки в браузере *на своем ПК* (не в виртуальной машине) вы должны суметь зайти на `localhost:19999`. Ознакомьтесь с метриками, которые по умолчанию собираются Netdata и с комментариями, которые даны к этим метрикам.  

Ответ:  Ознакомился. Метрик по умолчанию очень много, из "коробки" проще чем Prometheus :)
```bash
vagrant@vagrant:~$ sudo lsof -i :19999
COMMAND PID    USER   FD   TYPE DEVICE SIZE/OFF NODE NAME
netdata 601 netdata    4u  IPv4  22669      0t0  TCP *:19999 (LISTEN)
```
![netdata](https://github.com/gnoy4eg/netology.devops.pub/tree/main/img/netdata.png)

4. Можно ли по выводу `dmesg` понять, осознает ли ОС, что загружена не на настоящем оборудовании, а на системе виртуализации?  
Ответ:  Да, система понимает, что загружается как ВМ. Так же она понимает на каком гипервизоре осуществляется загрузка.  
Вывод `dmesg` проверил на двух гипервизорах: VirtualBox и VMware
```bash
vagrant@vagrant:~$ dmesg | grep -E "hyper|virt"
[    0.003898] CPU MTRRs all blank - virtualized system.
[    0.034843] Booting paravirtualized kernel on KVM
[    0.225748] Performance Events: PMU not available due to virtualization, using software events only.
[    4.479926] systemd[1]: Detected virtualization oracle.
```
```bash
root@netmon:/usr/local/bin# dmesg | grep -E "hyper|virt"
[    0.000000] vmware: hypercall mode: 0x02
[    0.000000] vmware: TSC freq read from hypervisor : 3092.734 MHz
[    0.000000] vmware: Host bus clock speed read from hypervisor : 66000000 Hz
[    0.016771] Booting paravirtualized kernel on VMware hypervisor
[    1.194629] VMware vmxnet3 virtual NIC driver - version 1.4.17.0-k-NAPI
[    1.265429] [drm] Max dedicated hypervisor surface memory is 0 kiB
[    3.122990] systemd[1]: Detected virtualization vmware.
```
5. Как настроен sysctl `fs.nr_open` на системе по-умолчанию? Узнайте, что означает этот параметр. Какой другой существующий лимит не позволит достичь такого числа (`ulimit --help`)?  
Ответ:  Этот параметр отвечает за максимальное число открытых дескрипторов.  
У параметра `fs.nr_open` значение по умолчанию равно 1048576 (1024 * 1024). Максимальное значение ограничено ядром `sysctl_nr_open_max` и составляет 2147483584
```bash
root@vagrant:/tmp# sysctl fs.nr_open
fs.nr_open = 1048576
root@vagrant:/tmp# ulimit -n 2147483584
bash: ulimit: open files: cannot modify limit: Operation not permitted
root@vagrant:/tmp# sysctl -w fs.nr_open=2147483584
fs.nr_open = 2147483584
root@vagrant:/tmp# sysctl fs.nr_open
fs.nr_open = 2147483584
root@vagrant:/tmp# sysctl -w fs.nr_open=2147483585
sysctl: setting key "fs.nr_open": Invalid argument
root@vagrant:/tmp# sysctl -w fs.nr_open=1048576
fs.nr_open = 1048576
root@vagrant:/tmp# sysctl fs.nr_open
fs.nr_open = 1048576
```
6. Запустите любой долгоживущий процесс (не `ls`, который отработает мгновенно, а, например, `sleep 1h`) в отдельном неймспейсе процессов; покажите, что ваш процесс работает под PID 1 через `nsenter`. Для простоты работайте в данном задании под root (`sudo -i`). Под обычным пользователем требуются дополнительные опции (`--map-root-user`) и т.д.  
Ответ:
```bash
root@vagrant:/home/vagrant# screen
vagrant@vagrant:~$ sudo su
root@vagrant:/home/vagrant# unshare -f --pid --mount-proc /bin/bash
root@vagrant:/home/vagrant# ps
    PID TTY          TIME CMD
      1 pts/1    00:00:00 bash
      9 pts/1    00:00:00 ps
root@vagrant:/home/vagrant# sleep 1h
^Z
[1]+  Stopped                 sleep 1h
root@vagrant:/home/vagrant# bg
[1]+ sleep 1h &
root@vagrant:/home/vagrant# ps
    PID TTY          TIME CMD
      1 pts/1    00:00:00 bash
     10 pts/1    00:00:00 sleep
     11 pts/1    00:00:00 ps
```
В соседнем терминале:
```bash
vagrant@vagrant:~$ sudo su
root@vagrant:/home/vagrant# ps -e | grep sleep
   1326 pts/1    00:00:00 sleep
root@vagrant:/home/vagrant# nsenter --target 1326 --pid --mount
root@vagrant:/# ps aux
USER         PID %CPU %MEM    VSZ   RSS TTY      STAT START   TIME COMMAND
root           1  0.0  0.4   9972  4216 pts/1    S+   12:53   0:00 /bin/bash
root          10  0.0  0.0   8080   532 pts/1    S    12:53   0:00 sleep 1h
root          12  0.0  0.4   9972  4256 pts/2    S    12:55   0:00 -bash
root          22  0.0  0.3  11496  3444 pts/2    R+   12:55   0:00 ps aux
```
7. Найдите информацию о том, что такое `:(){ :|:& };:`. Запустите эту команду в своей виртуальной машине Vagrant с Ubuntu 20.04 (**это важно, поведение в других ОС не проверялось**). Некоторое время все будет "плохо", после чего (минуты) – ОС должна стабилизироваться. Вызов `dmesg` расскажет, какой механизм помог автоматической стабилизации. Как настроен этот механизм по-умолчанию, и как изменить число процессов, которое можно создать в сессии?  
Ответ: Смайлики! Определенно, смайлики! :))  
Это функция, которая параллельно пускает два своих экземпляра. Каждый пускает ещё по два и т.д.  
При отсутствии лимита на число процессов машина быстро исчерпывает физическую память и уходит в своп.
Для наглядности можно заменить `:` именем `f` и отформатировать код.
```bash
f() {
  f | f &
}
f
```
Пользователю можно установить лимит на 60 запущенных процессов командой `ulimit -n 60`  
Система начинает блокировать порождение больших процессов и мы получаем следующее:
```bash
vagrant@vagrant:~$ dmesg | tail -2
[ 1918.924857] cgroup: fork rejected by pids controller in /user.slice/user-1000.slice/session-7.scope
[ 2246.117547] cgroup: fork rejected by pids controller in /user.slice/user-1000.slice/session-8.scope
```
