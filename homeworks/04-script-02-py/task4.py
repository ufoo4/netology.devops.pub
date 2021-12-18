#!/usr/bin/env python3

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