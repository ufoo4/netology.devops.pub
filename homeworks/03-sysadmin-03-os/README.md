# Домашнее задание к занятию "3.3. Операционные системы, лекция 1"

1. Какой системный вызов делает команда `cd`? В прошлом ДЗ мы выяснили, что `cd` не является самостоятельной  программой, это `shell builtin`, поэтому запустить `strace` непосредственно на `cd` не получится. Тем не менее, вы можете запустить `strace` на `/bin/bash -c 'cd /tmp'`. В этом случае вы увидите полный список системных вызовов, которые делает сам `bash` при старте. Вам нужно найти тот единственный, который относится именно к `cd`. Обратите внимание, что `strace` выдаёт результат своей работы в поток stderr, а не в stdout.  
Ответ: chdir - смена текущей дериктории
```bash
chdir("/tmp")                           = 0
```
2. Попробуйте использовать команду `file` на объекты разных типов на файловой системе. Например:
    ```bash
    vagrant@netology1:~$ file /dev/tty
    /dev/tty: character special (5/0)
    vagrant@netology1:~$ file /dev/sda
    /dev/sda: block special (8/0)
    vagrant@netology1:~$ file /bin/bash
    /bin/bash: ELF 64-bit LSB shared object, x86-64
    ```
    Используя `strace` выясните, где находится база данных `file` на основании которой она делает свои догадки.  
Ответ: Я думаю, что база программы `file` находится по пути `"/usr/share/misc/magic.mgc"` т.к. в листинге первые 3 пути не найдены, четвертый - заголовок, а пятый путь имеет приличный размер + "кракозяблы" внутри файла.
```bash
futex(0x7f39b5d1e634, FUTEX_WAKE_PRIVATE, 2147483647) = 0
stat("/home/gnoy/.magic.mgc", 0x7fff0feef510) = -1 ENOENT (No such file or directory)
stat("/home/gnoy/.magic", 0x7fff0feef510) = -1 ENOENT (No such file or directory)
openat(AT_FDCWD, "/etc/magic.mgc", O_RDONLY) = -1 ENOENT (No such file or directory)
stat("/etc/magic", {st_mode=S_IFREG|0644, st_size=111, ...}) = 0
openat(AT_FDCWD, "/etc/magic", O_RDONLY) = 3
fstat(3, {st_mode=S_IFREG|0644, st_size=111, ...}) = 0
read(3, "# Magic local data for file(1) c"..., 4096) = 111
read(3, "", 4096)                       = 0
close(3)                                = 0
openat(AT_FDCWD, "/usr/share/misc/magic.mgc", O_RDONLY) = 3
fstat(3, {st_mode=S_IFREG|0644, st_size=5811536, ...}) = 0
mmap(NULL, 5811536, PROT_READ|PROT_WRITE, MAP_PRIVATE, 3, 0) = 0x7f39b520e000
close(3)                                = 0
```
Уточнение: физически файл с базой находится в другом месте. `"/usr/share/misc/magic.mgc"` - является символической ссылкой
```bash
gnoy@LAPTOP-CHVMGVOQ:~$ readlink -f /usr/share/misc/magic.mgc
/usr/lib/file/magic.mgc
```
3. Предположим, приложение пишет лог в текстовый файл. Этот файл оказался удален (deleted в lsof), однако возможности сигналом сказать приложению переоткрыть файлы или просто перезапустить приложение – нет. Так как приложение продолжает писать в удаленный файл, место на диске постепенно заканчивается. Основываясь на знаниях о перенаправлении потоков предложите способ обнуления открытого удаленного файла (чтобы освободить место на файловой системе).  
Ответ: По итогу log-файл будет обнулен, но работа программы (ping) продолжится.
```bash
gnoy@LAPTOP-CHVMGVOQ:~$ ping 8.8.8.8 >> /tmp/ping.log
^Z
[1]+  Stopped                 ping 8.8.8.8 >> /tmp/ping.log
gnoy@LAPTOP-CHVMGVOQ:~$ bg
[1]+ ping 8.8.8.8 >> /tmp/ping.log &
gnoy@LAPTOP-CHVMGVOQ:~$ jobs
[1]+  Running                 ping 8.8.8.8 >> /tmp/ping.log &
gnoy@LAPTOP-CHVMGVOQ:~$ ps -a | grep ping
25377 pts/1    00:00:00 ping
gnoy@LAPTOP-CHVMGVOQ:~$ sudo lsof -p 25377 | grep ping.log
ping    25377 gnoy    1w   REG   8,32     7005 126835 /tmp/ping.log
gnoy@LAPTOP-CHVMGVOQ:~$ rm /tmp/ping.log
gnoy@LAPTOP-CHVMGVOQ:~$ sudo lsof -p 25377 | grep ping.log
ping    25377 gnoy    1w   REG   8,32     8715 126835 /tmp/ping.log (deleted)
gnoy@LAPTOP-CHVMGVOQ:~$ sudo truncate -s 0 /proc/25377/fd/1
gnoy@LAPTOP-CHVMGVOQ:~$ sudo lsof -p 25377 | grep ping.log
ping    25377 gnoy    1w   REG   8,32      399 126835 /tmp/ping.log (deleted)
gnoy@LAPTOP-CHVMGVOQ:~$ jobs
[1]+  Running                 ping 8.8.8.8 >> /tmp/ping.log &
```
4. Занимают ли зомби-процессы какие-то ресурсы в ОС (CPU, RAM, IO)?  
Ответ:
5. Нет, зомби-процессы не используют системных ресурсов. Просто висят...
```bash
gnoy@LAPTOP-CHVMGVOQ:~$ top | grep zombie
Tasks:  36 total,   1 running,  33 sleeping,   1 stopped,   1 zombie
25904 gnoy      20   0    2492    580    512 T   0.0   0.0   0:00.00 zombie
25905 gnoy      20   0       0      0      0 Z   0.0   0.0   0:00.00 zombie
```
6. В iovisor BCC есть утилита `opensnoop`:
    ```bash
    root@vagrant:~# dpkg -L bpfcc-tools | grep sbin/opensnoop
    /usr/sbin/opensnoop-bpfcc
    ```
    На какие файлы вы увидели вызовы группы `open` за первую секунду работы утилиты? Воспользуйтесь пакетом `bpfcc-tools` для Ubuntu 20.04. Дополнительные [сведения по установке](https://github.com/iovisor/bcc/blob/master/INSTALL.md).  
Ответ:
```bash
vagrant@vagrant:~$ sudo opensnoop-bpfcc
PID    COMM               FD ERR PATH
761    vminfo              5   0 /var/run/utmp
550    dbus-daemon        -1   2 /usr/local/share/dbus-1/system-services
550    dbus-daemon        18   0 /usr/share/dbus-1/system-services
550    dbus-daemon        -1   2 /lib/dbus-1/system-services
550    dbus-daemon        18   0 /var/lib/snapd/dbus-1/system-services/
```
7. Какой системный вызов использует `uname -a`? Приведите цитату из man по этому системному вызову, где описывается альтернативное местоположение в `/proc`, где можно узнать версию ядра и релиз ОС.  
Ответ: В `man 2 uname` есть описание: Part of the utsname information is also accessible via /proc/sys/kernel/{ostype, hostname, osrelease, version, domainname}.
```bash
gnoy@LAPTOP-CHVMGVOQ:~$ strace -e write uname -a
write(1, "Linux LAPTOP-CHVMGVOQ 5.10.16.3-"..., 122Linux LAPTOP-CHVMGVOQ 5.10.16.3-microsoft-standard-WSL2 #1 SMP Fri Apr 2 22:23:49 UTC 2021 x86_64 x86_64 x86_64 GNU/Linux) = 122
```
8. Чем отличается последовательность команд через `;` и через `&&` в bash? Например:
    ```bash
    root@netology1:~# test -d /tmp/some_dir; echo Hi
    Hi
    root@netology1:~# test -d /tmp/some_dir && echo Hi
    root@netology1:~#
    ```
    Есть ли смысл использовать в bash `&&`, если применить `set -e`?  
Ответ: Программы разделенные `;` выполняются последовательно, bash ждет выполнения одной команды и после запускает вторую.  
Если программы разделены `&&`, то оболочка ждет выполнения первой и только в случае успеха (статус 0) запускает на выполнение вторую команду.  
Ключ `-e` у программы `set` позволяет прерывать работу сценария если на выходе выполнения программы будет не нулевой код, но применяться не будет если ранее проверено `&&`. Как итог, можно не использовать в bash `&&`
9. Из каких опций состоит режим bash `set -euxo pipefail` и почему его хорошо было бы использовать в сценариях?  
Ответ:  
`-e` - указывает оболочке выйте если выполнение команды не True т.е. не равно 0
`-u` - обрабатывает неустановленные или неопределенные переменные
`-x` - позволяет печатать аргументы команды во время выполнения
`-o` - дополнитльных опций достаточно много, прямо в сценарии можно свтавлять доп. опции
При выполненнии сценария с этими опциями мы можем визуально видеть что с ним происходит, автоматически прерывать выполнение если где-то ошибка. 
10. Используя `-o stat` для `ps`, определите, какой наиболее часто встречающийся статус у процессов в системе. В `man ps` ознакомьтесь (`/PROCESS STATE CODES`) что значат дополнительные к основной заглавной буквы статуса процессов. Его можно не учитывать при расчете (считать S, Ss или Ssl равнозначными).  
Ответ: Самый часто встречающийся статус у процессов - S (ожидание завершения события). Чуть ниже скопирую несколько процессов со статусами.  
Так же имеются дополнительные статусы процессов (чуть ниже приведу несколько примеров):
`<` - процесс с высоким приоритетом  
`N` - процесс с низким приоритетом  
`L` - процесс имеет залоченные страницы в памяти  
`s` - процесс является лидером сеанса  
`l` - процесс является многопоточным  
`+` - процесс находится в группе процессов, который видно (на переднем плане) 
```bash
itrm@zulip:~$ ps aux
USER         PID %CPU %MEM    VSZ   RSS TTY      STAT START   TIME COMMAND
zulip        985  0.0  0.4  78656 19588 ?        S    ноя16   0:03 nginx: worker process
root         500  0.0  3.1 263648 126856 ?       S<s  ноя16   2:27 /lib/systemd/systemd-journald
zulip     902043  0.0  3.5 247604 144420 ?       SN   06:00   0:27 python3 /home/zulip/deployments/current/manage.py deliver_scheduled_emails
root         717  0.0  0.4 345816 18212 ?        SLsl ноя16   5:13 /sbin/multipathd -d -s
systemd+     815  0.0  0.1  26604  5612 ?        Ss   ноя16   0:05 /lib/systemd/systemd-networkd
root         894  0.0  0.0   2860  1760 tty1     Ss+  ноя16   0:00 /sbin/agetty -o -p -- \u --noclear tty1 linux
```

