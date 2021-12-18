#!/usr/bin/env python3

import os

bash_command = ["cd /home/gnoy/git-projects/testproject", "git status"]
result_os = os.popen(' && '.join(bash_command)).read()
print(f'Путь до локального репозитория: {bash_command[0][3::]}')
for result in result_os.split('\n'):
    if result.find('изменено') != -1:
        prepare_result = result.replace('\tизменено:   ', '')
        print(prepare_result)