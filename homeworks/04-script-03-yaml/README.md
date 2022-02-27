### Как сдавать задания

Вы уже изучили блок «Системы управления версиями», и начиная с этого занятия все ваши работы будут приниматься ссылками на .md-файлы, размещённые в вашем публичном репозитории.

Скопируйте в свой .md-файл содержимое этого файла; исходники можно посмотреть [здесь](https://raw.githubusercontent.com/netology-code/sysadm-homeworks/devsys10/04-script-03-yaml/README.md). Заполните недостающие части документа решением задач (заменяйте `???`, ОСТАЛЬНОЕ В ШАБЛОНЕ НЕ ТРОГАЙТЕ чтобы не сломать форматирование текста, подсветку синтаксиса и прочее, иначе можно отправиться на доработку) и отправляйте на проверку. Вместо логов можно вставить скриншоты по желани.

# Домашнее задание к занятию "4.3. Языки разметки JSON и YAML"


## Обязательная задача 1
Мы выгрузили JSON, который получили через API запрос к нашему сервису:
```
    { "info" : "Sample JSON output from our service\t",
        "elements" :[
            { "name" : "first",
            "type" : "server",
            "ip" : 7175 
            }
            { "name" : "second",
            "type" : "proxy",
            "ip : 71.78.22.43
            }
        ]
    }
```
  Нужно найти и исправить все ошибки, которые допускает наш сервис  
Ответ:
```json
{ "info" : "Sample JSON output from our service\t",
    "elements" :[
        { "name" : "first",
        "type" : "server",
        "ip" : 7175 
        },
        { "name" : "second",
        "type" : "proxy",
        "ip" : "71.78.22.43"
        }
    ]
}
```

## Обязательная задача 2
В прошлый рабочий день мы создавали скрипт, позволяющий опрашивать веб-сервисы и получать их IP. К уже реализованному функционалу нам нужно добавить возможность записи JSON и YAML файлов, описывающих наши сервисы. Формат записи JSON по одному сервису: `{ "имя сервиса" : "его IP"}`. Формат записи YAML по одному сервису: `- имя сервиса: его IP`. Если в момент исполнения скрипта меняется IP у сервиса - он должен так же поменяться в yml и json файле.

### Ваш скрипт:  
Исправил замечание из прошлого ДЗ. Изменил `while 1 == 1:` на `while == True:`
```python
#!/usr/bin/env python3

import socket, time, json, yaml

my_service = {
    'drive.google.com': '',
    'mail.google.com': '',
    'google.com': ''
    }
while True:
    for service, current_ip in my_service.items():
        real_ip = socket.gethostbyname(service)
        time.sleep(2)
        if real_ip != current_ip:
            my_service[service] = real_ip
            print(f'[ERROR] {service} IP mismatch: {current_ip} New IP: {real_ip}')
            with open('ip_json.json', 'w') as outfile_json:
                json.dump(my_service, outfile_json, indent=2)
            with open('ip_yaml.yaml', 'w') as outfile_yaml:
                yaml.dump(my_service, outfile_yaml, explicit_start=True, explicit_end=True)
        else:
            print(f'{service} - {current_ip}')
```

### Вывод скрипта при запуске при тестировании:
```bash
gnoy@openSUSE-vm01:~/git-projects/netology.devops.pub/homeworks/04-script-03-yaml> /bin/python3 /home/gnoy/git-projects/netology.devops.pub/homeworks/04-script-03-yaml/task2.py
[ERROR] drive.google.com IP mismatch:  New IP: 173.194.73.194
[ERROR] mail.google.com IP mismatch:  New IP: 108.177.14.17
[ERROR] google.com IP mismatch:  New IP: 74.125.131.113
drive.google.com - 173.194.73.194
[ERROR] mail.google.com IP mismatch: 108.177.14.17 New IP: 108.177.14.19
[ERROR] google.com IP mismatch: 74.125.131.113 New IP: 74.125.131.138
drive.google.com - 173.194.73.194
[ERROR] mail.google.com IP mismatch: 108.177.14.19 New IP: 108.177.14.18
[ERROR] google.com IP mismatch: 74.125.131.138 New IP: 74.125.131.139
drive.google.com - 173.194.73.194
^CTraceback (most recent call last):
  File "/home/gnoy/git-projects/netology.devops.pub/homeworks/04-script-03-yaml/task2.py", line 13, in <module>
    time.sleep(2)
KeyboardInterrupt
```

### json-файл(ы), который(е) записал ваш скрипт:
```json
{
  "drive.google.com": "173.194.73.194",
  "mail.google.com": "108.177.14.18",
  "google.com": "74.125.131.139"
}
```

### yml-файл(ы), который(е) записал ваш скрипт:
```yaml
---
drive.google.com: 173.194.73.194
google.com: 74.125.131.139
mail.google.com: 108.177.14.18
...
```

## Дополнительное задание (со звездочкой*) - необязательно к выполнению

Так как команды в нашей компании никак не могут прийти к единому мнению о том, какой формат разметки данных использовать: JSON или YAML, нам нужно реализовать парсер из одного формата в другой. Он должен уметь:
   * Принимать на вход имя файла
   * Проверять формат исходного файла. Если файл не json или yml - скрипт должен остановить свою работу
   * Распознавать какой формат данных в файле. Считается, что файлы *.json и *.yml могут быть перепутаны
   * Перекодировать данные из исходного формата во второй доступный (из JSON в YAML, из YAML в JSON)
   * При обнаружении ошибки в исходном файле - указать в стандартном выводе строку с ошибкой синтаксиса и её номер
   * Полученный файл должен иметь имя исходного файла, разница в наименовании обеспечивается разницей расширения файлов

Ответ: Чет жОсть какая-то. Получилось, наверное, не совсем красиво, но работает. Не факт, что все предусмотрел и проверил. Ладно... попробую продемонстрировать.  В скрипте делал комментарии.
### Ваш скрипт:
```python
#!/usr/bin/env python3

import re, sys, json, yaml, traceback, os
from pathlib import Path

#Функция проверки внутренностей файла json
def _load_config_json(file_path):
    with open(file_path, "r") as in_fh:
        config = in_fh.read()
    
    config_dict = dict()
    valid_json = True
    
    try:
        config_dict = json.loads(config)
    except:
        traceback.print_exc(limit=0)
        valid_json = False
        
#Создаем файл .yaml. Конвертим данные из json в yaml
    if valid_json == True:
        name, ext = os.path.splitext(file_path)
        new_name = name + '.yaml'
        with open(new_name, 'w') as in_fh:
            in_fh.write(yaml.dump(config_dict))
        
    return valid_json


#Функция проверки внутренностей файла yaml
def _load_config_yaml(file_path):
    with open(file_path, "r") as in_fh:
        config = in_fh.read()
    
    config_dict = dict()
    valid_yaml = True

    try:
        config_dict = yaml.safe_load(config)
    except:
        traceback.print_exc(limit=0)
        valid_yaml = False
        
#Создаем файл .json. Конвертим данные из yaml в json
    if valid_yaml == True:
        name, ext = os.path.splitext(file_path)
        new_name = name + '.json'
        with open(new_name, 'w') as in_fh:
            in_fh.write(json.dumps(config_dict))
            
    return valid_yaml


arg = sys.argv[1]
file_path = Path(arg)
#Предварительная проверка принадлежности файла к json или yaml. Учет по ","
commas = re.compile(r',(?=(?![\"]*[\s\w\?\.\"\!\-\_]*,))(?=(?![^\[]*\]))')
signs = commas.findall(file_path.open('r').read())

#Считаем "," Если они есть, то предварительно файл json
if len(signs) > 0:
    #Более детально проверяем файл. Вызываем функцию.
    valid_json = _load_config_json(file_path)
    valid_yaml = False
#Два False == файл не Json или Yaml. Возможно, в файле ошибки! см. вывод в консоль.
    if not valid_json and not valid_yaml:
        print('[WARNING] Укажите правильный файл или исправьте ошибки. Файл не является JSON или YAML')
#Если "," нет, предварительно считаем, что перед нами yaml. Вызываем функцию, проверяем.
else:
    valid_json = False
    valid_yaml = _load_config_yaml(file_path)
#Два False == файл не Json или Yaml. Возможно, в файле ошибки! см. вывод в консоль.
    if not valid_json and not valid_yaml:
        print('[WARNING] Укажите правильный файл или исправьте ошибки. Файл не является JSON или YAML')
```

### Пример работы скрипта:
Имеем исходные файлы:
```json
gnoy@openSUSE-vm01:~/git-projects/netology.devops.pub/homeworks/04-script-03-yaml> cat json_file.json 
{
  "name": "Ivan",
  "age": 37,
  "mother": {
    "name": "Olga",
    "age": 58
  },
  "children": [
    "Masha",
    "Igor",
    "Tanya"
  ],
  "married": true,
  "dog": null
}
```
```yaml
gnoy@openSUSE-vm01:~/git-projects/netology.devops.pub/homeworks/04-script-03-yaml> cat yaml_file.yaml 
access:
- switchport mode access
- switchport access vlan
- switchport nonegotiate
- spanning-tree portfast
- spanning-tree bpduguard enable
trunk:
- switchport trunk encapsulation dot1q
- switchport mode trunk
- switchport trunk native vlan 999
- switchport trunk allowed vlan
```
Проверим идеальные условия. Имеем 2 файла: json_file.json и yaml_file.yaml, крутанем  их через скрипт. На выходе должны получить файлы json_file.yaml и yaml_file.json
```bash
gnoy@openSUSE-vm01:~> ./git-projects/netology.devops.pub/homeworks/04-script-03-yaml/task3.py ~/git-projects/netology.devops.pub/homeworks/04-script-03-yaml/json_file.json
gnoy@openSUSE-vm01:~> cd git-projects/netology.devops.pub/homeworks/04-script-03-yaml
gnoy@openSUSE-vm01:~/git-projects/netology.devops.pub/homeworks/04-script-03-yaml> ./task3.py yaml_file.yaml
gnoy@openSUSE-vm01:~/git-projects/netology.devops.pub/homeworks/04-script-03-yaml> ls -lh
итого 40K
-rw-r--r-- 1 gnoy users 8,5K дек 22 13:33 04-script-03-yaml.md
-rw-r--r-- 1 gnoy users  179 дек 22 13:29 json_file.json
-rw-r--r-- 1 gnoy users  107 дек 22 13:29 json_file.yaml
-rw-r--r-- 1 gnoy users  259 дек 21 16:06 task1.json
-rwxr-xr-x 1 gnoy users  781 дек 20 11:41 task2.py
-rwxr-xr-x 1 gnoy users 2,9K дек 22 12:42 task3.py
-rw-r--r-- 1 gnoy users  295 дек 22 13:30 yaml_file.json
-rw-r--r-- 1 gnoy users  278 дек 22 12:44 yaml_file.yaml
```
Проверяем содержимое новых файлов:
```yaml
gnoy@openSUSE-vm01:~/git-projects/netology.devops.pub/homeworks/04-script-03-yaml> cat json_file.yaml 
age: 37
children:
- Masha
- Igor
- Tanya
dog: null
married: true
mother:
  age: 58
  name: Olga
name: Ivan
```
```json
gnoy@openSUSE-vm01:~/git-projects/netology.devops.pub/homeworks/04-script-03-yaml> cat yaml_file.json 
{"access": ["switchport mode access", "switchport access vlan", "switchport nonegotiate", "spanning-tree portfast", "spanning-tree bpduguard enable"], "trunk": ["switchport trunk encapsulation dot1q", "switchport mode trunk", "switchport trunk native vlan 999", "switchport trunk allowed vlan"]}
```
В обратную сторону тоже конвертируется. Для чистоты эксперимента удаляем исходные файлы (yaml_file.yaml и json_file.json). Проверяем:
```bash
gnoy@openSUSE-vm01:~/git-projects/netology.devops.pub/homeworks/04-script-03-yaml> ls -lh
итого 32K
-rw-r--r-- 1 gnoy users  10K дек 22 13:39 04-script-03-yaml.md
-rw-r--r-- 1 gnoy users  107 дек 22 13:29 json_file.yaml
-rw-r--r-- 1 gnoy users  259 дек 21 16:06 task1.json
-rwxr-xr-x 1 gnoy users  781 дек 20 11:41 task2.py
-rwxr-xr-x 1 gnoy users 2,9K дек 22 12:42 task3.py
-rw-r--r-- 1 gnoy users  295 дек 22 13:30 yaml_file.json
```
```json
gnoy@openSUSE-vm01:~/git-projects/netology.devops.pub/homeworks/04-script-03-yaml> ./task3.py json_file.yaml
gnoy@openSUSE-vm01:~/git-projects/netology.devops.pub/homeworks/04-script-03-yaml> cat json_file.json 
{"age": 37, "children": ["Masha", "Igor", "Tanya"], "dog": null, "married": true, "mother": {"age": 58, "name": "Olga"}, "name": "Ivan"}
```
```yaml
gnoy@openSUSE-vm01:~/git-projects/netology.devops.pub/homeworks/04-script-03-yaml> ./task3.py yaml_file.json 
gnoy@openSUSE-vm01:~/git-projects/netology.devops.pub/homeworks/04-script-03-yaml> cat yaml_file.yaml 
access:
- switchport mode access
- switchport access vlan
- switchport nonegotiate
- spanning-tree portfast
- spanning-tree bpduguard enable
trunk:
- switchport trunk encapsulation dot1q
- switchport mode trunk
- switchport trunk native vlan 999
- switchport trunk allowed vlan
```
Теперь попробуем воспроизвести ошибки.  
Подсовываем скрипту "левый файл"
```bash
gnoy@openSUSE-vm01:~/git-projects/netology.devops.pub/homeworks/04-script-03-yaml> ./task3.py googletranslate_aspushkin 
json.decoder.JSONDecodeError: Expecting value: line 1 column 1 (char 0)
[WARNING] Укажите правильный файл или исправьте ошибки. Файл не является JSON или YAML
```
Теперь возьмем json-файл и сломаем ему внутренность (удалил `"` перед `married"`)
```bash
gnoy@openSUSE-vm01:~/git-projects/netology.devops.pub/homeworks/04-script-03-yaml> cat json_file.json 
{"age": 37, "children": ["Masha", "Igor", "Tanya"], "dog": null, married": true, "mother": {"age": 58, "name": "Olga"}, "name": "Ivan"}
gnoy@openSUSE-vm01:~/git-projects/netology.devops.pub/homeworks/04-script-03-yaml> ./task3.py json_file.json 
json.decoder.JSONDecodeError: Expecting property name enclosed in double quotes: line 1 column 66 (char 65)
[WARNING] Укажите правильный файл или исправьте ошибки. Файл не является JSON или YAML
```
Таким же способом "ломаем" yaml (Удалил `-` перед `switchport trunk native vlan 999`). Проверяем:
```bash
gnoy@openSUSE-vm01:~/git-projects/netology.devops.pub/homeworks/04-script-03-yaml> cat yaml_file.yaml 
access:
- switchport mode access
- switchport access vlan
- switchport nonegotiate
- spanning-tree portfast
- spanning-tree bpduguard enable
trunk:
- switchport trunk encapsulation dot1q
- switchport mode trunk
switchport trunk native vlan 999
- switchport trunk allowed vlan
gnoy@openSUSE-vm01:~/git-projects/netology.devops.pub/homeworks/04-script-03-yaml> ./task3.py yaml_file.yaml 
yaml.scanner.ScannerError: while scanning a simple key
  in "<unicode string>", line 10, column 1:
    switchport trunk native vlan 999
    ^
could not find expected ':'
  in "<unicode string>", line 11, column 1:
    - switchport trunk allowed vlan
    ^
[WARNING] Укажите правильный файл или исправьте ошибки. Файл не является JSON или YAML
```