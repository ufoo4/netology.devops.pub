# Домашнее задание к занятию "08.03 Использование Yandex Cloud"

## Подготовка к выполнению

1. Подготовьте в Yandex Cloud три хоста: для `clickhouse`, для `vector` и для `lighthouse`.  
Ответ:  
У меня ВМ создаются автоматически в YC средствами terraform

## Основная часть

1. Допишите playbook: нужно сделать ещё один play, который устанавливает и настраивает lighthouse.  
Ответ:  
```yml
...
- name: Install lighthouse
  hosts: lighthouse
  become: true
  become_user: root
  remote_user: centos
  handlers:
    - name: Apache systemd started
      systemd:
        name: httpd
        enabled: yes
        state: started
  tasks:
    - name: Install git
      yum:
        name: git
        state: present
    - name: Install apache
      yum:
        name: httpd
        state: present
      notify: Apache systemd started
    - name: Clone repo lighthouse
      git:
        repo: https://github.com/VKCOM/lighthouse.git
        dest: /var/www/html
...
```
2. При создании tasks рекомендую использовать модули: `get_url`, `template`, `yum`, `apt`.  
Ответ:  
Использовал `yum`, `git`, `systemd`
3. Tasks должны: скачать статику lighthouse, установить nginx или любой другой webserver, настроить его конфиг для открытия lighthouse, запустить webserver.  
Ответ:  
Так и есть: tasks скачивают, устанавливают и запускают
4. Приготовьте свой собственный inventory файл `prod.yml`.  
Ответ:  
Статичный инвентори у меня подготавливается средствами terraform. После запуска terraform файл будет называться `inventory`
5. Запустите `ansible-lint site.yml` и исправьте ошибки, если они есть.  
Ответ:  
Линтер нашел следующие ошибки:
```bash
[gnoy@manjarokde-ws01 ansible]$ ansible-lint site.yml
WARNING  Overriding detected file kind 'yaml' with 'playbook' for given positional argument: site.yml
WARNING  Listing 8 violation(s) that are fatal
fqcn-builtins: Use FQCN for builtin actions.
site.yml:50 Task/Handler: Install vector packages

partial-become: become_user requires become to work as expected.
site.yml:55

fqcn-builtins: Use FQCN for builtin actions.
site.yml:71 Task/Handler: Apache systemd started

yaml: truthy value should be one of [false, true] (truthy)
site.yml:74

fqcn-builtins: Use FQCN for builtin actions.
site.yml:77 Task/Handler: Install git

fqcn-builtins: Use FQCN for builtin actions.
site.yml:81 Task/Handler: Install apache

fqcn-builtins: Use FQCN for builtin actions.
site.yml:86 Task/Handler: Clone repo lighthouse

git-latest: Git checkouts must contain explicit version.
site.yml:86 Task/Handler: Clone repo lighthouse

You can skip specific rules or tags by adding them to your configuration file:
# .config/ansible-lint.yml
warn_list:  # or 'skip_list' to silence them completely
  - fqcn-builtins  # Use FQCN for builtin actions.
  - git-latest  # Git checkouts must contain explicit version.
  - partial-become  # become_user requires become to work as expected.
  - yaml  # Violations reported by yamllint.

Finished with 8 failure(s), 0 warning(s) on 1 files.
```
Все недочеты исправил:
```bash
[gnoy@manjarokde-ws01 ansible]$ ansible-lint site.yml
WARNING  Overriding detected file kind 'yaml' with 'playbook' for given positional argument: site.yml
[gnoy@manjarokde-ws01 ansible]$ 
```
6. Попробуйте запустить playbook на этом окружении с флагом `--check`.  
Ответ:  
```bash
...
LAY RECAP *******************************************************************************************************************
node01.netology.cloud      : ok=4    changed=0    unreachable=0    failed=0    skipped=1    rescued=1    ignored=0   
node02.netology.cloud      : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   
node03.netology.cloud      : ok=4    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   
```
7. Запустите playbook на `prod.yml` окружении с флагом `--diff`. Убедитесь, что изменения на системе произведены.  
Ответ:  
```bash
PLAY RECAP *******************************************************************************************************************
node01.netology.cloud      : ok=6    changed=4    unreachable=0    failed=0    skipped=0    rescued=1    ignored=0
node02.netology.cloud      : ok=4    changed=3    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
node03.netology.cloud      : ok=5    changed=4    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
```
8. Повторно запустите playbook с флагом `--diff` и убедитесь, что playbook идемпотентен.  
Ответ:  
```bash
PLAY RECAP *******************************************************************************************************************
node01.netology.cloud      : ok=5    changed=0    unreachable=0    failed=0    skipped=0    rescued=1    ignored=0   
node02.netology.cloud      : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   
node03.netology.cloud      : ok=4    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
```
9. Подготовьте README.md файл по своему playbook. В нём должно быть описано: что делает playbook, какие у него есть параметры и теги.  
Ответ:  
[README.md](https://github.com/gnoy4eg/08.ansible.netology.devops.pub/blob/08-ansible-03-yandex/README.md)
10. Готовый playbook выложите в свой репозиторий, поставьте тег `08-ansible-03-yandex` на фиксирующий коммит, в ответ предоставьте ссылку на него.  
Ответ:  
[08-ansible-03-yandex](https://github.com/gnoy4eg/08.ansible.netology.devops.pub/tree/08-ansible-03-yandex)
