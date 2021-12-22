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