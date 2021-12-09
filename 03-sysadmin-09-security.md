# Домашнее задание к занятию "3.9. Элементы безопасности информационных систем"

1. Установите Bitwarden плагин для браузера. Зарегестрируйтесь и сохраните несколько паролей.  
Ответ:  Серверная часть установлена в docker-контейнере на домашнем сервере. Пользуюсь постоянно. Отличный софт.  
![bitwarden-plugin](https://github.com/gnoy4eg/netology.devops.pub/blob/main/img/bitwarden-plugin.png)
2. Установите Google authenticator на мобильный телефон. Настройте вход в Bitwarden акаунт через Google authenticator OTP.  
Ответ:  Установил. Теперь, при входе на консоль Bitwarden, запрашивается одноразовый пароль  
![bitwarden-otp](https://github.com/gnoy4eg/netology.devops.pub/blob/main/img/bitwarden-otp.png)
3. Установите apache2, сгенерируйте самоподписанный сертификат, настройте тестовый сайт для работы по HTTPS.  
Ответ: Я не буду описывать создание мини-сайта, главное он есть :)
```bash
ubnt@ubnt32769:~$ sudo  -i
[sudo] password for ubnt:
root@ubnt32769:~# apt install apache2
Reading package lists... Done
Building dependency tree
Reading state information... Done
The following additional packages will be installed:
  apache2-bin apache2-data apache2-utils libapr1 libaprutil1 libaprutil1-dbd-sqlite3 libaprutil1-ldap libjansson4 liblua5.2-0 ssl-cert
Suggested packages:
  apache2-doc apache2-suexec-pristine | apache2-suexec-custom www-browser openssl-blacklist
The following NEW packages will be installed:
  apache2 apache2-bin apache2-data apache2-utils libapr1 libaprutil1 libaprutil1-dbd-sqlite3 libaprutil1-ldap libjansson4 liblua5.2-0 ssl-cert
0 upgraded, 11 newly installed, 0 to remove and 44 not upgraded.
Need to get 1,866 kB of archives.
After this operation, 8,091 kB of additional disk space will be used.
Do you want to continue? [Y/n] y

ubnt@ubnt32769:~$ sudo a2enmod ssl
Considering dependency setenvif for ssl:
Module setenvif already enabled
Considering dependency mime for ssl:
Module mime already enabled
Considering dependency socache_shmcb for ssl:
Enabling module socache_shmcb.
Enabling module ssl.
See /usr/share/doc/apache2/README.Debian.gz on how to configure SSL and create self-signed certificates.
To activate the new configuration, you need to run:
  systemctl restart apache2
ubnt@ubnt32769:~$ systemctl restart apache2
==== AUTHENTICATING FOR org.freedesktop.systemd1.manage-units ===
Authentication is required to restart 'apache2.service'.
Authenticating as: ubnt
Password:
==== AUTHENTICATION COMPLETE ===
ubnt@ubnt32769:~$

ubnt@ubnt32769:~$ sudo openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout /etc/ssl/private/apache-selfsigned.key -out /etc/ssl/certs/apache-selfsigned.crt
Generating a RSA private key
.........................................................................................................................................................................................................+++++
.....+++++
writing new private key to '/etc/ssl/private/apache-selfsigned.key'
-----
You are about to be asked to enter information that will be incorporated
into your certificate request.
What you are about to enter is what is called a Distinguished Name or a DN.
There are quite a few fields but you can leave some blank
For some fields there will be a default value,
If you enter '.', the field will be left blank.
-----
Country Name (2 letter code) [AU]:RU
State or Province Name (full name) [Some-State]:Example
Locality Name (eg, city) []:Example
Organization Name (eg, company) [Internet Widgits Pty Ltd]:Example Inc
Organizational Unit Name (eg, section) []:Example Dept
Common Name (e.g. server FQDN or YOUR name) []:example.com
Email Address []:webmaster@example.com

ubnt@ubnt32769:~$ cat /etc/apache2/sites-available/000-default.conf
<VirtualHost *:443>
        ServerName example.com
        ServerAdmin webmaster@example.com
        DocumentRoot /var/www/html

        <Directory /var/www/html>
                AllowOverride All
        </Directory>

        SSLEngine on
        SSLCertificateFile /etc/ssl/certs/apache-selfsigned.crt
        SSLCertificateKeyFile /etc/ssl/private/apache-selfsigned.key

        ErrorLog ${APACHE_LOG_DIR}/error.log
        CustomLog ${APACHE_LOG_DIR}/access.log combined

</VirtualHost>

ubnt@ubnt32769:~$ sudo apache2ctl configtest
AH00558: apache2: Could not reliably determine the server's fully qualified domain name, using 10.10.10.195. Set the 'ServerName' directive globally to suppress this message
Syntax OK
ubnt@ubnt32769:~$ systemctl restart apache2
==== AUTHENTICATING FOR org.freedesktop.systemd1.manage-units ===
Authentication is required to restart 'apache2.service'.
Authenticating as: ubnt
Password:
==== AUTHENTICATION COMPLETE ===
ubnt@ubnt32769:~$
```
![site-cert](https://github.com/gnoy4eg/netology.devops.pub/blob/main/img/site-cert.png)  
4. Проверьте на TLS уязвимости произвольный сайт в интернете (кроме сайтов МВД, ФСБ, МинОбр, НацБанк, РосКосмос, РосАтом, РосНАНО и любых госкомпаний, объектов КИИ, ВПК ... и тому подобное).   
Ответ:  Проверю свой домен :)
```bash
gnoy@LAPTOP-CHVMGVOQ:~/git-projects$ git clone --depth 1 https://github.com/drwetter/testssl.sh.git
Cloning into 'testssl.sh'...
remote: Enumerating objects: 100, done.
remote: Counting objects: 100% (100/100), done.
remote: Compressing objects: 100% (93/93), done.
remote: Total 100 (delta 14), reused 41 (delta 6), pack-reused 0
Receiving objects: 100% (100/100), 8.61 MiB | 826.00 KiB/s, done.
Resolving deltas: 100% (14/14), done.
gnoy@LAPTOP-CHVMGVOQ:~/git-projects$ cd testssl.sh/
gnoy@LAPTOP-CHVMGVOQ:~/git-projects/testssl.sh$ ./testssl.sh -U --sneaky https://xxx.su


###########################################################
    testssl.sh       3.1dev from https://testssl.sh/dev/
    (04b7e1e 2021-12-07 20:26:00 -- )

      This program is free software. Distribution and
             modification under GPLv2 permitted.
      USAGE w/o ANY WARRANTY. USE IT AT YOUR OWN RISK!

       Please file bugs @ https://testssl.sh/bugs/

###########################################################

 Using "OpenSSL 1.1.1f  31 Mar 2020" [~98 ciphers]
 on LAPTOP-CHVMGVOQ:/usr/bin/openssl
 (built: "Aug 25 01:13:44 2021", platform: "debian-amd64")


 Start 2021-12-08 15:14:17        -->> 92.43.xxx.xxx:443 (xxx.su) <<--

 rDNS (92.43.xxx.xxx):     --
 Service detected:       HTTP


 Testing vulnerabilities

 Heartbleed (CVE-2014-0160)                not vulnerable (OK), timed out
 CCS (CVE-2014-0224)                       not vulnerable (OK)
 Ticketbleed (CVE-2016-9244), experiment.  not vulnerable (OK), no session ticket extension
 ROBOT                                     not vulnerable (OK)
 Secure Renegotiation (RFC 5746)           supported (OK)
 Secure Client-Initiated Renegotiation     not vulnerable (OK)
 CRIME, TLS (CVE-2012-4929)                not vulnerable (OK)
 BREACH (CVE-2013-3587)                    no gzip/deflate/compress/br HTTP compression (OK)  - only supplied "/" tested
 POODLE, SSL (CVE-2014-3566)               not vulnerable (OK)
 TLS_FALLBACK_SCSV (RFC 7507)              Downgrade attack prevention supported (OK)
 SWEET32 (CVE-2016-2183, CVE-2016-6329)    VULNERABLE, uses 64 bit block ciphers
 FREAK (CVE-2015-0204)                     not vulnerable (OK)
 DROWN (CVE-2016-0800, CVE-2016-0703)      not vulnerable on this host and port (OK)
                                           make sure you don't use this certificate elsewhere with SSLv2 enabled services
                                           https://censys.io/ipv4?q=1A4B726A5299C7922E19B4F051546E0D29DA40A59ADF571469411EF68BEA3B42 could help you to find out
 LOGJAM (CVE-2015-4000), experimental      not vulnerable (OK): no DH EXPORT ciphers, no common prime detected
 BEAST (CVE-2011-3389)                     TLS1: ECDHE-RSA-AES128-SHA ECDHE-RSA-AES256-SHA DHE-RSA-AES128-SHA DHE-RSA-AES256-SHA AES128-SHA AES256-SHA ECDHE-RSA-DES-CBC3-SHA EDH-RSA-DES-CBC3-SHA
                                                 DES-CBC3-SHA
                                           VULNERABLE -- but also supports higher protocols  TLSv1.1 TLSv1.2 (likely mitigated)
 LUCKY13 (CVE-2013-0169), experimental     potentially VULNERABLE, uses cipher block chaining (CBC) ciphers with TLS. Check patches
 Winshock (CVE-2014-6321), experimental    not vulnerable (OK) - CAMELLIA or ECDHE_RSA GCM ciphers found
 RC4 (CVE-2013-2566, CVE-2015-2808)        no RC4 ciphers detected (OK)


 Done 2021-12-08 15:15:00 [  46s] -->> 92.43.xxx.xxx:443 (xxx.su) <<--
```
5. Установите на Ubuntu ssh сервер, сгенерируйте новый приватный ключ. Скопируйте свой публичный ключ на другой сервер. Подключитесь к серверу по SSH-ключу.  
Ответ:   
```bash
ubnt@ansible32776:~$ ssh-keygen -t rsa
Generating public/private rsa key pair.
Enter file in which to save the key (/home/ubnt/.ssh/id_rsa):
Created directory '/home/ubnt/.ssh'.
Enter passphrase (empty for no passphrase):
Enter same passphrase again:
Your identification has been saved in /home/ubnt/.ssh/id_rsa
Your public key has been saved in /home/ubnt/.ssh/id_rsa.pub
The key fingerprint is:
SHA256:l3YpC0rXL6ZmyrV+JuhX+d/ODq8Y+Eyh1J2xwQd0y+0 ubnt@ansible32776
The key's randomart image is:
+---[RSA 3072]----+
|             .o .|
|             ..oo|
|              +oo|
|         . o o B |
|      . S B.= + E|
|     . o =oB .   |
|      ....*.+ .  |
|     ...=+o=.o = |
|     .+*++  +.o+*|
+----[SHA256]-----+'
ubnt@ansible32776:~$ ssh-copy-id ubnt@192.168.255.10
/usr/bin/ssh-copy-id: INFO: Source of key(s) to be installed: "/home/ubnt/.ssh/id_rsa.pub"
The authenticity of host '192.168.255.10 (192.168.255.10)' can't be established.
ECDSA key fingerprint is SHA256:H6uATzRFUtrbAU7Zi+Y5fqq7caCBCNNSdrlyP47f0QE.
Are you sure you want to continue connecting (yes/no/[fingerprint])? yes
/usr/bin/ssh-copy-id: INFO: attempting to log in with the new key(s), to filter out any that are already installed
/usr/bin/ssh-copy-id: INFO: 1 key(s) remain to be installed -- if you are prompted now it is to install the new keys
ubnt@192.168.255.10's password:

Number of key(s) added: 1

Now try logging into the machine, with:   "ssh 'ubnt@192.168.255.10'"
and check to make sure that only the key(s) you wanted were added.
ubnt@ansible32776:~$ ssh ubnt@192.168.255.10
Welcome to Ubuntu 20.04.3 LTS (GNU/Linux 5.4.0-91-generic x86_64)

 * Documentation:  https://help.ubuntu.com
 * Management:     https://landscape.canonical.com
 * Support:        https://ubuntu.com/advantage

  System information as of Wed 08 Dec 2021 04:35:42 PM UTC

  System load:  0.0               Processes:             110
  Usage of /:   55.0% of 8.79GB   Users logged in:       1
  Memory usage: 40%               IPv4 address for ens3: 192.168.255.10
  Swap usage:   0%


38 updates can be applied immediately.
2 of these updates are standard security updates.
To see these additional updates run: apt list --upgradable

Failed to connect to https://changelogs.ubuntu.com/meta-release-lts. Check your Internet connection or proxy settings


Last login: Wed Dec  8 16:27:55 2021
ubnt@ubnt32769:~$
```
6. Переименуйте файлы ключей из задания 5. Настройте файл конфигурации SSH клиента, так чтобы вход на удаленный сервер осуществлялся по имени сервера.  
Ответ:  
```bash
ubnt@ansible32776:~$ cd ~/.ssh
ubnt@ansible32776:~/.ssh$ mv id_rsa my_private_key
ubnt@ansible32776:~/.ssh$ mv id_rsa.pub my_public_key.pub
ubnt@ansible32776:~/.ssh$ ls -lah
total 16K
drwx------ 2 ubnt ubnt 4.0K Dec  9 04:27 .
drwxr-xr-x 4 ubnt ubnt 4.0K Dec  9 03:58 ..
-rw------- 1 ubnt ubnt 2.6K Dec  9 04:26 my_private_key
-rw-r--r-- 1 ubnt ubnt  571 Dec  9 04:26 my_public_key.pub
ubnt@ansible32776:~/.ssh$ ssh-copy-id -f -i /home/ubnt/.ssh/my_public_key.pub ubnt@192.168.255.10
/usr/bin/ssh-copy-id: INFO: Source of key(s) to be installed: "/home/ubnt/.ssh/my_public_key.pub"
ubnt@192.168.255.10's password:

Number of key(s) added: 1

Now try logging into the machine, with:   "ssh 'ubnt@192.168.255.10'"
and check to make sure that only the key(s) you wanted were added.'
ubnt@ansible32776:~/.ssh$ cat config
Host mybestofthebestserverlol
    Hostname 192.168.255.10
    User ubnt
    IdentityFile ~/.ssh/my_private_key
    Protocol 2
ubnt@ansible32776:~/.ssh$ ssh mybestofthebestserverlol
Welcome to Ubuntu 20.04.3 LTS (GNU/Linux 5.4.0-91-generic x86_64)

 * Documentation:  https://help.ubuntu.com
 * Management:     https://landscape.canonical.com
 * Support:        https://ubuntu.com/advantage

  System information as of Thu 09 Dec 2021 05:02:45 AM UTC

  System load:  0.49              Processes:             113
  Usage of /:   55.0% of 8.79GB   Users logged in:       1
  Memory usage: 44%               IPv4 address for ens3: 192.168.255.10
  Swap usage:   0%

 * Super-optimized for small spaces - read how we shrank the memory
   footprint of MicroK8s to make it the smallest full K8s around.

   https://ubuntu.com/blog/microk8s-memory-optimisation

38 updates can be applied immediately.
2 of these updates are standard security updates.
To see these additional updates run: apt list --upgradable

Failed to connect to https://changelogs.ubuntu.com/meta-release-lts. Check your Internet connection or proxy settings


Last login: Thu Dec  9 05:02:01 2021 from 192.168.255.13
ubnt@ubnt32769:~$
```
7. Соберите дамп трафика утилитой tcpdump в формате pcap, 100 пакетов. Откройте файл pcap в Wireshark.  
Ответ:  
```bash
ubnt@ansible32776:~/.ssh$ sudo tcpdump -c 100 -w ~/123.pcap -i ens3
tcpdump: listening on ens3, link-type EN10MB (Ethernet), capture size 262144 bytes
100 packets captured
106 packets received by filter
0 packets dropped by kernel
```
![wsh-open-pcap](https://github.com/gnoy4eg/netology.devops.pub/blob/main/img/wsh-open-pcap.png)   

 ---
## Задание для самостоятельной отработки (необязательно к выполнению)

8*. Просканируйте хост scanme.nmap.org. Какие сервисы запущены?  
Ответ:  ssh, http, nping-echo, Elite
```bash
gnoy@LAPTOP-CHVMGVOQ:~$ nmap scanme.nmap.org
Starting Nmap 7.80 ( https://nmap.org ) at 2021-12-09 10:20 +05
Nmap scan report for scanme.nmap.org (45.33.32.156)
Host is up (0.21s latency).
Other addresses for scanme.nmap.org (not scanned): 2600:3c01::f03c:91ff:fe18:bb2f
Not shown: 996 closed ports
PORT      STATE SERVICE
22/tcp    open  ssh
80/tcp    open  http
9929/tcp  open  nping-echo
31337/tcp open  Elite

Nmap done: 1 IP address (1 host up) scanned in 20.85 seconds
```
9*. Установите и настройте фаервол ufw на web-сервер из задания 3. Откройте доступ снаружи только к портам 22,80,443  
Ответ:  
```bash
ubnt@ubnt32769:~$ sudo ufw status
[sudo] password for ubnt:
Status: inactive
ubnt@ubnt32769:~$ sudo ufw default deny incoming
Default incoming policy changed to 'deny'
(be sure to update your rules accordingly)
ubnt@ubnt32769:~$ sudo ufw default allow outgoing
Default outgoing policy changed to 'allow'
(be sure to update your rules accordingly)
ubnt@ubnt32769:~$ sudo ufw allow 22/tcp
Rules updated
Rules updated (v6)
ubnt@ubnt32769:~$ sudo ufw allow 80/tcp
Rules updated
Rules updated (v6)
ubnt@ubnt32769:~$ sudo ufw allow 443/tcp
Rules updated
Rules updated (v6)
ubnt@ubnt32769:~$ sudo ufw enable
Command may disrupt existing ssh connections. Proceed with operation (y|n)? y
Firewall is active and enabled on system startup
ubnt@ubnt32769:~$ sudo ufw status
Status: active

To                         Action      From
--                         ------      ----
22/tcp                     ALLOW       Anywhere
80/tcp                     ALLOW       Anywhere
443/tcp                    ALLOW       Anywhere
22/tcp (v6)                ALLOW       Anywhere (v6)
80/tcp (v6)                ALLOW       Anywhere (v6)
443/tcp (v6)               ALLOW       Anywhere (v6)
```
