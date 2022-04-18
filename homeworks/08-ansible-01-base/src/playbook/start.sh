#!/usr/bin/env bash

exit_status=$?
docker start ubuntu
if [ $exit_status -eq 0 ]; then 
    docker run -d --name ubuntu pycontribs/ubuntu sleep 60000000000
fi
docker start centos7
if [ $exit_status -eq 0 ]; then 
    docker run -d --name centos7 centos:centos7 sleep 60000000000
fi
docker start fedora
if [ $exit_status -eq 0 ]; then 
    docker run -d --name fedora fedora:37 sleep 60000000000
fi

ansible-playbook -i inventory/prod.yml site.yml --vault-password-file password

docker stop ubuntu
docker stop centos7
docker stop fedora