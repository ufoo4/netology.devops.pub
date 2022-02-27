###Нетология. Группа DEVSYS-14

1. Какого типа команда `cd`? Попробуйте объяснить, почему она именно такого типа; опишите ход своих мыслей, если считаете что она могла бы быть другого типа.  
Ответ: cd - тип встроенная команда в оболочку shell т.к.:
```bash
gnoy@LAPTOP-CHVMGVOQ:~/git-projects/netology.devops.pub$ type cd
cd is a shell builtin 
``` 
2. Какая альтернатива без pipe команде `grep <some_string> <some_file> | wc -l`? `man grep` поможет в ответе на этот вопрос. Ознакомьтесь с [документом](http://www.smallo.ruhr.de/award.html) о других подобных некорректных вариантах использования pipe.  
Ответ: Нам на помошь придет опция -c. Итоговый вид команды: `grep <some_string> <some_file> -с`
3. Какой процесс с PID `1` является родителем для всех процессов в вашей виртуальной машине Ubuntu 20.04?  
Ответ: `systemd(1)`
4. Как будет выглядеть команда, которая перенаправит вывод stderr `ls` на другую сессию терминала?  
Ответ:  
Ищим соседнюю сессию, затем умышлено пишем кривую команду для проверки
```bash
gnoy@LAPTOP-CHVMGVOQ:~/git-projects/netology.devops.pub$ lsof /dev/pts/*
COMMAND   PID USER   FD   TYPE DEVICE SIZE/OFF NODE NAME
bash       11 gnoy    0u   CHR  136,1      0t0    4 /dev/pts/1
bash       11 gnoy    1u   CHR  136,1      0t0    4 /dev/pts/1
bash       11 gnoy    2u   CHR  136,1      0t0    4 /dev/pts/1
bash       11 gnoy  255u   CHR  136,1      0t0    4 /dev/pts/1
lsof     8361 gnoy    0u   CHR  136,1      0t0    4 /dev/pts/1
lsof     8361 gnoy    1u   CHR  136,1      0t0    4 /dev/pts/1
lsof     8361 gnoy    2u   CHR  136,1      0t0    4 /dev/pts/1
bash    18659 gnoy    0u   CHR  136,3      0t0    6 /dev/pts/3
bash    18659 gnoy    1u   CHR  136,3      0t0    6 /dev/pts/3
bash    18659 gnoy    2u   CHR  136,3      0t0    6 /dev/pts/3
bash    18659 gnoy  255u   CHR  136,3      0t0    6 /dev/pts/3
gnoy@LAPTOP-CHVMGVOQ:~/git-projects/netology.devops.pub$ ls ggg 2> /dev/pts/3
В соседней сессии получаем ответ об ошибке:
gnoy@LAPTOP-CHVMGVOQ:~$ ls: cannot access 'ggg': No such file or directory
```
5. Получится ли одновременно передать команде файл на stdin и вывести ее stdout в другой файл? Приведите работающий пример.  
Ответ: да
```bash
gnoy@LAPTOP-CHVMGVOQ:~$ ls -lh st*
-rw-r--r-- 1 gnoy gnoy 14 Nov 15 18:16 stdin.txt
-rw-r--r-- 1 gnoy gnoy 14 Nov 15 20:06 stdout.txt
gnoy@LAPTOP-CHVMGVOQ:~$ cat stdin.txt
This is stdin
gnoy@LAPTOP-CHVMGVOQ:~$ cat stdout.txt
gnoy@LAPTOP-CHVMGVOQ:~$
gnoy@LAPTOP-CHVMGVOQ:~$ cat < stdin.txt > stdout.txt
gnoy@LAPTOP-CHVMGVOQ:~$ cat stdout.txt
This is stdin
```
6. Получится ли находясь в графическом режиме, вывести данные из PTY в какой-либо из эмуляторов TTY? Сможете ли вы наблюдать выводимые данные?  
Ответ: да
```bash
* Загружаемся в иксы, открываем terminal, выясняем где мы
gnoy@ubuntu-vm02-x11:~$ ps
    PID TTY          TIME CMD
   1637 pts/0    00:00:00 bash
   4362 pts/0    00:00:00 ps
* Запускаем эмулятор терминала (Ctrl+Alt+F3), логинимся
* Переключаемся назад (Ctrl+Alt+F2), выясняем запущенный tty
gnoy@ubuntu-vm02-x11:~$ w
 20:39:06 up 3 min,  2 users,  load average: 1,32, 1,15, 0,51
USER     TTY      FROM             LOGIN@   IDLE   JCPU   PCPU WHAT
gnoy     :0       :0               20:36   ?xdm?  51.44s  0.00s /usr/lib/gdm3/
gnoy     tty3     -                20:38   16.00s  0.05s  0.03s -bash
* gnoy@ubuntu-vm02-x11:~$ echo "Hello, tty3!" > /dev/tty3
* Переключаемся в эмулятор терминала видим:
gnoy@ubuntu-vm02-x11:~$Hello, tty3!
```
7. Выполните команду `bash 5>&1`. К чему она приведет? Что будет, если вы выполните `echo netology > /proc/$$/fd/5`? Почему так происходит?  
Ответ: Команда `bash 5>&1` создаст новый дескриптор `5` и перенаправит вывод в стандартный дескриптор `1`, который является stdout. Итого дескриптор 5 будет равен 1.  
```bash
gnoy@LAPTOP-CHVMGVOQ:~$ ls -lah /proc/$$/fd
total 0
dr-x------ 2 gnoy gnoy  0 Nov 15 21:47 .
dr-xr-xr-x 9 gnoy gnoy  0 Nov 15 21:47 ..
lrwx------ 1 gnoy gnoy 64 Nov 15 21:47 0 -> /dev/pts/1
lrwx------ 1 gnoy gnoy 64 Nov 15 21:47 1 -> /dev/pts/1
lrwx------ 1 gnoy gnoy 64 Nov 15 21:47 2 -> /dev/pts/1
lrwx------ 1 gnoy gnoy 64 Nov 15 21:47 255 -> /dev/pts/1
lrwx------ 1 gnoy gnoy 64 Nov 15 21:47 5 -> /dev/pts/1
```
Команда `echo netology > /proc/$$/fd/5` передаст вывод результата выполнения команды в дескриптор `5`, но т.к. на прошлом шаге мы перенаправили поток данных из `5` в стандартный дескриптор `1`, на экране ивидим выполнения команды:  
```bash
gnoy@LAPTOP-CHVMGVOQ:~$ echo netology > /proc/$$/fd/5
netology
```
###Работа над ошибками  
8. Получится ли в качестве входного потока для pipe использовать только stderr команды, не потеряв при этом отображение stdout на pty? Напоминаем: по умолчанию через pipe передается только stdout команды слева от `|` на stdin команды справа.
Это можно сделать, поменяв стандартные потоки местами через промежуточный новый дескриптор, который вы научились создавать в предыдущем вопросе.  
Ответ: Спасибо на ссылку со статьей! Теперь должно быть правильно :)
```bash
vagrant@vagrant:~$ bash 1>&3
vagrant@vagrant:~$ ls bla-bla-bla /home/vagrant/new_file.txt 2>&1 >&3 | tr '[:lower:]' '[:upper:]'
/home/vagrant/new_file.txt
LS: CANNOT ACCESS 'BLA-BLA-BLA': NO SUCH FILE OR DIRECTORY
```
###Работа над ошибками  
9. Что выведет команда `cat /proc/$$/environ`? Как еще можно получить аналогичный по содержанию вывод?  
Ответ: Да, в первые секунды после прочтения задания я подумал о `env`, перечитав задание обратил внимание на слово `аналогичный` и тут "Остапа понесло"... Первая команда (`cat /proc/$$/environ`) выводит все в одну строку, а вторая (`env`) "по человечьи" :)
```bash
gnoy@LAPTOP-CHVMGVOQ:~$ cat /proc/$$/environ
SHELL=/bin/bashLIBGL_ALWAYS_INDIRECT=1WSL_DISTRO_NAME=UbuntuNAME=LAPTOP-CHVMGVOQPWD=/home/gnoyLOGNAME=gnoyMOTD_SHOWN=update-motdHOME=/home/gnoyLANG=C.UTF-8WSL_INTEROP=/run/WSL/8_interopLS_COLORS=rs=0:di=01;34:ln=01;36:mh=00:pi=40;33:so=01;35:do=01;35:bd=40;33;01:cd=40;33;01:or=40;31;01:mi=00:su=37;41:sg=30;43:ca=30;41:tw=30;42:ow=34;42:st=37;44:ex=01;32:*.tar=01;31:*.tgz=01;31:*.arc=01;31:*.arj=01;31:*.taz=01;31:*.lha=01;31:*.lz4=01;31:*.lzh=01;31:*.lzma=01;31:*.tlz=01;31:*.txz=01;31:*.tzo=01;31:*.t7z=01;31:*.zip=01;31:*.z=01;31:*.dz=01;31:*.gz=01;31:*.lrz=01;31:*.lz=01;31:*.lzo=01;31:*.xz=01;31:*.zst=01;31:*.tzst=01;31:*.bz2=01;31:*.bz=01;31:*.tbz=01;31:*.tbz2=01;31:*.tz=01;31:*.deb=01;31:*.rpm=01;31:*.jar=01;31:*.war=01;31:*.ear=01;31:*.sar=01;31:*.rar=01;31:*.alz=01;31:*.ace=01;31:*.zoo=01;31:*.cpio=01;31:*.7z=01;31:*.rz=01;31:*.cab=01;31:*.wim=01;31:*.swm=01;31:*.dwm=01;31:*.esd=01;31:*.jpg=01;35:*.jpeg=01;35:*.mjpg=01;35:*.mjpeg=01;35:*.gif=01;35:*.bmp=01;35:*.pbm=01;35:*.pgm=01;35:*.ppm=01;35:*.tga=01;35:*.xbm=01;35:*.xpm=01;35:*.tif=01;35:*.tiff=01;35:*.png=01;35:*.svg=01;35:*.svgz=01;35:*.mng=01;35:*.pcx=01;35:*.mov=01;35:*.mpg=01;35:*.mpeg=01;35:*.m2v=01;35:*.mkv=01;35:*.webm=01;35:*.ogm=01;35:*.mp4=01;35:*.m4v=01;35:*.mp4v=01;35:*.vob=01;35:*.qt=01;35:*.nuv=01;35:*.wmv=01;35:*.asf=01;35:*.rm=01;35:*.rmvb=01;35:*.flc=01;35:*.avi=01;35:*.fli=01;35:*.flv=01;35:*.gl=01;35:*.dl=01;35:*.xcf=01;35:*.xwd=01;35:*.yuv=01;35:*.cgm=01;35:*.emf=01;35:*.ogv=01;35:*.ogx=01;35:*.aac=00;36:*.au=00;36:*.flac=00;36:*.m4a=00;36:*.mid=00;36:*.midi=00;36:*.mka=00;36:*.mp3=00;36:*.mpc=00;36:*.ogg=00;36:*.ra=00;36:*.wav=00;36:*.oga=00;36:*.opus=00;36:*.spx=00;36:*.xspf=00;36:WAYLAND_DISPLAY=wayland-0SSH_CONNECTION=127.0.0.1 48170 127.0.0.1 22008LESSCLOSE=/usr/bin/lesspipe %s %sTERM=xterm-256colorLESSOPEN=| /usr/bin/lesspipe %sUSER=gnoyDISPLAY=localhost:10.0SHLVL=2XDG_RUNTIME_DIR=/mnt/wslg/runtime-dirSSH_CLIENT=127.0.0.1 48170 22008WSLENV=XDG_DATA_DIRS=/usr/local/share:/usr/share:/var/lib/snapd/desktopVAGRANT_WSL_ENABLE_WINDOWS_ACCESS=1PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games:/usr/local/games:/usr/lib/wsl/lib:/mnt/c/Program Files/WindowsApps/CanonicalGroupLimited.UbuntuonWindows_2004.2021.825.0_x64__79rhkp1fndgsc:/mnt/c/Users/Gnoy/OneDrive/7496~1/MobaXterm/slash/gnoy_laptopchvmgvoq/bin:/mnt/c/WINDOWS/:/mnt/c/WINDOWS/system32/:/mnt/c/Program Files (x86)/VMware/VMware Workstation/bin/:/mnt/c/WINDOWS/system32:/mnt/c/WINDOWS:/mnt/c/WINDOWS/System32/Wbem:/mnt/c/WINDOWS/System32/WindowsPowerShell/v1.0/:/mnt/c/Program Files/Git/cmd:/mnt/c/Users/Gnoy/AppData/Local/Microsoft/WindowsApps:/mnt/c/Program Files/JetBrains/PyCharm Community Edition 2021.2.2/bin:/mnt/c/WINDOWS/sysnative/:/snap/bin:/mnt/c/Program Files/Oracle/VirtualBox:/mnt/c/Program Files/Oracle/VirtualBoxSSH_TTY=/dev/pts/1HOSTTYPE=x86_64PULSE_SERVER=/mnt/wslg/PulseServer_=/usr/bin/bashgnoy@LAPTOP-CHVMGVOQ:~$
gnoy@LAPTOP-CHVMGVOQ:~$ env
SHELL=/bin/bash
LIBGL_ALWAYS_INDIRECT=1
WSL_DISTRO_NAME=Ubuntu
NAME=LAPTOP-CHVMGVOQ
PWD=/home/gnoy
LOGNAME=gnoy
MOTD_SHOWN=update-motd
HOME=/home/gnoy
LANG=C.UTF-8
WSL_INTEROP=/run/WSL/8_interop
LS_COLORS=rs=0:di=01;34:ln=01;36:mh=00:pi=40;33:so=01;35:do=01;35:bd=40;33;01:cd=40;33;01:or=40;31;01:mi=00:su=37;41:sg=30;43:ca=30;41:tw=30;42:ow=34;42:st=37;44:ex=01;32:*.tar=01;31:*.tgz=01;31:*.arc=01;31:*.arj=01;31:*.taz=01;31:*.lha=01;31:*.lz4=01;31:*.lzh=01;31:*.lzma=01;31:*.tlz=01;31:*.txz=01;31:*.tzo=01;31:*.t7z=01;31:*.zip=01;31:*.z=01;31:*.dz=01;31:*.gz=01;31:*.lrz=01;31:*.lz=01;31:*.lzo=01;31:*.xz=01;31:*.zst=01;31:*.tzst=01;31:*.bz2=01;31:*.bz=01;31:*.tbz=01;31:*.tbz2=01;31:*.tz=01;31:*.deb=01;31:*.rpm=01;31:*.jar=01;31:*.war=01;31:*.ear=01;31:*.sar=01;31:*.rar=01;31:*.alz=01;31:*.ace=01;31:*.zoo=01;31:*.cpio=01;31:*.7z=01;31:*.rz=01;31:*.cab=01;31:*.wim=01;31:*.swm=01;31:*.dwm=01;31:*.esd=01;31:*.jpg=01;35:*.jpeg=01;35:*.mjpg=01;35:*.mjpeg=01;35:*.gif=01;35:*.bmp=01;35:*.pbm=01;35:*.pgm=01;35:*.ppm=01;35:*.tga=01;35:*.xbm=01;35:*.xpm=01;35:*.tif=01;35:*.tiff=01;35:*.png=01;35:*.svg=01;35:*.svgz=01;35:*.mng=01;35:*.pcx=01;35:*.mov=01;35:*.mpg=01;35:*.mpeg=01;35:*.m2v=01;35:*.mkv=01;35:*.webm=01;35:*.ogm=01;35:*.mp4=01;35:*.m4v=01;35:*.mp4v=01;35:*.vob=01;35:*.qt=01;35:*.nuv=01;35:*.wmv=01;35:*.asf=01;35:*.rm=01;35:*.rmvb=01;35:*.flc=01;35:*.avi=01;35:*.fli=01;35:*.flv=01;35:*.gl=01;35:*.dl=01;35:*.xcf=01;35:*.xwd=01;35:*.yuv=01;35:*.cgm=01;35:*.emf=01;35:*.ogv=01;35:*.ogx=01;35:*.aac=00;36:*.au=00;36:*.flac=00;36:*.m4a=00;36:*.mid=00;36:*.midi=00;36:*.mka=00;36:*.mp3=00;36:*.mpc=00;36:*.ogg=00;36:*.ra=00;36:*.wav=00;36:*.oga=00;36:*.opus=00;36:*.spx=00;36:*.xspf=00;36:
WAYLAND_DISPLAY=wayland-0
SSH_CONNECTION=127.0.0.1 48170 127.0.0.1 22008
LESSCLOSE=/usr/bin/lesspipe %s %s
TERM=xterm-256color
LESSOPEN=| /usr/bin/lesspipe %s
USER=gnoy
DISPLAY=localhost:10.0
SHLVL=3
XDG_RUNTIME_DIR=/mnt/wslg/runtime-dir
SSH_CLIENT=127.0.0.1 48170 22008
WSLENV=
XDG_DATA_DIRS=/usr/local/share:/usr/share:/var/lib/snapd/desktop
VAGRANT_WSL_ENABLE_WINDOWS_ACCESS=1
PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games:/usr/local/games:/usr/lib/wsl/lib:/mnt/c/Program Files/WindowsApps/CanonicalGroupLimited.UbuntuonWindows_2004.2021.825.0_x64__79rhkp1fndgsc:/mnt/c/Users/Gnoy/OneDrive/7496~1/MobaXterm/slash/gnoy_laptopchvmgvoq/bin:/mnt/c/WINDOWS/:/mnt/c/WINDOWS/system32/:/mnt/c/Program Files (x86)/VMware/VMware Workstation/bin/:/mnt/c/WINDOWS/system32:/mnt/c/WINDOWS:/mnt/c/WINDOWS/System32/Wbem:/mnt/c/WINDOWS/System32/WindowsPowerShell/v1.0/:/mnt/c/Program Files/Git/cmd:/mnt/c/Users/Gnoy/AppData/Local/Microsoft/WindowsApps:/mnt/c/Program Files/JetBrains/PyCharm Community Edition 2021.2.2/bin:/mnt/c/WINDOWS/sysnative/:/snap/bin:/mnt/c/Program Files/Oracle/VirtualBox:/mnt/c/Program Files/Oracle/VirtualBox:/mnt/c/Program Files/Oracle/VirtualBox
SSH_TTY=/dev/pts/1
HOSTTYPE=x86_64
PULSE_SERVER=/mnt/wslg/PulseServer
_=/usr/bin/env
gnoy@LAPTOP-CHVMGVOQ:~$

```
10. Используя `man`, опишите что доступно по адресам `/proc/<PID>/cmdline`, `/proc/<PID>/exe`.  
Ответ: По адресу `/proc/<PID>/cmdline` доступен файл только для чтения, который содержит командную строку для процесса, только если процесс не является зомби -_-  
По адресу `/proc/<PID>/exe` находится файл, представляющий собой символическую ссылку на исполняемую команду.
```bash
gnoy@LAPTOP-CHVMGVOQ:~$ ls -lah /proc/$$/exe
lrwxrwxrwx 1 gnoy gnoy 0 Nov 16 14:48 /proc/912/exe -> /usr/bin/bash
```
11. Узнайте, какую наиболее старшую версию набора инструкций SSE поддерживает ваш процессор с помощью `/proc/cpuinfo`.  
Ответ: SSE 4.2
```bash
gnoy@LAPTOP-CHVMGVOQ:~$ cat /proc/cpuinfo | grep flags | tail -n1 | grep sse
flags  : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pat pse36 clflush mmx fxsr sse sse2 ht syscall nx mmxext fxsr_opt pdpe1gb rdtscp lm constant_tsc rep_good nopl tsc_reliable nonstop_tsc cpuid extd_apicid pni pclmulqdq ssse3 fma cx16 sse4_1 sse4_2 movbe popcnt aes xsave avx f16c rdrand hypervisor lahf_lm cmp_legacy svm cr8_legacy abm sse4a misalignsse 3dnowprefetch osvw topoext ssbd ibrs ibpb stibp vmmcall fsgsbase bmi1 avx2 smep bmi2 rdseed adx smap clflushopt clwb sha_ni xsaveopt xsavec xgetbv1 xsaves clzero xsaveerptr arat npt nrip_save tsc_scale vmcb_clean flushbyasid decodeassists pausefilter pfthreshold v_vmsave_vmload umip rdpid

```
12. При открытии нового окна терминала и `vagrant ssh` создается новая сессия и выделяется pty. Это можно подтвердить командой `tty`, которая упоминалась в лекции 3.2. Однако:

     ```bash
     vagrant@netology1:~$ ssh localhost 'tty'
     not a tty
     ```

     Почитайте, почему так происходит, и как изменить поведение.  
Ответ: Команду необходимо передать с парамтром -t  
```bash
vagrant@vagrant:~$ ssh -tt localhost 'tty'
vagrant@localhost's password:
/dev/pts/1
Connection to localhost closed.
vagrant@vagrant:~$ ssh -t 10.0.2.15 'uptime'
vagrant@10.0.2.15's password:
 23:08:10 up 10:23,  3 users,  load average: 0,00, 0,00, 0,00
Connection to 10.0.2.15 closed.
```
13. Бывает, что есть необходимость переместить запущенный процесс из одной сессии в другую. Попробуйте сделать это, воспользовавшись `reptyr`. Например, так можно перенести в `screen` процесс, который вы запустили по ошибке в обычной SSH-сессии.  
Ответ: Запускаем две сессии ssh, проверяем tty
```bash
gnoy@LAPTOP-CHVMGVOQ:~$ tty
/dev/pts/1
gnoy@LAPTOP-CHVMGVOQ:~$ tty
/dev/pts/3
```
В первой сессии запускаем top
```bash
top - 21:50:05 up 20:47,  0 users,  load average: 0.02, 0.03, 0.06
Tasks:  20 total,   1 running,  19 sleeping,   0 stopped,   0 zombie
%Cpu(s):  0.0 us,  0.0 sy,  0.0 ni,100.0 id,  0.0 wa,  0.0 hi,  0.0 si,  0.0 st
MiB Mem :   7637.7 total,   7254.1 free,    275.2 used,    108.3 buff/cache
MiB Swap:   2048.0 total,   2048.0 free,      0.0 used.   7172.1 avail Mem

  PID USER      PR  NI    VIRT    RES    SHR S  %CPU  %MEM     TIME+ COMMAND
 9463 gnoy      20   0    8620   3400   3128 S   0.3   0.0   0:00.23 bash
    1 root      20   0    1744   1080   1016 S   0.0   0.0   0:00.01 init
```
Нажимаем Ctrl+Z, затем:
```bash
[1]+  Stopped                 top
gnoy@LAPTOP-CHVMGVOQ:~$
gnoy@LAPTOP-CHVMGVOQ:~$ bg
[1]+ top &
gnoy@LAPTOP-CHVMGVOQ:~$ jobs -l
[1]+ 10073 Stopped (signal)        top
gnoy@LAPTOP-CHVMGVOQ:~$ disown top
-bash: warning: deleting stopped job 1 with process group 10073
gnoy@LAPTOP-CHVMGVOQ:~$ ps -a
  PID TTY          TIME CMD
10073 pts/1    00:00:00 top
10783 pts/1    00:00:00 ps
```
Открываем второй терминал
```bash
gnoy@LAPTOP-CHVMGVOQ:~$ reptyr 10073
top - 21:53:32 up 20:50,  0 users,  load average: 0.12, 0.04, 0.05
Tasks:  28 total,   1 running,  26 sleeping,   0 stopped,   1 zombie
%Cpu(s):  0.0 us,  0.1 sy,  0.0 ni, 99.8 id,  0.0 wa,  0.0 hi,  0.0 si,  0.0 st
MiB Mem :   7637.7 total,   7219.8 free,    277.1 used,    140.8 buff/cache
MiB Swap:   2048.0 total,   2048.0 free,      0.0 used.   7154.1 avail Mem

  PID USER      PR  NI    VIRT    RES    SHR S  %CPU  %MEM     TIME+ COMMAND
 9463 gnoy      20   0    8620   3400   3128 S   0.5   0.0   0:01.28 bash
11060 gnoy      20   0    8620   3340   3068 S   0.2   0.0   0:00.35 bash
11540 gnoy      20   0    8620   3352   3076 S   0.1   0.0   0:00.15 bash
```
Все, первый терминал свободен, в нем можно работать, закрывать, запускать.
```bash
gnoy@LAPTOP-CHVMGVOQ:~$ ps -a
  PID TTY          TIME CMD
12024 pts/3    00:00:01 reptyr
12025 pts/1    00:00:00 top <defunct>
12503 pts/1    00:00:00 ps
```
14. `sudo echo string > /root/new_file` не даст выполнить перенаправление под обычным пользователем, так как перенаправлением занимается процесс shell'а, который запущен без `sudo` под вашим пользователем. Для решения данной проблемы можно использовать конструкцию `echo string | sudo tee /root/new_file`. Узнайте что делает команда `tee` и почему в отличие от `sudo echo` команда с `sudo tee` будет работать.  
Ответ:  
Команда `tee` предназначена для чтения стандартного потока ввода и записи в стандартный поток вывода или в файл(ы)  
Команда `sudo echo string > /root/new_file` не работает т.к. под sudo выполняется echo. Перенаправление вывода в /root/new_file все так же осуществляется моей оболочкой без прави суперпользователя.  
Используя команду `echo string | sudo tee /root/new_file` мы непосредственно команду `tee` запускаем под `sudo`, тем самым, можем писать в /root/

