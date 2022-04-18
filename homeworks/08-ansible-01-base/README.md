# Домашнее задание к занятию "08.01 Введение в Ansible"

## Подготовка к выполнению
1. Установите ansible версии 2.10 или выше.  
===  
Ответ:   
```bash
[gnoy@manjarokde-ws01 08-ansible-01-base]$ ansible --version
ansible [core 2.12.3]
  config file = /etc/ansible/ansible.cfg
  configured module search path = ['/home/gnoy/.ansible/plugins/modules', '/usr/share/ansible/plugins/modules']
  ansible python module location = /usr/lib/python3.10/site-packages/ansible
  ansible collection location = /home/gnoy/.ansible/collections:/usr/share/ansible/collections
  executable location = /usr/bin/ansible
  python version = 3.10.2 (main, Jan 15 2022, 19:56:27) [GCC 11.1.0]
  jinja version = 3.0.3
  libyaml = True
```
2. Создайте свой собственный публичный репозиторий на github с произвольным именем.   
===  
Ответ:   
[08-ansible-01-base](https://github.com/gnoy4eg/08-ansible-01-base)

3. Скачайте [playbook](./playbook/) из репозитория с домашним заданием и перенесите его в свой репозиторий.   
===  
Ответ:   
Playbook [перенес](https://github.com/gnoy4eg/08-ansible-01-base/tree/main/src/playbook)


## Основная часть
1. Попробуйте запустить playbook на окружении из `test.yml`, зафиксируйте какое значение имеет факт `some_fact` для указанного хоста при выполнении playbook'a.  
===  
Ответ:  
```bash
[gnoy@manjarokde-ws01 playbook]$ ansible-playbook -i ./inventory/test.yml site.yml 

PLAY [Print os facts] ************************************************************************************************************************************

TASK [Gathering Facts] ***********************************************************************************************************************************
[WARNING]: Platform linux on host localhost is using the discovered Python interpreter at /usr/bin/python3.10, but future installation of another Python
interpreter could change the meaning of that path. See https://docs.ansible.com/ansible-core/2.12/reference_appendices/interpreter_discovery.html for
more information.
ok: [localhost]

TASK [Print OS] ******************************************************************************************************************************************
ok: [localhost] => {
    "msg": "Archlinux"
}

TASK [Print fact] ****************************************************************************************************************************************
ok: [localhost] => {
    "msg": 12
}

PLAY RECAP ***********************************************************************************************************************************************
localhost                  : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   

```
2. Найдите файл с переменными (group_vars) в котором задаётся найденное в первом пункте значение и поменяйте его на 'all default fact'.  
===  
Ответ:  
```bash
[gnoy@manjarokde-ws01 playbook]$ cat group_vars/all/examp.yml 
---
  some_fact: 'all default fact'
```
```bash
[gnoy@manjarokde-ws01 playbook]$ ansible-playbook -i ./inventory/test.yml site.yml 

PLAY [Print os facts] ************************************************************************************************************************************

TASK [Gathering Facts] ***********************************************************************************************************************************
[WARNING]: Platform linux on host localhost is using the discovered Python interpreter at /usr/bin/python3.10, but future installation of another Python
interpreter could change the meaning of that path. See https://docs.ansible.com/ansible-core/2.12/reference_appendices/interpreter_discovery.html for
more information.
ok: [localhost]

TASK [Print OS] ******************************************************************************************************************************************
ok: [localhost] => {
    "msg": "Archlinux"
}

TASK [Print fact] ****************************************************************************************************************************************
ok: [localhost] => {
    "msg": "all default fact"
}

PLAY RECAP ***********************************************************************************************************************************************
localhost                  : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   
```
3. Воспользуйтесь подготовленным (используется `docker`) или создайте собственное окружение для проведения дальнейших испытаний.  
===  
Ответ:  
```bash
[gnoy@manjarokde-ws01 playbook]$ docker ps
CONTAINER ID   IMAGE            COMMAND                  CREATED          STATUS          PORTS                                       NAMES
eb0699b2d846   ubuntu:latest    "sleep 6000000000000"    3 seconds ago    Up 2 seconds                                                ubuntu
646132c6cf77   centos:centos7   "sleep 6000000000000"    45 seconds ago   Up 45 seconds                                               centos7
a4f188de2dde   postgres:13      "docker-entrypoint.s…"   2 weeks ago      Up 37 minutes   0.0.0.0:5432->5432/tcp, :::5432->5432/tcp   postgres-13
```
4. Проведите запуск playbook на окружении из `prod.yml`. Зафиксируйте полученные значения `some_fact` для каждого из `managed host`.  
===  
Ответ:  
```bash
[gnoy@manjarokde-ws01 playbook]$ ansible-playbook -i ./inventory/prod.yml site.yml 

PLAY [Print os facts] ************************************************************************************************************************************

TASK [Gathering Facts] ***********************************************************************************************************************************
ok: [ubuntu]
[WARNING]: Timeout exceeded when getting mount info for /etc/hosts
[WARNING]: Timeout exceeded when getting mount info for /etc/hostname
[WARNING]: Timeout exceeded when getting mount info for /etc/resolv.conf
ok: [centos7]

TASK [Print OS] ******************************************************************************************************************************************
ok: [ubuntu] => {
    "msg": "Ubuntu"
}
ok: [centos7] => {
    "msg": "CentOS"
}

TASK [Print fact] ****************************************************************************************************************************************
ok: [centos7] => {
    "msg": "el"
}
ok: [ubuntu] => {
    "msg": "deb"
}

PLAY RECAP ***********************************************************************************************************************************************
centos7                    : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   
ubuntu                     : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   
```
5. Добавьте факты в `group_vars` каждой из групп хостов так, чтобы для `some_fact` получились следующие значения: для `deb` - 'deb default fact', для `el` - 'el default fact'.  
===  
Ответ:  
```bash
[gnoy@manjarokde-ws01 playbook]$ cat group_vars/deb/examp.yml 
---
  some_fact: "deb default fact" 
[gnoy@manjarokde-ws01 playbook]$ cat group_vars/el/examp.yml 
---
  some_fact: "el default fact"
```
6.  Повторите запуск playbook на окружении `prod.yml`. Убедитесь, что выдаются корректные значения для всех хостов.  
===  
Ответ:  
```bash
[gnoy@manjarokde-ws01 playbook]$ ansible-playbook -i ./inventory/prod.yml site.yml 

PLAY [Print os facts] ************************************************************************************************************************************

TASK [Gathering Facts] ***********************************************************************************************************************************
ok: [ubuntu]
[WARNING]: Timeout exceeded when getting mount info for /etc/hosts
[WARNING]: Timeout exceeded when getting mount info for /etc/hostname
[WARNING]: Timeout exceeded when getting mount info for /etc/resolv.conf
ok: [centos7]

TASK [Print OS] ******************************************************************************************************************************************
ok: [ubuntu] => {
    "msg": "Ubuntu"
}
ok: [centos7] => {
    "msg": "CentOS"
}

TASK [Print fact] ****************************************************************************************************************************************
ok: [ubuntu] => {
    "msg": "deb default fact"
}
ok: [centos7] => {
    "msg": "el default fact"
}

PLAY RECAP ***********************************************************************************************************************************************
centos7                    : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   
ubuntu                     : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   
```
7. При помощи `ansible-vault` зашифруйте факты в `group_vars/deb` и `group_vars/el` с паролем `netology`.  
===  
Ответ:  
```bash
gnoy@manjarokde-ws01 playbook]$ cat group_vars/el/examp.yml 
$ANSIBLE_VAULT;1.1;AES256
33333363316131326236373464356435636531343961616231343630626464626562666262373830
6463333130396537646133383463393633396464663530660a316363313839383835616630636339
36626562323032373938623431356435326264653231656237646338353930663832376534623663
6539663733356164380a313335353130643765643038613838366533343832393737613231663664
31396233623733653530343735336563346537663337353039663732386431353935353436336635
3165323231383662336164616431396462306539323732653530
[gnoy@manjarokde-ws01 playbook]$ cat group_vars/deb/examp.yml 
$ANSIBLE_VAULT;1.1;AES256
35336230613230373262393638353363333533326534326134643230646536663436336231323430
6539396438326635353738646136393662323732623963390a663337393537393765383639633631
33303938316138666137303164346231353564376537326330353132643761356437383433636636
6635623337613539390a323036363532333463643663303533353236643866633734633662363930
36376136393237353866626333323030313036313464303034653836376230616665623830306463
3436666566636639396530373733326138346463386330326366
```
8. Запустите playbook на окружении `prod.yml`. При запуске `ansible` должен запросить у вас пароль. Убедитесь в работоспособности.  
===  
Ответ:  
```bash
[gnoy@manjarokde-ws01 playbook]$ ansible-playbook -i inventory/prod.yml site.yml --ask-vault-pass
Vault password: 

PLAY [Print os facts] ************************************************************************************************************************************

TASK [Gathering Facts] ***********************************************************************************************************************************
ok: [ubuntu]
[WARNING]: Timeout exceeded when getting mount info for /etc/hosts
[WARNING]: Timeout exceeded when getting mount info for /etc/hostname
[WARNING]: Timeout exceeded when getting mount info for /etc/resolv.conf
ok: [centos7]

TASK [Print OS] ******************************************************************************************************************************************
ok: [ubuntu] => {
    "msg": "Ubuntu"
}
ok: [centos7] => {
    "msg": "CentOS"
}

TASK [Print fact] ****************************************************************************************************************************************
ok: [ubuntu] => {
    "msg": "deb default fact"
}
ok: [centos7] => {
    "msg": "el default fact"
}

PLAY RECAP ***********************************************************************************************************************************************
centos7                    : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   
ubuntu                     : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   
```
9. Посмотрите при помощи `ansible-doc` список плагинов для подключения. Выберите подходящий для работы на `control node`.  
===  
Ответ:  
```bash
[gnoy@manjarokde-ws01 playbook]$ ansible-doc -t connection local
```
10. В `prod.yml` добавьте новую группу хостов с именем  `local`, в ней разместите localhost с необходимым типом подключения.  
===  
Ответ:  
```bash
[gnoy@manjarokde-ws01 08-ansible-01-base]$ cat src/playbook/inventory/prod.yml 
---
  el:
    hosts:
      centos7:
        ansible_connection: docker
  deb:
    hosts:
      ubuntu:
        ansible_connection: docker
  local:
    hosts:
      localhost:
        ansible_connection: local
```
11. Запустите playbook на окружении `prod.yml`. При запуске `ansible` должен запросить у вас пароль. Убедитесь что факты `some_fact` для каждого из хостов определены из верных `group_vars`.  
===  
Ответ:  
```bash
[gnoy@manjarokde-ws01 playbook]$ ansible-playbook -i inventory/prod.yml site.yml --ask-vault-pass
Vault password: 

PLAY [Print os facts] ************************************************************************************************************************************

TASK [Gathering Facts] ***********************************************************************************************************************************
[WARNING]: Platform linux on host localhost is using the discovered Python interpreter at /usr/bin/python3.10, but future installation of another Python
interpreter could change the meaning of that path. See https://docs.ansible.com/ansible-core/2.12/reference_appendices/interpreter_discovery.html for
more information.
ok: [localhost]
ok: [ubuntu]
[WARNING]: Timeout exceeded when getting mount info for /etc/hosts
[WARNING]: Timeout exceeded when getting mount info for /etc/hostname
[WARNING]: Timeout exceeded when getting mount info for /etc/resolv.conf
ok: [centos7]

TASK [Print OS] ******************************************************************************************************************************************
ok: [localhost] => {
    "msg": "Archlinux"
}
ok: [ubuntu] => {
    "msg": "Ubuntu"
}
ok: [centos7] => {
    "msg": "CentOS"
}

TASK [Print fact] ****************************************************************************************************************************************
ok: [localhost] => {
    "msg": "all default fact"
}
ok: [centos7] => {
    "msg": "el default fact"
}
ok: [ubuntu] => {
    "msg": "deb default fact"
}

PLAY RECAP ***********************************************************************************************************************************************
centos7                    : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   
localhost                  : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   
ubuntu                     : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   
```
12. Заполните `README.md` ответами на вопросы. Сделайте `git push` в ветку `master`. В ответе отправьте ссылку на ваш открытый репозиторий с изменённым `playbook` и заполненным `README.md`.  
===  
Ответ:  
Readme.md заполнил.  
[Ссылкау](https://github.com/gnoy4eg/08-ansible-01-base) на репозиторий добавил


## Необязательная часть

1. При помощи `ansible-vault` расшифруйте все зашифрованные файлы с переменными.  
===  
Ответ:  
```bash
[gnoy@manjarokde-ws01 playbook]$ ansible-vault decrypt group_vars/deb/examp.yml 
Vault password: 
Decryption successful
[gnoy@manjarokde-ws01 playbook]$ ansible-vault decrypt group_vars/el/examp.yml 
Vault password: 
Decryption successful
```
2. Зашифруйте отдельное значение `PaSSw0rd` для переменной `some_fact` паролем `netology`. Добавьте полученное значение в `group_vars/all/exmp.yml`.  
===  
Ответ:  
```bash
[gnoy@manjarokde-ws01 playbook]$ ansible-vault encrypt_string "PaSSw0rd" --ask-vault-pass
New Vault password: 
Confirm New Vault password: 
!vault |
          $ANSIBLE_VAULT;1.1;AES256
          32666665653938616165383937383264623166323664316432356662643866643261323763623134
          6532656130353963633266326565323065656433663633390a383437366465643764343434653631
          35383564386361633863363434653931396361633265363431383630316165653235396237643635
          3031326466383834620a346563646438373132636633303864326239613162646365376337616233
          6339
Encryption successful
```
3. Запустите `playbook`, убедитесь, что для нужных хостов применился новый `fact`.  
===  
Ответ:  
```bash
[gnoy@manjarokde-ws01 playbook]$ ansible-playbook -i inventory/prod.yml site.yml --ask-vault-pass
Vault password: 

PLAY [Print os facts] ************************************************************************************************************************************

TASK [Gathering Facts] ***********************************************************************************************************************************
[WARNING]: Platform linux on host localhost is using the discovered Python interpreter at /usr/bin/python3.10, but future installation of another Python
interpreter could change the meaning of that path. See https://docs.ansible.com/ansible-core/2.12/reference_appendices/interpreter_discovery.html for
more information.
ok: [localhost]
ok: [ubuntu]
[WARNING]: Timeout exceeded when getting mount info for /etc/hosts
[WARNING]: Timeout exceeded when getting mount info for /etc/hostname
[WARNING]: Timeout exceeded when getting mount info for /etc/resolv.conf
ok: [centos7]

TASK [Print OS] ******************************************************************************************************************************************
ok: [localhost] => {
    "msg": "Archlinux"
}
ok: [centos7] => {
    "msg": "CentOS"
}
ok: [ubuntu] => {
    "msg": "Ubuntu"
}

TASK [Print fact] ****************************************************************************************************************************************
ok: [localhost] => {
    "msg": "PaSSw0rd"
}
ok: [ubuntu] => {
    "msg": "deb default fact"
}
ok: [centos7] => {
    "msg": "el default fact"
}

PLAY RECAP ***********************************************************************************************************************************************
centos7                    : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   
localhost                  : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   
ubuntu                     : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   
```
4. Добавьте новую группу хостов `fedora`, самостоятельно придумайте для неё переменную. В качестве образа можно использовать [этот](https://hub.docker.com/r/pycontribs/fedora).  
===  
Ответ:  
```bash
[gnoy@manjarokde-ws01 playbook]$ cat inventory/prod.yml 
---
  el:
    hosts:
      centos7:
        ansible_connection: docker
  deb:
    hosts:
      ubuntu:
        ansible_connection: docker
  local:
    hosts:
      localhost:
        ansible_connection: local
  rpm:
    hosts:
      fedora:
        ansible_connection: docker
```
5. Напишите скрипт на bash: автоматизируйте поднятие необходимых контейнеров, запуск ansible-playbook и остановку контейнеров.  
===  
Ответ:  
[Bash-скрипт](./src/playbook/start.sh)
<details>
<summary>Запуск и тестирование скрипта</summary>

```bash
[gnoy@manjarokde-ws01 playbook]$ docker ps
CONTAINER ID   IMAGE            COMMAND               CREATED          STATUS          PORTS     NAMES
01869ef2b31b   centos:centos7   "sleep 60000000000"   14 minutes ago   Up 14 minutes             centos7
[gnoy@manjarokde-ws01 playbook]$ docker images
REPOSITORY   TAG       IMAGE ID       CREATED        SIZE
fedora       37        e6fd9b5dfc1b   4 weeks ago    163MB
centos       centos7   eeb6ee3f44bd   7 months ago   204MB
[gnoy@manjarokde-ws01 playbook]$ 
[gnoy@manjarokde-ws01 playbook]$ 
[gnoy@manjarokde-ws01 playbook]$ 
[gnoy@manjarokde-ws01 playbook]$ 
[gnoy@manjarokde-ws01 playbook]$ ./start.sh 
Error response from daemon: No such container: ubuntu
Error: failed to start containers: ubuntu
Unable to find image 'pycontribs/ubuntu:latest' locally
latest: Pulling from pycontribs/ubuntu
423ae2b273f4: Pull complete 
de83a2304fa1: Pull complete 
f9a83bce3af0: Pull complete 
b6b53be908de: Pull complete 
7378af08dad3: Pull complete 
Digest: sha256:dcb590e80d10d1b55bd3d00aadf32de8c413531d5cc4d72d0849d43f45cb7ec4
Status: Downloaded newer image for pycontribs/ubuntu:latest
1681b5f38677af26f967e0ea499c6fad1e06235fc55b85631979b9b1e03ff89b
centos7
docker: Error response from daemon: Conflict. The container name "/centos7" is already in use by container "01869ef2b31be7325f5b36ece49e20ed576d48d959d53b331e77d206a08298be". You have to remove (or rename) that container to be able to reuse that name.
See 'docker run --help'.
fedora
docker: Error response from daemon: Conflict. The container name "/fedora" is already in use by container "458179a769fd59cb6585c7f2bd1384632cf423c35e49642df922f03772b347bd". You have to remove (or rename) that container to be able to reuse that name.
See 'docker run --help'.

PLAY [Print os facts] *********************************************************************************************************************************************************************************

TASK [Gathering Facts] ********************************************************************************************************************************************************************************
[WARNING]: Platform linux on host localhost is using the discovered Python interpreter at /usr/bin/python3.10, but future installation of another Python interpreter could change the meaning of that
path. See https://docs.ansible.com/ansible-core/2.12/reference_appendices/interpreter_discovery.html for more information.
ok: [localhost]
ok: [fedora]
ok: [ubuntu]
[WARNING]: Timeout exceeded when getting mount info for /etc/hosts
[WARNING]: Timeout exceeded when getting mount info for /etc/hostname
[WARNING]: Timeout exceeded when getting mount info for /etc/resolv.conf
ok: [centos7]

TASK [Print OS] ***************************************************************************************************************************************************************************************
ok: [localhost] => {
    "msg": "Archlinux"
}
ok: [centos7] => {
    "msg": "CentOS"
}
ok: [ubuntu] => {
    "msg": "Ubuntu"
}
ok: [fedora] => {
    "msg": "Fedora"
}

TASK [Print fact] *************************************************************************************************************************************************************************************
ok: [localhost] => {
    "msg": "PaSSw0rd"
}
ok: [ubuntu] => {
    "msg": "deb default fact"
}
ok: [centos7] => {
    "msg": "el default fact"
}
ok: [fedora] => {
    "msg": "rpm default fact"
}

PLAY RECAP ********************************************************************************************************************************************************************************************
centos7                    : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   
fedora                     : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   
localhost                  : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   
ubuntu                     : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   

ubuntu
centos7
fedora
[gnoy@manjarokde-ws01 playbook]$ docker ps
CONTAINER ID   IMAGE     COMMAND   CREATED   STATUS    PORTS     NAMES
[gnoy@manjarokde-ws01 playbook]$ 
```
</details>

6. Все изменения должны быть зафиксированы и отправлены в вашей личный репозиторий.   
===  
Ответ:   
Все в папке `src`
