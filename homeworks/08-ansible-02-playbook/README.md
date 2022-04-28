# Домашнее задание к занятию "08.02 Работа с Playbook"

## Подготовка к выполнению

1. Создайте свой собственный (или используйте старый) публичный репозиторий на github с произвольным именем.  
===  
Ответ:  
[Ссылка](https://github.com/gnoy4eg/08-ansible-02-playbook) на новый репозиторий
2. Скачайте [playbook](./playbook/) из репозитория с домашним заданием и перенесите его в свой репозиторий.  
===  
Ответ:  
playbook [перенес](https://github.com/gnoy4eg/08-ansible-02-playbook/tree/main/src/playbook)
3. Подготовьте хосты в соответствии с группами из предподготовленного playbook.  
===  
Ответ:  
Буду использовать отдельно поднятую ВМ в локальной сети
```bash
[gnoy@manjarokde-ws01 ansible]$ ansible all -m ping -i inventory/prod.yml 
vector-01 | SUCCESS => {
    "ansible_facts": {
        "discovered_interpreter_python": "/usr/bin/python"
    },
    "changed": false,
    "ping": "pong"
}
clickhouse-01 | SUCCESS => {
    "ansible_facts": {
        "discovered_interpreter_python": "/usr/bin/python"
    },
    "changed": false,
    "ping": "pong"
}
```


## Основная часть

1. Приготовьте свой собственный inventory файл `prod.yml`.  
===  
Ответ:  
inventory [файл](https://github.com/gnoy4eg/08-ansible-02-playbook/blob/main/src/playbook/inventory/prod.yml) подготовил
2. Допишите playbook: нужно сделать ещё один play, который устанавливает и настраивает [vector](https://vector.dev).  
===  
Ответ:  
playbook дописал, но пришлось его немного поправить. Из "коробки" он не работал. Проблема заключалась в том, что база clickhouse пыталась создасться, но служба еще была не запущена (handler не отработал)
Моя часть конфига:
```yml
- name: Install vector
  hosts: vector
  handlers:
    - name: Start vector service
      become: true
      ansible.builtin.service:
        name: vector
        state: restarted
  tasks:
    - name: Get vector distrib
      ansible.builtin.get_url:
        url: https://packages.timber.io/vector/{{ vector_version }}/vector-{{ vector_version }}-1.x86_64.rpm
        dest: ./vector-{{ vector_version }}-1.x86_64.rpm
    - name: Install vector packages
      become: true
      ansible.builtin.yum: 
        name: vector-{{ vector_version }}-1.x86_64.rpm
      notify: Start vector service
```
3. При создании tasks рекомендую использовать модули: `get_url`, `template`, `unarchive`, `file`.  
===  
Ответ:  
Использовал только `get_url` т.к. шаблон не создавал и ставил с .rpm пакета, а не .tar.gz
4. Tasks должны: скачать нужной версии дистрибутив, выполнить распаковку в выбранную директорию, установить vector.  
===  
Ответ:  

5. Запустите `ansible-lint site.yml` и исправьте ошибки, если они есть.  
===  
Ответ:  
Ошибки были:
```bash
[gnoy@manjarokde-ws01 ansible]$ ansible-lint site.yml
WARNING  Overriding detected file kind 'yaml' with 'playbook' for given positional argument: site.yml
WARNING  Listing 4 violation(s) that are fatal
risky-file-permissions: File permissions unset or incorrect.
site.yml:12 Task/Handler: Get clickhouse distrib

risky-file-permissions: File permissions unset or incorrect.
site.yml:18 Task/Handler: Get clickhouse distrib

risky-file-permissions: File permissions unset or incorrect.
site.yml:39 Task/Handler: Get vector distrib

yaml: trailing spaces (trailing-spaces)
site.yml:45

You can skip specific rules or tags by adding them to your configuration file:
# .config/ansible-lint.yml
warn_list:  # or 'skip_list' to silence them completely
  - experimental  # all rules tagged as experimental
  - yaml  # Violations reported by yamllint.

Finished with 1 failure(s), 3 warning(s) on 1 files.
```
Исправил:
```bash
[gnoy@manjarokde-ws01 ansible]$ ansible-lint site.yml
WARNING  Overriding detected file kind 'yaml' with 'playbook' for given positional argument: site.yaml
[gnoy@manjarokde-ws01 ansible]$
```
6. Попробуйте запустить playbook на этом окружении с флагом `--check`.  
===  
Ответ:  
```bash
[gnoy@manjarokde-ws01 ansible]$ ansible-playbook -i inventory/prod.yml site.yml --check

PLAY [Install Clickhouse] *********************************************************************************************************

TASK [Gathering Facts] ************************************************************************************************************
ok: [clickhouse-01]

TASK [Get clickhouse distrib] *****************************************************************************************************
changed: [clickhouse-01] => (item=clickhouse-client)
changed: [clickhouse-01] => (item=clickhouse-server)
failed: [clickhouse-01] (item=clickhouse-common-static) => {"ansible_loop_var": "item", "changed": false, "dest": "./clickhouse-common-static-22.3.3.44.rpm", "elapsed": 0, "item": "clickhouse-common-static", "msg": "Request failed", "response": "HTTP Error 404: Not Found", "status_code": 404, "url": "https://packages.clickhouse.com/rpm/stable/clickhouse-common-static-22.3.3.44.noarch.rpm"}

TASK [Get clickhouse distrib] *****************************************************************************************************
changed: [clickhouse-01]

TASK [Install clickhouse packages] ************************************************************************************************
fatal: [clickhouse-01]: FAILED! => {"changed": false, "msg": "No RPM file matching 'clickhouse-common-static-22.3.3.44.rpm' found on system", "rc": 127, "results": ["No RPM file matching 'clickhouse-common-static-22.3.3.44.rpm' found on system"]}

PLAY RECAP ************************************************************************************************************************
clickhouse-01              : ok=2    changed=1    unreachable=0    failed=1    skipped=0    rescued=1    ignored=0   
```
7. Запустите playbook на `prod.yml` окружении с флагом `--diff`. Убедитесь, что изменения на системе произведены.  
===  
Ответ:  
```bash
[gnoy@manjarokde-ws01 ansible]$ ansible-playbook -i inventory/prod.yml site.yml --diff
PLAY [Install Clickhouse] *****************************************************************************************************************************************************************************

TASK [Gathering Facts] ********************************************************************************************************************************************************************************
ok: [clickhouse-01]

TASK [Get clickhouse distrib] *************************************************************************************************************************************************************************
changed: [clickhouse-01] => (item=clickhouse-client)
changed: [clickhouse-01] => (item=clickhouse-server)
failed: [clickhouse-01] (item=clickhouse-common-static) => {"ansible_loop_var": "item", "changed": false, "dest": "./clickhouse-common-static-22.3.3.44.rpm", "elapsed": 0, "item": "clickhouse-common-static", "msg": "Request failed", "response": "HTTP Error 404: Not Found", "status_code": 404, "url": "https://packages.clickhouse.com/rpm/stable/clickhouse-common-static-22.3.3.44.noarch.rpm"}

TASK [Get clickhouse distrib] *************************************************************************************************************************************************************************
changed: [clickhouse-01]

TASK [Install clickhouse packages] ********************************************************************************************************************************************************************
changed: [clickhouse-01]

RUNNING HANDLER [Start clickhouse service] ************************************************************************************************************************************************************
changed: [clickhouse-01]

PLAY [Install vector] *********************************************************************************************************************************************************************************

TASK [Gathering Facts] ********************************************************************************************************************************************************************************
ok: [vector-01]

TASK [Get vector distrib] *****************************************************************************************************************************************************************************
changed: [vector-01]

TASK [Install vector packages] ************************************************************************************************************************************************************************
changed: [vector-01]

RUNNING HANDLER [Start vector service] ****************************************************************************************************************************************************************
changed: [vector-01]

PLAY [Setup clickhouse] *******************************************************************************************************************************************************************************

TASK [Gathering Facts] ********************************************************************************************************************************************************************************
ok: [clickhouse-01]

TASK [Create database] ********************************************************************************************************************************************************************************
changed: [clickhouse-01]

PLAY RECAP ********************************************************************************************************************************************************************************************
clickhouse-01              : ok=6    changed=4    unreachable=0    failed=0    skipped=0    rescued=1    ignored=0   
vector-01                  : ok=4    changed=3    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   
```
8. Повторно запустите playbook с флагом `--diff` и убедитесь, что playbook идемпотентен.  
===  
Ответ:  
```bash
[gnoy@manjarokde-ws01 ansible]$ ansible-playbook -i inventory/prod.yml site.yml --diff
PLAY [Install Clickhouse] *****************************************************************************************************************************************************************************

TASK [Gathering Facts] ********************************************************************************************************************************************************************************
ok: [clickhouse-01]

TASK [Get clickhouse distrib] *************************************************************************************************************************************************************************
ok: [clickhouse-01] => (item=clickhouse-client)
ok: [clickhouse-01] => (item=clickhouse-server)
failed: [clickhouse-01] (item=clickhouse-common-static) => {"ansible_loop_var": "item", "changed": false, "dest": "./clickhouse-common-static-22.3.3.44.rpm", "elapsed": 0, "gid": 0, "group": "root", "item": "clickhouse-common-static", "mode": "0755", "msg": "Request failed", "owner": "root", "response": "HTTP Error 404: Not Found", "secontext": "unconfined_u:object_r:admin_home_t:s0", "size": 246310036, "state": "file", "status_code": 404, "uid": 0, "url": "https://packages.clickhouse.com/rpm/stable/clickhouse-common-static-22.3.3.44.noarch.rpm"}

TASK [Get clickhouse distrib] *************************************************************************************************************************************************************************
ok: [clickhouse-01]

TASK [Install clickhouse packages] ********************************************************************************************************************************************************************
ok: [clickhouse-01]

PLAY [Install vector] *********************************************************************************************************************************************************************************

TASK [Gathering Facts] ********************************************************************************************************************************************************************************
ok: [vector-01]

TASK [Get vector distrib] *****************************************************************************************************************************************************************************
ok: [vector-01]

TASK [Install vector packages] ************************************************************************************************************************************************************************
ok: [vector-01]

PLAY [Setup clickhouse] *******************************************************************************************************************************************************************************

TASK [Gathering Facts] ********************************************************************************************************************************************************************************
ok: [clickhouse-01]

TASK [Create database] ********************************************************************************************************************************************************************************
ok: [clickhouse-01]

PLAY RECAP ********************************************************************************************************************************************************************************************
clickhouse-01              : ok=5    changed=0    unreachable=0    failed=0    skipped=0    rescued=1    ignored=0   
vector-01                  : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   
```
9. Подготовьте README.md файл по своему playbook. В нём должно быть описано: что делает playbook, какие у него есть параметры и теги.  
===  
Ответ:  
Файл [README.md](https://github.com/gnoy4eg/08-ansible-02-playbook/blob/main/README.md) подготовил

10. Готовый playbook выложите в свой репозиторий, поставьте тег `08-ansible-02-playbook` на фиксирующий коммит, в ответ предоставьте ссылку на него.  
===  
Ответ:  
playbook подготовлен, тег добавлен.   
[Ссылка](https://github.com/gnoy4eg/08-ansible-02-playbook) на репозиторий. 
