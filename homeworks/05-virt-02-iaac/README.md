
# Домашнее задание к занятию "5.2. Применение принципов IaaC в работе с виртуальными машинами"

## Задача 1

- Опишите своими словами основные преимущества применения на практике IaaC паттернов.
- Какой из принципов IaaC является основополагающим?  

Ответ:  
Вижу несколько приемуществ: скорость и уменьшение рисков. IaaC позволяет управлять виртуальными машинами на программном уровне, исключает ручную настройку уменьшая "человеческий фактор",  позволяет одномоментно развернуть большое количество одинаково настроенных систем.  
Основополагающим принципом IaaC считаю возможность не фокусироваться на рутинных делах, а сосредоточиться на чем-то более важном.

## Задача 2

- Чем Ansible выгодно отличается от других систем управление конфигурациями?
- Какой, на ваш взгляд, метод работы систем конфигурации более надёжный push или pull?  

Ответ:  
Есть два метода применения IaaC: push и pull. Разница состоит в том, кто инициирует изменение конфигурации целевого хоста. Ansible использует метод push. Этот метод не требует установки какого-либо клиента на целевых хостах, достаточно иметь связь по ssh. На мой взгляд, более надежный метод push, в этом случае нам не нужно дополнительно конфигурировать на целевом хосте вспомогательные утилиты,  для связи с центральным сервером. Но, полагаю, есть и минус - скорость настройки целевых хостов. 

## Задача 3

Установить на личный компьютер:

- VirtualBox
- Vagrant
- Ansible

*Приложить вывод команд установленных версий каждой из программ, оформленный в markdown.*  <br>  

Ответ:  
```bash
[manjarokde-ws01 ~]# vboxmanage --version
6.1.30r148432
[manjarokde-ws01 ~]# vagrant --version
Vagrant 2.2.19
[manjarokde-ws01 ~]# ansible --version
ansible [core 2.12.1]
  config file = /etc/ansible/ansible.cfg
  configured module search path = ['/root/.ansible/plugins/modules', '/usr/share/ansible/plugins/modules']
  ansible python module location = /usr/lib/python3.10/site-packages/ansible
  ansible collection location = /root/.ansible/collections:/usr/share/ansible/collections
  executable location = /usr/bin/ansible
  python version = 3.10.1 (main, Dec 18 2021, 23:53:45) [GCC 11.1.0]
  jinja version = 3.0.3
  libyaml = True
[manjarokde-ws01 ~]# 
```


## Задача 4 (*)

Воспроизвести практическую часть лекции самостоятельно.

- Создать виртуальную машину.
- Зайти внутрь ВМ, убедиться, что Docker установлен с помощью команды
```
docker ps
```  
Ответ:  
```bash
    ~/virt-homeworks/05-virt-02/src/vagrant    virt-11  vagrant ssh                                                                    ✔  20s  
Welcome to Ubuntu 20.04.3 LTS (GNU/Linux 5.4.0-91-generic x86_64)

 * Documentation:  https://help.ubuntu.com
 * Management:     https://landscape.canonical.com
 * Support:        https://ubuntu.com/advantage

  System information as of Tue 25 Jan 2022 07:38:49 AM UTC

  System load:  0.71               Users logged in:          0
  Usage of /:   13.4% of 30.88GB   IPv4 address for docker0: 172.17.0.1
  Memory usage: 24%                IPv4 address for eth0:    10.0.2.15
  Swap usage:   0%                 IPv4 address for eth1:    192.168.192.11
  Processes:    116


This system is built by the Bento project by Chef Software
More information can be found at https://github.com/chef/bento
Last login: Tue Jan 25 07:38:28 2022 from 10.0.2.2
vagrant@server1:~$ docker ps
CONTAINER ID   IMAGE     COMMAND   CREATED   STATUS    PORTS     NAMES
vagrant@server1:~$ 
```