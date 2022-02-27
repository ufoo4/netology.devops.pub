### Как сдавать задания

Вы уже изучили блок «Системы управления версиями», и начиная с этого занятия все ваши работы будут приниматься ссылками на .md-файлы, размещённые в вашем публичном репозитории.

Скопируйте в свой .md-файл содержимое этого файла; исходники можно посмотреть [здесь](https://raw.githubusercontent.com/netology-code/sysadm-homeworks/devsys10/04-script-02-py/README.md). Заполните недостающие части документа решением задач (заменяйте `???`, ОСТАЛЬНОЕ В ШАБЛОНЕ НЕ ТРОГАЙТЕ чтобы не сломать форматирование текста, подсветку синтаксиса и прочее, иначе можно отправиться на доработку) и отправляйте на проверку. Вместо логов можно вставить скриншоты по желани.

# Домашнее задание к занятию "4.2. Использование Python для решения типовых DevOps задач"

## Обязательная задача 1

Есть скрипт:
```python
#!/usr/bin/env python3
a = 1
b = '2'
c = a + b
```

### Вопросы:
| Вопрос  | Ответ |
| ------------- | ------------- |
| Какое значение будет присвоено переменной `c`?  | Никакое. Вернется ошибка. Складывать int и str нельзя.  |
| Как получить для переменной `c` значение 12?  | Сменить тип у переменной `a` на str. `a = str(a)`  |
| Как получить для переменной `c` значение 3?  | Сменить тип у переменной `b` на int. `b = int(b)`  |

## Обязательная задача 2
Мы устроились на работу в компанию, где раньше уже был DevOps Engineer. Он написал скрипт, позволяющий узнать, какие файлы модифицированы в репозитории, относительно локальных изменений. Этим скриптом недовольно начальство, потому что в его выводе есть не все изменённые файлы, а также непонятен полный путь к директории, где они находятся. Как можно доработать скрипт ниже, чтобы он исполнял требования вашего руководителя?

```python
#!/usr/bin/env python3

import os

bash_command = ["cd ~/netology/sysadm-homeworks", "git status"]
result_os = os.popen(' && '.join(bash_command)).read()
is_change = False
for result in result_os.split('\n'):
    if result.find('modified') != -1:
        prepare_result = result.replace('\tmodified:   ', '')
        print(prepare_result)
        break
```

### Ваш скрипт:
```python
#!/usr/bin/env python3

import os

bash_command = ["cd /home/gnoy/git-projects/testproject", "git status"]
result_os = os.popen(' && '.join(bash_command)).read()
print(f'Путь до локального репозитория: {bash_command[0][3::]}')
for result in result_os.split('\n'):
    if result.find('изменено') != -1:
        prepare_result = result.replace('\tизменено:   ', '')
        print(prepare_result)
```

### Вывод скрипта при запуске при тестировании:
```bash
gnoy@openSUSE-vm01:~/git-projects/netology.devops.pub/homeworks/04-script-02-py> ./task2.py 
Путь до локального репозитория: /home/gnoy/git-projects/testproject
   file1.txt
   file3.txt
   file5.txt
   test1.txt
```
Для проверки скрипта дополнительно посмотрю вывод "руками":
```bash
gnoy@openSUSE-vm01:~/git-projects/testproject> git status
На ветке main
Ваша ветка обновлена в соответствии с «origin/main».

Изменения, которые не в индексе для коммита:
  (используйте «git add <файл>…», чтобы добавить файл в индекс)
  (используйте «git restore <файл>…», чтобы отменить изменения в рабочем каталоге)
        изменено:      file1.txt
        изменено:      file3.txt
        изменено:      file5.txt
        изменено:      test1.txt

Неотслеживаемые файлы:
  (используйте «git add <файл>…», чтобы добавить в то, что будет включено в коммит)
        test_py.py

нет изменений добавленных для коммита
(используйте «git add» и/или «git commit -a»)
```
## Обязательная задача 3
1. Доработать скрипт выше так, чтобы он мог проверять не только локальный репозиторий в текущей директории, а также умел воспринимать путь к репозиторию, который мы передаём как входной параметр. Мы точно знаем, что начальство коварное и будет проверять работу этого скрипта в директориях, которые не являются локальными репозиториями.  

Ответ: Ну, если коварное начальство, то попробуем дополнительно напилить некий интерактив :) Если не передать в скрипт путь к каталогу с локальным репозиторием запустится диалог, но **есть минус** - в диалоге нужно указать абсолютный путь к репо. Так же есть проверка наличия каталога.  
### Ваш скрипт:
```python
#!/usr/bin/env python3

import os, sys

path_arg = False
try:
    sys.argv[1]
except:
    path_arg = True

if path_arg == True:
    status_request = input('Вы находитесь в локальном репозитории? (Yes/No)')
    if 'yes'.startswith(status_request.lower()):
        bash_command = [f'cd {os.getcwd()}', 'git status']
        result_os = os.popen(' && '.join(bash_command)).read()
        print(f'Путь до локального репозитория: {bash_command[0][3::]}')
        for result in result_os.split('\n'):
            if result.find('изменено') != -1:
                prepare_result = result.replace('\tизменено:   ', '')
                print(prepare_result)
        exit()        
    path_request = input('Хотите указать путь до локального репозитория? (Yes/No)')
    if 'yes'.startswith(path_request.lower()):
        path_to_repo = input('Укажите АБСОЛЮТНЫЙ путь до локального репозитория: ')
        check_dir = os.path.exists(path_to_repo)
        if check_dir == True:
            bash_command = [f'cd {path_to_repo}', 'git status']
            result_os = os.popen(' && '.join(bash_command)).read()
            print(f'Путь до локального репозитория: {bash_command[0][3::]}')
            for result in result_os.split('\n'):
                if result.find('изменено') != -1:
                    prepare_result = result.replace('\tизменено:   ', '')
                    print(prepare_result)
            exit()
        else:
            print('Вы указали несуществующий каталог! Попробуй вновь!')
            exit()
else:
    bash_command = [f'cd {sys.argv[1]}', 'git status']
    result_os = os.popen(' && '.join(bash_command)).read()
    check_dir = os.path.exists(sys.argv[1])
    if check_dir == True:
        print(f'Путь до локального репозитория: {bash_command[0][3::]}')
        for result in result_os.split('\n'):
            if result.find('изменено') != -1:
                prepare_result = result.replace('\tизменено:   ', '')
                print(prepare_result)
        exit()
    else:
        print('Вы указали несуществующий каталог! Попробуй вновь!')
        exit()
```

### Вывод скрипта при запуске при тестировании:
```bash
gnoy@openSUSE-vm01:~> ./git-projects/netology.devops.pub/homeworks/04-script-02-py/task3.py ~/git-projects/testproject
Путь до локального репозитория: /home/gnoy/git-projects/testproject
   file1.txt
   file3.txt
   file5.txt
   test1.txt
gnoy@openSUSE-vm01:~> ./git-projects/netology.devops.pub/homeworks/04-script-02-py/task3.py ~/git-projects/bpivbhqbvpqhebvpqevbp
/bin/sh: строка 1: cd: /home/gnoy/git-projects/bpivbhqbvpqhebvpqevbp: Нет такого файла или каталога
Вы указали несуществующий каталог! Попробуй вновь!
gnoy@openSUSE-vm01:~/git-projects/testproject> ./../netology.devops.pub/homeworks/04-script-02-py/task3.py 
Вы находитесь в локальном репозитории? (Yes/No)y
Путь до локального репозитория: /home/gnoy/git-projects/testproject
   file1.txt
   file3.txt
   file5.txt
   test1.txt
gnoy@openSUSE-vm01:~> ./git-projects/netology.devops.pub/homeworks/04-script-02-py/task3.py
Вы находитесь в локальном репозитории? (Yes/No)n
Хотите указать путь до локального репозитория? (Yes/No)yes
Укажите АБСОЛЮТНЫЙ путь до локального репозитория: /home/gnoy/git-projects/testproject
Путь до локального репозитория: /home/gnoy/git-projects/testproject
   file1.txt
   file3.txt
   file5.txt
   test1.txt
gnoy@openSUSE-vm01:~> ./git-projects/netology.devops.pub/homeworks/04-script-02-py/task3.py
Вы находитесь в локальном репозитории? (Yes/No)n
Хотите указать путь до локального репозитория? (Yes/No)ye
Укажите АБСОЛЮТНЫЙ путь до локального репозитория: /etc/hfbvgvcvwytcvwv                  
Вы указали несуществующий каталог! Попробуй вновь!
```

## Обязательная задача 4
1. Наша команда разрабатывает несколько веб-сервисов, доступных по http. Мы точно знаем, что на их стенде нет никакой балансировки, кластеризации, за DNS прячется конкретный IP сервера, где установлен сервис. Проблема в том, что отдел, занимающийся нашей инфраструктурой очень часто меняет нам сервера, поэтому IP меняются примерно раз в неделю, при этом сервисы сохраняют за собой DNS имена. Это бы совсем никого не беспокоило, если бы несколько раз сервера не уезжали в такой сегмент сети нашей компании, который недоступен для разработчиков. Мы хотим написать скрипт, который опрашивает веб-сервисы, получает их IP, выводит информацию в стандартный вывод в виде: <URL сервиса> - <его IP>. Также, должна быть реализована возможность проверки текущего IP сервиса c его IP из предыдущей проверки. Если проверка будет провалена - оповестить об этом в стандартный вывод сообщением: [ERROR] <URL сервиса> IP mismatch: <старый IP> <Новый IP>. Будем считать, что наша разработка реализовала сервисы: `drive.google.com`, `mail.google.com`, `google.com`.

### Ваш скрипт:
```python
import socket, time

my_service = {
    'drive.google.com': '',
    'mail.google.com': '',
    'google.com': ''
    }
while 1 == 1:
    for service, current_ip in my_service.items():
        real_ip = socket.gethostbyname(service)
        time.sleep(2)
        if real_ip != current_ip:
            my_service[service] = real_ip
            print(f'[ERROR] {service} IP mismatch: {current_ip} New IP: {real_ip}')
        else:
            print(f'{service} - {current_ip}')
```

### Вывод скрипта при запуске при тестировании:
```bash
gnoy@openSUSE-vm01:~/git-projects/netology.devops.pub/homeworks/04-script-02-py> /bin/python3 /home/gnoy/git-projects/netology.devops.pub/homeworks/04-script-02-py/task4.py
[ERROR] drive.google.com IP mismatch:  New IP: 64.233.164.194
[ERROR] mail.google.com IP mismatch:  New IP: 216.58.210.133
[ERROR] google.com IP mismatch:  New IP: 216.58.210.142
drive.google.com - 64.233.164.194
mail.google.com - 216.58.210.133
google.com - 216.58.210.142
drive.google.com - 64.233.164.194
mail.google.com - 216.58.210.133
google.com - 216.58.210.142
drive.google.com - 64.233.164.194
[ERROR] mail.google.com IP mismatch: 216.58.210.133 New IP: 216.58.209.197
google.com - 216.58.210.142
drive.google.com - 64.233.164.194
mail.google.com - 216.58.209.197
google.com - 216.58.210.142
drive.google.com - 64.233.164.194
mail.google.com - 216.58.209.197
google.com - 216.58.210.142
drive.google.com - 64.233.164.194
mail.google.com - 216.58.209.197
[ERROR] google.com IP mismatch: 216.58.210.142 New IP: 216.58.209.174
drive.google.com - 64.233.164.194
mail.google.com - 216.58.209.197
google.com - 216.58.209.174
drive.google.com - 64.233.164.194
mail.google.com - 216.58.209.197
[ERROR] google.com IP mismatch: 216.58.209.174 New IP: 216.58.210.142
drive.google.com - 64.233.164.194
[ERROR] mail.google.com IP mismatch: 216.58.209.197 New IP: 216.58.210.133
google.com - 216.58.210.142
drive.google.com - 64.233.164.194
mail.google.com - 216.58.210.133
cgoogle.com - 216.58.210.142
```