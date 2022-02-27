# Домашнее задание к занятию "5.5. Оркестрация кластером Docker контейнеров на примере Docker Swarm"

## Задача 1

Дайте письменые ответы на следующие вопросы:

- В чём отличие режимов работы сервисов в Docker Swarm кластере: replication и global?
- Какой алгоритм выбора лидера используется в Docker Swarm кластере?
- Что такое Overlay Network?  

Ответ:  
- В чём отличие режимов работы сервисов в Docker Swarm кластере: replication и global?  
Отличие состоит в количестве запускаемых задач на нодах. В режиме global каждая задача запустится один раз, но на каждой ноде, предварительно заданного количества задач нет. В режиме  replication нам нужно указать количество необходимых реплик, одна и та же задача запустятся в указанном количестве. 
- Какой алгоритм выбора лидера используется в Docker Swarm кластере?  
В кластере одновременно могут работать несколько управляющих нод, любая из них может в любой момент времени заменить вышедрую из строя ноду. Для выбора управляющей ноды используется алгоритм поддержания распределенного консенсуса - Raft. Данный протокол позволяет любой ноде быть послодователем, кандидатом или лидером. Все зависит от "голосавания" остальных нод в кластере.
- Что такое Overlay Network?  
Это виртуальная подсеть, она связывает несколько физических хостов, на которых запущен docker. Ее используют контейнеры расположенные на разных хостах в кластере swarm.

## Задача 2

Создать ваш первый Docker Swarm кластер в Яндекс.Облаке

Для получения зачета, вам необходимо предоставить скриншот из терминала (консоли), с выводом команды:
```
docker node ls
```  
Ответ:  
```bash
[centos@node01 ~]$ sudo docker node ls
ID                            HOSTNAME             STATUS    AVAILABILITY   MANAGER STATUS   ENGINE VERSION
1jke2w55cuolhw9bm7jjikhgi *   node01.netology.yc   Ready     Active         Leader           20.10.12
zar5ily5kgnzyaf19t97mgrx7     node02.netology.yc   Ready     Active         Reachable        20.10.12
tilfxvpuucz1x8q8ned1feb58     node03.netology.yc   Ready     Active         Reachable        20.10.12
j6sfmzuu334pvym9n98kmn1nr     node04.netology.yc   Ready     Active                          20.10.12
u1qb8dqr5brir3ylk1new5mhz     node05.netology.yc   Ready     Active                          20.10.12
v2e3yztzz4ptwscxzixno907w     node06.netology.yc   Ready     Active                          20.10.12
```


## Задача 3

Создать ваш первый, готовый к боевой эксплуатации кластер мониторинга, состоящий из стека микросервисов.

Для получения зачета, вам необходимо предоставить скриншот из терминала (консоли), с выводом команды:
```
docker service ls
```  
Ответ:  
```bash
[centos@node01 ~]$ sudo docker service ls
ID             NAME                                MODE         REPLICAS   IMAGE                                          PORTS
omg9nt5xhwp8   swarm_monitoring_alertmanager       replicated   1/1        stefanprodan/swarmprom-alertmanager:v0.14.0    
5xoxxbmmd58f   swarm_monitoring_caddy              replicated   1/1        stefanprodan/caddy:latest                      *:3000->3000/tcp, *:9090->9090/tcp, *:9093-9094->9093-9094/tcp
xgo79p8e0jwi   swarm_monitoring_cadvisor           global       6/6        google/cadvisor:latest                         
n6u2ftk892ck   swarm_monitoring_dockerd-exporter   global       6/6        stefanprodan/caddy:latest                      
mjnitlnwtuem   swarm_monitoring_grafana            replicated   1/1        stefanprodan/swarmprom-grafana:5.3.4           
i5imw5p4jey0   swarm_monitoring_node-exporter      global       6/6        stefanprodan/swarmprom-node-exporter:v0.16.0   
ixui54abl5mi   swarm_monitoring_prometheus         replicated   1/1        stefanprodan/swarmprom-prometheus:v2.5.0       
v5kt72tncqni   swarm_monitoring_unsee              replicated   1/1        cloudflare/unsee:v0.8.0                        
```

## Задача 4 (*)

Выполнить на лидере Docker Swarm кластера команду (указанную ниже) и дать письменное описание её функционала, что она делает и зачем она нужна:
```
# см.документацию: https://docs.docker.com/engine/swarm/swarm_manager_locking/
docker swarm update --autolock=true
```  
Ответ:  
По умолчанию при перезапуске docker'а автоматически загружаются ключи шифрования в память каждой ноды. Данная команда позволяет защитить ключ взаимного шифрования TLS и ключ шифрования\дешифрования журналов Raft в состоянии покоя. При перезапуске docker'а система будет требовать разблокировку кластера swarm заранее сгенерированным ключем (см. ниже)
```bash
[centos@node02 ~]$ sudo docker swarm update --autolock=true
Swarm updated.
To unlock a swarm manager after it restarts, run the `docker swarm unlock`
command and provide the following key:

    SWMKEY-1-kLbd4ekyvesqVSeObVHqEYf0nWNe/QTvC0iBio/J9WM

Please remember to store this key in a password manager, since without it you
will not be able to restart the manager.
```
Пример использования:  
Перезагружаем node01.netology.yc и смотрим состояние нод с лидера node02.netology.yc. Видим, что node01.netology.yc находится в недоступном состоянии:
```bash
[centos@node02 ~]$ sudo docker node ls
ID                            HOSTNAME             STATUS    AVAILABILITY   MANAGER STATUS   ENGINE VERSION
qzup8k7ejcsjgykkygpek0a1g     node01.netology.yc   Down      Active         Unreachable      20.10.12
pzfy6x7qz17ds6a9seevs2bkc *   node02.netology.yc   Ready     Active         Leader           20.10.12
pw17cxfjiydd1459wfkgw5ity     node03.netology.yc   Ready     Active         Reachable        20.10.12
wtj9pfwaj64qsr2v0kz993mry     node04.netology.yc   Ready     Active                          20.10.12
5g7rt2fxj36nf4w0qydqlilrn     node05.netology.yc   Ready     Active                          20.10.12
pdtxr3u33030p5281z9h8zy9e     node06.netology.yc   Ready     Active                          20.10.12
```
При попытке посмотреть доступные ноды с node01.netology.yc получаем:
```bash
[centos@node01 ~]$ sudo docker node ls
Error response from daemon: Swarm is encrypted and needs to be unlocked before it can be used. Please use "docker swarm unlock" to unlock it.
```
Ок. Разблокируем сгенерированным выше ключем перезагруженную ноду:
```bash
[centos@node01 ~]$ sudo docker swarm unlock
Please enter unlock key: 
[centos@node01 ~]$
```
Вуаля, мы вновь в кластере:
```bash
[centos@node01 ~]$ sudo docker node ls
ID                            HOSTNAME             STATUS    AVAILABILITY   MANAGER STATUS   ENGINE VERSION
qzup8k7ejcsjgykkygpek0a1g *   node01.netology.yc   Ready     Active         Reachable        20.10.12
pzfy6x7qz17ds6a9seevs2bkc     node02.netology.yc   Ready     Active         Leader           20.10.12
pw17cxfjiydd1459wfkgw5ity     node03.netology.yc   Ready     Active         Reachable        20.10.12
wtj9pfwaj64qsr2v0kz993mry     node04.netology.yc   Ready     Active                          20.10.12
5g7rt2fxj36nf4w0qydqlilrn     node05.netology.yc   Ready     Active                          20.10.12
pdtxr3u33030p5281z9h8zy9e     node06.netology.yc   Ready     Active                          20.10.12
```