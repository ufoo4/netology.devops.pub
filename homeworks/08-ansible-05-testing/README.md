# Домашнее задание к занятию "08.05 Тестирование Roles"

## Подготовка к выполнению
1. Установите molecule: `pip3 install "molecule==3.4.0"`  
Ответ:  
```bash
[gnoy@manjarokde-ws01 ~]$ molecule --version
molecule 3.4.0 using python 3.10 
    ansible:2.13.0
    delegated:3.4.0 from molecule
    docker:1.1.0 from molecule_docker requiring collections: community.docker>=1.9.1
[gnoy@manjarokde-ws01 ~]$ ansible-lint --version
Failed to guess project directory using git: fatal: не найден git репозиторий (или один из родительских каталогов): .git
ansible-lint 5.4.0 using ansible 2.13.0
```
2. Соберите локальный образ на основе [Dockerfile](./Dockerfile)  
Ответ:  
У меня образ не собрался из представленного в ДЗ Dockerfile.  
Собрал свой образ на базе RHEL. Зарегистрировался [тут](https://developers.redhat.com/). Залогинился в докере: `docker login https://registry.redhat.io`. Собрал образ `docker build -t molecule .`

## Основная часть

Наша основная цель - настроить тестирование наших ролей. Задача: сделать сценарии тестирования для vector. Ожидаемый результат: все сценарии успешно проходят тестирование ролей.

### Molecule

1. Запустите  `molecule test -s centos7` внутри корневой директории clickhouse-role, посмотрите на вывод команды.  
Ответ:  
Под спойлером:
<details>
    <summary>Console</summary>

```bash
[gnoy@manjarokde-ws01 clickhouse]$ molecule test -s centos_7
INFO     centos_7 scenario test matrix: dependency, lint, cleanup, destroy, syntax, create, prepare, converge, idempotence,side_effect, verify, cleanup, destroy
INFO     Performing prerun...
INFO     Guessed /home/gnoy/08.ansible.netology.devops.pub as project root directory
INFO     Using /home/gnoy/.cache/ansible-lint/c6d031/roles/alexeysetevoi.clickhouse symlink to current repository in order toenable Ansible to find the role using its expected full name.
INFO     Added ANSIBLE_ROLES_PATH=~/.ansible/roles:/usr/share/ansible/roles:/etc/ansible/roles:/home/gnoy/.cache/ansible-lintc6d031/roles
INFO     Inventory /home/gnoy/08.ansible.netology.devops.pub/src/ansible/roles/clickhouse/molecule/centos_7/../resourcesinventory/hosts.yml linked to /home/gnoy/.cache/molecule/clickhouse/centos_7/inventory/hosts
INFO     Inventory /home/gnoy/08.ansible.netology.devops.pub/src/ansible/roles/clickhouse/molecule/centos_7/../resourcesinventory/group_vars/ linked to /home/gnoy/.cache/molecule/clickhouse/centos_7/inventory/group_vars
INFO     Inventory /home/gnoy/08.ansible.netology.devops.pub/src/ansible/roles/clickhouse/molecule/centos_7/../resourcesinventory/host_vars/ linked to /home/gnoy/.cache/molecule/clickhouse/centos_7/inventory/host_vars
INFO     Running centos_7 > dependency
WARNING  Skipping, missing the requirements file.
WARNING  Skipping, missing the requirements file.
INFO     Inventory /home/gnoy/08.ansible.netology.devops.pub/src/ansible/roles/clickhouse/molecule/centos_7/../resourcesinventory/hosts.yml linked to /home/gnoy/.cache/molecule/clickhouse/centos_7/inventory/hosts
INFO     Inventory /home/gnoy/08.ansible.netology.devops.pub/src/ansible/roles/clickhouse/molecule/centos_7/../resourcesinventory/group_vars/ linked to /home/gnoy/.cache/molecule/clickhouse/centos_7/inventory/group_vars
INFO     Inventory /home/gnoy/08.ansible.netology.devops.pub/src/ansible/roles/clickhouse/molecule/centos_7/../resourcesinventory/host_vars/ linked to /home/gnoy/.cache/molecule/clickhouse/centos_7/inventory/host_vars
INFO     Running centos_7 > lint
COMMAND: yamllint .
ansible-lint
flake8
WARNING  Loading custom .yamllint config file, this extends our internal yamllint config.
WARNING  Listing 1 violation(s) that are fatal
risky-file-permissions: File permissions unset or incorrect
tasks/install/apt.yml:45 Task/Handler: Hold specified version during APT upgrade | Package installation
You can skip specific rules or tags by adding them to your configuration file:
# .ansible-lint
warn_list:  # or 'skip_list' to silence them completely
  - experimental  # all rules tagged as experimental
Finished with 0 failure(s), 1 warning(s) on 58 files.
/bin/bash: строка 3: flake8: команда не найдена
CRITICAL Lint failed with error code 127
WARNING  An error occurred during the test sequence action: 'lint'. Cleaning up.
INFO     Inventory /home/gnoy/08.ansible.netology.devops.pub/src/ansible/roles/clickhouse/molecule/centos_7/../resourcesinventory/hosts.yml linked to /home/gnoy/.cache/molecule/clickhouse/centos_7/inventory/hosts
INFO     Inventory /home/gnoy/08.ansible.netology.devops.pub/src/ansible/roles/clickhouse/molecule/centos_7/../resourcesinventory/group_vars/ linked to /home/gnoy/.cache/molecule/clickhouse/centos_7/inventory/group_vars
INFO     Inventory /home/gnoy/08.ansible.netology.devops.pub/src/ansible/roles/clickhouse/molecule/centos_7/../resourcesinventory/host_vars/ linked to /home/gnoy/.cache/molecule/clickhouse/centos_7/inventory/host_vars
INFO     Running centos_7 > cleanup
WARNING  Skipping, cleanup playbook not configured.
INFO     Inventory /home/gnoy/08.ansible.netology.devops.pub/src/ansible/roles/clickhouse/molecule/centos_7/../resourcesinventory/hosts.yml linked to /home/gnoy/.cache/molecule/clickhouse/centos_7/inventory/hosts
INFO     Inventory /home/gnoy/08.ansible.netology.devops.pub/src/ansible/roles/clickhouse/molecule/centos_7/../resourcesinventory/group_vars/ linked to /home/gnoy/.cache/molecule/clickhouse/centos_7/inventory/group_vars
INFO     Inventory /home/gnoy/08.ansible.netology.devops.pub/src/ansible/roles/clickhouse/molecule/centos_7/../resourcesinventory/host_vars/ linked to /home/gnoy/.cache/molecule/clickhouse/centos_7/inventory/host_vars
INFO     Running centos_7 > destroy
INFO     Sanity checks: 'docker'
PLAY [Destroy] *****************************************************************
TASK [Destroy molecule instance(s)] ********************************************
changed: [localhost] => (item=centos_7)
TASK [Wait for instance(s) deletion to complete] *******************************
FAILED - RETRYING: [localhost]: Wait for instance(s) deletion to complete (300 retries left).
ok: [localhost] => (item=centos_7)
TASK [Delete docker networks(s)] ***********************************************
PLAY RECAP *********************************************************************
localhost                  : ok=2    changed=1    unreachable=0    failed=0    skipped=1    rescued=0    ignored=0
INFO     Pruning extra files from scenario ephemeral directory
```
</details>
<br>

2. Перейдите в каталог с ролью vector-role и создайте сценарий тестирования по умолчанию при помощи `molecule init scenario --driver-name docker`.  
Ответ:  
```bash
[gnoy@manjarokde-ws01 vector-role]$ molecule init scenario --driver-name docker
INFO     Initializing new scenario default...
INFO     Initialized scenario in /home/gnoy/vector-role/molecule/default successfully.
```

3. Добавьте несколько разных дистрибутивов (centos:8, ubuntu:latest) для инстансов и протестируйте роль, исправьте найденные ошибки, если они есть.  
Ответ:  
Добавил для centos 7 и ubuntu:latest
<details>
    <summary>Тестирование CentOS</summary>

```bash
[gnoy@manjarokde-ws01 vector-role]$ molecule test -s centos
INFO     centos scenario test matrix: dependency, lint, cleanup, destroy, syntax, create, prepare, converge, idempotence,  side_effect, verify, cleanup, destroy
INFO     Performing prerun...
INFO     Guessed /home/gnoy/vector-role as project root directory
INFO     Added ANSIBLE_ROLES_PATH=~/.ansible/roles:/usr/share/ansible/roles:/etc/ansible/roles:/home/gnoy/.cacheansible-lint/  afe2c6/roles
INFO     Running centos > dependency
WARNING  Skipping, missing the requirements file.
WARNING  Skipping, missing the requirements file.
INFO     Running centos > lint
INFO     Lint is disabled.
INFO     Running centos > cleanup
WARNING  Skipping, cleanup playbook not configured.
INFO     Running centos > destroy
INFO     Sanity checks: 'docker'
PLAY [Destroy] *****************************************************************
TASK [Destroy molecule instance(s)] ********************************************
changed: [localhost] => (item=instance)
TASK [Wait for instance(s) deletion to complete] *******************************
FAILED - RETRYING: [localhost]: Wait for instance(s) deletion to complete (300 retries left).
changed: [localhost] => (item=instance)
TASK [Delete docker networks(s)] ***********************************************
PLAY RECAP *********************************************************************
localhost                  : ok=2    changed=2    unreachable=0    failed=0    skipped=1    rescued=0    ignored=0
INFO     Running centos > syntax
playbook: /home/gnoy/vector-role/molecule/centos/converge.yml
INFO     Running centos > create
PLAY [Create] ******************************************************************
TASK [Log into a Docker registry] **********************************************
skipping: [localhost] => (item=None) 
skipping: [localhost]
TASK [Check presence of custom Dockerfiles] ************************************
ok: [localhost] => (item={'image': 'docker.io/pycontribs/centos:7', 'name': 'instance', 'pre_build_image': True})
TASK [Create Dockerfiles from image names] *************************************
skipping: [localhost] => (item={'image': 'docker.io/pycontribs/centos:7', 'name': 'instance', 'pre_build_image': True}) 
TASK [Discover local Docker images] ********************************************
ok: [localhost] => (item={'changed': False, 'skipped': True, 'skip_reason': 'Conditional result was False', 'item':{'image':   'docker.io/pycontribs/centos:7', 'name': 'instance', 'pre_build_image': True}, 'ansible_loop_var': 'item', 'i':0,    'ansible_index_var': 'i'})
TASK [Build an Ansible compatible image (new)] *********************************
skipping: [localhost] => (item=molecule_local/docker.io/pycontribs/centos:7) 
TASK [Create docker network(s)] ************************************************
TASK [Determine the CMD directives] ********************************************
ok: [localhost] => (item={'image': 'docker.io/pycontribs/centos:7', 'name': 'instance', 'pre_build_image': True})
TASK [Create molecule instance(s)] *********************************************
changed: [localhost] => (item=instance)
TASK [Wait for instance(s) creation to complete] *******************************
FAILED - RETRYING: [localhost]: Wait for instance(s) creation to complete (300 retries left).
changed: [localhost] => (item={'failed': 0, 'started': 1, 'finished': 0, 'ansible_job_id': '837946553473.2158','results_file': '/  home/gnoy/.ansible_async/837946553473.2158', 'changed': True, 'item': {'image': 'docker.io/pycontribscentos:7', 'name':  'instance', 'pre_build_image': True}, 'ansible_loop_var': 'item'})
PLAY RECAP *********************************************************************
localhost                  : ok=5    changed=2    unreachable=0    failed=0    skipped=4    rescued=0    ignored=0
INFO     Running centos > prepare
WARNING  Skipping, prepare playbook not configured.
INFO     Running centos > converge
PLAY [Converge] ****************************************************************
TASK [Gathering Facts] *********************************************************
[WARNING]: Timeout exceeded when getting mount info for /etc/hosts
[WARNING]: Timeout exceeded when getting mount info for /etc/hostname
[WARNING]: Timeout exceeded when getting mount info for /etc/resolv.conf
ok: [instance]
TASK [Include vector-role] *****************************************************
TASK [vector-role : Get Vector distrib | CentOS] *******************************
changed: [instance]
TASK [vector-role : Get Vector distrib | Ubuntu] *******************************
skipping: [instance]
TASK [vector-role : Install Vector packages | CentOS] **************************
changed: [instance]
TASK [vector-role : Install Vector packages | Ubuntu] **************************
skipping: [instance]
TASK [vector-role : Deploy config Vector] **************************************
changed: [instance]
TASK [vector-role : Creates directory] *****************************************
changed: [instance]
TASK [vector-role : Create systemd unit Vector] ********************************
changed: [instance]
TASK [vector-role : Start Vector service] **************************************
skipping: [instance]
RUNNING HANDLER [vector-role : Start Vector service] ***************************
skipping: [instance]
PLAY RECAP *********************************************************************
instance                   : ok=6    changed=5    unreachable=0    failed=0    skipped=4    rescued=0    ignored=0
INFO     Running centos > idempotence
PLAY [Converge] ****************************************************************
TASK [Gathering Facts] *********************************************************
[WARNING]: Timeout exceeded when getting mount info for /etc/hosts
[WARNING]: Timeout exceeded when getting mount info for /etc/hostname
[WARNING]: Timeout exceeded when getting mount info for /etc/resolv.conf
ok: [instance]
TASK [Include vector-role] *****************************************************
TASK [vector-role : Get Vector distrib | CentOS] *******************************
ok: [instance]
TASK [vector-role : Get Vector distrib | Ubuntu] *******************************
skipping: [instance]
TASK [vector-role : Install Vector packages | CentOS] **************************
ok: [instance]
TASK [vector-role : Install Vector packages | Ubuntu] **************************
skipping: [instance]
TASK [vector-role : Deploy config Vector] **************************************
ok: [instance]
TASK [vector-role : Creates directory] *****************************************
ok: [instance]
TASK [vector-role : Create systemd unit Vector] ********************************
ok: [instance]
TASK [vector-role : Start Vector service] **************************************
skipping: [instance]
PLAY RECAP *********************************************************************
instance                   : ok=6    changed=0    unreachable=0    failed=0    skipped=3    rescued=0    ignored=0
INFO     Idempotence completed successfully.
INFO     Running centos > side_effect
WARNING  Skipping, side effect playbook not configured.
INFO     Running centos > verify
INFO     Running Ansible Verifier
PLAY [Verify] ******************************************************************
TASK [Get Vector version] ******************************************************
ok: [instance]
TASK [Assert Vector instalation] ***********************************************
ok: [instance] => {
    "changed": false,
    "msg": "All assertions passed"
}
TASK [Validation Vector configuration] *****************************************
ok: [instance]
TASK [Assert Vector validate config] *******************************************
ok: [instance] => {
    "changed": false,
    "msg": "All assertions passed"
}
PLAY RECAP *********************************************************************
instance                   : ok=4    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
INFO     Verifier completed successfully.
INFO     Running centos > cleanup
WARNING  Skipping, cleanup playbook not configured.
INFO     Running centos > destroy
PLAY [Destroy] *****************************************************************
TASK [Destroy molecule instance(s)] ********************************************
changed: [localhost] => (item=instance)
TASK [Wait for instance(s) deletion to complete] *******************************
FAILED - RETRYING: [localhost]: Wait for instance(s) deletion to complete (300 retries left).
changed: [localhost] => (item=instance)
TASK [Delete docker networks(s)] ***********************************************
PLAY RECAP *********************************************************************
localhost                  : ok=2    changed=2    unreachable=0    failed=0    skipped=1    rescued=0    ignored=0
INFO     Pruning extra files from scenario ephemeral directory
```
</details>  
<details>
    <summary>Тестирование Ubuntu</summary>

```bash
[gnoy@manjarokde-ws01 vector-role]$ molecule test -s ubuntu
INFO     ubuntu scenario test matrix: dependency, lint, cleanup, destroy, syntax, create, prepare, converge, idempotence, side_effect, verify, cleanup, destroy
INFO     Performing prerun...
INFO     Guessed /home/gnoy/vector-role as project root directory
INFO     Added ANSIBLE_ROLES_PATH=~/.ansible/roles:/usr/share/ansible/roles:/etc/ansible/roles:/home/gnoy/.cache/ansible-lint/afe2c6/roles
INFO     Running ubuntu > dependency
WARNING  Skipping, missing the requirements file.
WARNING  Skipping, missing the requirements file.
INFO     Running ubuntu > lint
INFO     Lint is disabled.
INFO     Running ubuntu > cleanup
WARNING  Skipping, cleanup playbook not configured.
INFO     Running ubuntu > destroy
INFO     Sanity checks: 'docker'

PLAY [Destroy] *****************************************************************

TASK [Destroy molecule instance(s)] ********************************************
changed: [localhost] => (item=instance)

TASK [Wait for instance(s) deletion to complete] *******************************
FAILED - RETRYING: [localhost]: Wait for instance(s) deletion to complete (300 retries left).
ok: [localhost] => (item=instance)

TASK [Delete docker networks(s)] ***********************************************

PLAY RECAP *********************************************************************
localhost                  : ok=2    changed=1    unreachable=0    failed=0    skipped=1    rescued=0    ignored=0

INFO     Running ubuntu > syntax

playbook: /home/gnoy/vector-role/molecule/ubuntu/converge.yml
INFO     Running ubuntu > create

PLAY [Create] ******************************************************************

TASK [Log into a Docker registry] **********************************************
skipping: [localhost] => (item=None) 
skipping: [localhost]

TASK [Check presence of custom Dockerfiles] ************************************
ok: [localhost] => (item={'image': 'pycontribs/ubuntu:latest', 'name': 'instance', 'pre_build_image': True})

TASK [Create Dockerfiles from image names] *************************************
skipping: [localhost] => (item={'image': 'pycontribs/ubuntu:latest', 'name': 'instance', 'pre_build_image': True}) 

TASK [Discover local Docker images] ********************************************
ok: [localhost] => (item={'changed': False, 'skipped': True, 'skip_reason': 'Conditional result was False', 'item': {'image': 'pycontribs/ubuntu:latest', 'name': 'instance', 'pre_build_image': True}, 'ansible_loop_var': 'item', 'i': 0, 'ansible_index_var': 'i'})

TASK [Build an Ansible compatible image (new)] *********************************
skipping: [localhost] => (item=molecule_local/pycontribs/ubuntu:latest) 

TASK [Create docker network(s)] ************************************************

TASK [Determine the CMD directives] ********************************************
ok: [localhost] => (item={'image': 'pycontribs/ubuntu:latest', 'name': 'instance', 'pre_build_image': True})

TASK [Create molecule instance(s)] *********************************************
changed: [localhost] => (item=instance)

TASK [Wait for instance(s) creation to complete] *******************************
FAILED - RETRYING: [localhost]: Wait for instance(s) creation to complete (300 retries left).
changed: [localhost] => (item={'failed': 0, 'started': 1, 'finished': 0, 'ansible_job_id': '896172670746.9288', 'results_file': '/home/gnoy/.ansible_async/896172670746.9288', 'changed': True, 'item': {'image': 'pycontribs/ubuntu:latest', 'name': 'instance', 'pre_build_image': True}, 'ansible_loop_var': 'item'})

PLAY RECAP *********************************************************************
localhost                  : ok=5    changed=2    unreachable=0    failed=0    skipped=4    rescued=0    ignored=0

INFO     Running ubuntu > prepare
WARNING  Skipping, prepare playbook not configured.
INFO     Running ubuntu > converge

PLAY [Converge] ****************************************************************

TASK [Gathering Facts] *********************************************************
ok: [instance]

TASK [Include vector-role] *****************************************************

TASK [vector-role : Get Vector distrib | CentOS] *******************************
skipping: [instance]

TASK [vector-role : Get Vector distrib | Ubuntu] *******************************
changed: [instance]

TASK [vector-role : Install Vector packages | CentOS] **************************
skipping: [instance]

TASK [vector-role : Install Vector packages | Ubuntu] **************************
changed: [instance]

TASK [vector-role : Deploy config Vector] **************************************
changed: [instance]

TASK [vector-role : Creates directory] *****************************************
changed: [instance]

TASK [vector-role : Create systemd unit Vector] ********************************
changed: [instance]

TASK [vector-role : Start Vector service] **************************************
skipping: [instance]

RUNNING HANDLER [vector-role : Start Vector service] ***************************
skipping: [instance]

PLAY RECAP *********************************************************************
instance                   : ok=6    changed=5    unreachable=0    failed=0    skipped=4    rescued=0    ignored=0

INFO     Running ubuntu > idempotence

PLAY [Converge] ****************************************************************

TASK [Gathering Facts] *********************************************************
ok: [instance]

TASK [Include vector-role] *****************************************************

TASK [vector-role : Get Vector distrib | CentOS] *******************************
skipping: [instance]

TASK [vector-role : Get Vector distrib | Ubuntu] *******************************
ok: [instance]

TASK [vector-role : Install Vector packages | CentOS] **************************
skipping: [instance]

TASK [vector-role : Install Vector packages | Ubuntu] **************************
ok: [instance]

TASK [vector-role : Deploy config Vector] **************************************
ok: [instance]

TASK [vector-role : Creates directory] *****************************************
ok: [instance]

TASK [vector-role : Create systemd unit Vector] ********************************
ok: [instance]

TASK [vector-role : Start Vector service] **************************************
skipping: [instance]

PLAY RECAP *********************************************************************
instance                   : ok=6    changed=0    unreachable=0    failed=0    skipped=3    rescued=0    ignored=0

INFO     Idempotence completed successfully.
INFO     Running ubuntu > side_effect
WARNING  Skipping, side effect playbook not configured.
INFO     Running ubuntu > verify
INFO     Running Ansible Verifier

PLAY [Verify] ******************************************************************

TASK [Get Vector version] ******************************************************
ok: [instance]

TASK [Assert Vector instalation] ***********************************************
ok: [instance] => {
    "changed": false,
    "msg": "All assertions passed"
}

TASK [Validation Vector configuration] *****************************************
ok: [instance]

TASK [Assert Vector validate config] *******************************************
ok: [instance] => {
    "changed": false,
    "msg": "All assertions passed"
}

PLAY RECAP *********************************************************************
instance                   : ok=4    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0

INFO     Verifier completed successfully.
INFO     Running ubuntu > cleanup
WARNING  Skipping, cleanup playbook not configured.
INFO     Running ubuntu > destroy

PLAY [Destroy] *****************************************************************

TASK [Destroy molecule instance(s)] ********************************************
changed: [localhost] => (item=instance)

TASK [Wait for instance(s) deletion to complete] *******************************
FAILED - RETRYING: [localhost]: Wait for instance(s) deletion to complete (300 retries left).
changed: [localhost] => (item=instance)

TASK [Delete docker networks(s)] ***********************************************

PLAY RECAP *********************************************************************
localhost                  : ok=2    changed=2    unreachable=0    failed=0    skipped=1    rescued=0    ignored=0

INFO     Pruning extra files from scenario ephemeral directory
```
</details>   
<br>

4. Добавьте несколько assert'ов в verify.yml файл для  проверки работоспособности vector-role (проверка, что конфиг валидный, проверка успешности запуска, etc). Запустите тестирование роли повторно и проверьте, что оно прошло успешно.  
Ответ:  
Добавил для CentOS и Ubuntu. Тестовый "прогон" был сделан еще на шаге №3:
```yml
---
- name: Verify
  hosts: all
  gather_facts: false
  vars:
    vector_config_path: /etc/vector/vector.yaml
  tasks:
  - name: Get Vector version
    ansible.builtin.command: "vector --version"
    changed_when: false
    register: vector_version
  - name: Assert Vector instalation
    assert:
      that: "'{{ vector_version.rc }}' == '0'"
  - name: Validation Vector configuration
    ansible.builtin.command: "vector validate --no-environment --config-yaml {{ vector_config_path }}"
    changed_when: false
    register: vector_validate
  - name: Assert Vector validate config
    assert:
      that: "'{{ vector_validate.rc }}' == '0'"
```

5. Добавьте новый тег на коммит с рабочим сценарием в соответствии с семантическим версионированием.  
Ответ:  
[vector-role 1.1.0](https://github.com/gnoy4eg/vector-role/tree/1.1.0)

### Tox

1. Добавьте в директорию с vector-role файлы из [директории](./example)  
Ответ:  
Добавил
2. Запустите `docker run --privileged=True -v <path_to_repo>:/opt/vector-role -w /opt/vector-role -it <image_name> /bin/bash`, где path_to_repo - путь до корня репозитория с vector-role на вашей файловой системе.  
Ответ:  
```bash
[gnoy@manjarokde-ws01 vector-role]$ docker run --privileged=True -v /home/gnoy/vector-role:/opt/vector-role -w /opt/vector-role -it molecule /bin/bash
[root@fef44af90764 vector-role]# 
```
3. Внутри контейнера выполните команду `tox`, посмотрите на вывод.  
Ответ: 

```bash
__________________________________ summary __________________________________
py37-ansible210: commands succeeded
py37-ansible30: commands succeeded
py39-ansible210: commands succeeded
py39-ansible30: commands succeeded
congratulations :)
```

5. Создайте облегчённый сценарий для `molecule`. Проверьте его на исполнимость.  
Ответ:  
Создал облегчённый сценарий для centos_mini. Добавил в конфи-файл:
```yml
scenario:
  test_sequence:
    - destroy
    - create
    - converge
    - idempotence
    - verify
    - destroy
```
6. Пропишите правильную команду в `tox.ini` для того чтобы запускался облегчённый сценарий.  
Ответ:  
```yml
commands =
    {posargs:molecule test -s centos_mini --destroy always}
```

8. Запустите команду `tox`. Убедитесь, что всё отработало успешно.  
Ответ:  
```bash
__________________________________ summary __________________________________
py37-ansible210: commands succeeded
py37-ansible30: commands succeeded
py39-ansible210: commands succeeded
py39-ansible30: commands succeeded
congratulations :)
```

9. Добавьте новый тег на коммит с рабочим сценарием в соответствии с семантическим версионированием.  
Ответ:  
[vector-role 1.2.0](https://github.com/gnoy4eg/vector-role/tree/1.2.0)


После выполнения у вас должно получится два сценария molecule и один tox.ini файл в репозитории. Ссылка на репозиторий являются ответами на домашнее задание. Не забудьте указать в ответе теги решений Tox и Molecule заданий.

## Необязательная часть

1. Проделайте схожие манипуляции для создания роли lighthouse.
2. Создайте сценарий внутри любой из своих ролей, который умеет поднимать весь стек при помощи всех ролей.
3. Убедитесь в работоспособности своего стека. Создайте отдельный verify.yml, который будет проверять работоспособность интеграции всех инструментов между ними.
4. Выложите свои roles в репозитории. В ответ приведите ссылки.  
Ответ:  
Пока не брался.

