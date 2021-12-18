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