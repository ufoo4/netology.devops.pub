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