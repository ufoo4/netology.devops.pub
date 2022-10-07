# Домашнее задание к занятию "13.1 контейнеры, поды, deployment, statefulset, services, endpoints"
Настроив кластер, подготовьте приложение к запуску в нём. Приложение стандартное: бекенд, фронтенд, база данных. Его можно найти в папке 13-kubernetes-config.

## Задание 1: подготовить тестовый конфиг для запуска приложения
Для начала следует подготовить запуск приложения в stage окружении с простыми настройками. Требования:
* под содержит в себе 2 контейнера — фронтенд, бекенд;
* регулируется с помощью deployment фронтенд и бекенд;
* база данных — через statefulset.

**Ответ:**  
В первую очередь запустил `docker-compose up --build`. Приложение запустилось, создались docker-образы.
```bash
schipyshev@NOTEBOOK-234VSMB:$ docker images
REPOSITORY                TAG         IMAGE ID       CREATED         SIZE
src-frontend              latest      7537bfffd291   2 minutes ago   142MB
src-backend               latest      a460425cec7b   2 minutes ago   1.06GB
postgres                  13-alpine   ed8ed2786948   7 weeks ago     213MB
apachepulsar/pulsar-all   latest      f6c0b685a18b   3 months ago    2.99GB
```   
Мне интересны back и front имеджи, на них навесил свои теги и запушил их на hub.docker.com (локальный реджестри было лень разворачивать -_- )  
Подготовил [манифесты](./src/manifests/stage) для деплоя в k8s в stage namespace.  
Дополнительно пришлось создать service для доступа бекенда к БД.  
Деплою и проверяю:
```bash
❯ kubectl -n stage get po -o wide
NAME                     READY   STATUS    RESTARTS   AGE     IP              NODE                        NOMINATED NODE   READINESS GATES
db-0                     1/1     Running   0          9m57s   10.233.99.207   k8s-worker-01.localdomain   <none>           <none>
fr-ba-5966669ccf-gsscj   2/2     Running   0          9m54s   10.233.123.18   k8s-worker-02.localdomain   <none>           <none>
❯ kubectl -n stage get service
NAME   TYPE        CLUSTER-IP     EXTERNAL-IP   PORT(S)    AGE
db     ClusterIP   10.233.15.15   <none>        5432/TCP   10m
❯ kubectl -n stage get pv
NAME    CAPACITY   ACCESS MODES   RECLAIM POLICY   STATUS   CLAIM               STORAGECLASS   REASON   AGE
pv-db   1Gi        RWO            Retain           Bound    stage/pvc-db-db-0                           10m
❯ kubectl -n stage get pvc
NAME          STATUS   VOLUME   CAPACITY   ACCESS MODES   STORAGECLASS   AGE
pvc-db-db-0   Bound    pv-db    1Gi        RWO                           10m
❯ kubectl -n stage get statefulsets.apps
NAME   READY   AGE
db     1/1     10m
```
Проверю работу frontend'а:
```bash
❯ kubectl -n stage exec fr-ba-5966669ccf-gsscj -c fr -- curl -s http://localhost
<!DOCTYPE html>
<html lang="ru">
<head>
    <title>Список</title>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link href="/build/main.css" rel="stylesheet">
</head>
<body>
    <main class="b-page">
        <h1 class="b-page__title">Список</h1>
        <div class="b-page__content b-items js-list"></div>
    </main>
    <script src="/build/main.js"></script>
</body>
</html>
```
... И backend'а, хотя, там данных нет, но и ошибок нет.   
Для примера так же попробую "кривую ссылку" (там будет ошибка):
``` bash
❯ kubectl -n stage exec fr-ba-5966669ccf-gsscj -c ba -- curl -s http://localhost:9000/api/news
❯
❯ kubectl -n stage exec fr-ba-5966669ccf-gsscj -c ba -- curl -s http://localhost:9000/api/news78465875873
{"detail":"Not Found"}
❯
```

## Задание 2: подготовить конфиг для production окружения
Следующим шагом будет запуск приложения в production окружении. Требования сложнее:
* каждый компонент (база, бекенд, фронтенд) запускаются в своем поде, регулируются отдельными deployment’ами;
* для связи используются service (у каждого компонента свой);
* в окружении фронта прописан адрес сервиса бекенда;
* в окружении бекенда прописан адрес сервиса базы данных.  

**Ответ:**  
Подготовил [манифесты](./src/manifests/production/) для деплоя.  
Деплою их в кластер k8s в ns production.  
```bash
❯ kubectl get po,svc,pv,pvc -n production -o wide
NAME                      READY   STATUS    RESTARTS   AGE     IP              NODE                        NOMINATED NODE   READINESS GATES
pod/ba-86cdf6fff5-wdh9r   1/1     Running   0          16m     10.233.123.51   k8s-worker-02.localdomain   <none>           <none>
pod/db-0                  1/1     Running   0          4m19s   10.233.99.233   k8s-worker-01.localdomain   <none>           <none>
pod/fr-5fbd89d5db-kqgt8   1/1     Running   0          14m     10.233.99.232   k8s-worker-01.localdomain   <none>           <none>

NAME         TYPE        CLUSTER-IP      EXTERNAL-IP   PORT(S)    AGE   SELECTOR
service/ba   ClusterIP   10.233.49.150   <none>        9000/TCP   16m   app=ba
service/db   ClusterIP   10.233.45.164   <none>        5432/TCP   46h   app=db
service/fr   ClusterIP   10.233.16.223   <none>        80/TCP     14m   app=fr

NAME                     CAPACITY   ACCESS MODES   RECLAIM POLICY   STATUS   CLAIM                    STORAGECLASS   REASON   AGE     VOLUMEMODE
persistentvolume/pv-db   1Gi        RWO            Retain           Bound    production/pvc-db-db-0                           4m19s   Filesystem

NAME                                STATUS   VOLUME   CAPACITY   ACCESS MODES   STORAGECLASS   AGE     VOLUMEMODE
persistentvolumeclaim/pvc-db-db-0   Bound    pv-db    1Gi        RWO                           4m19s   Filesystem
```
Проверяю работу приложений.  
Фронт:
```bash
❯ kubectl -n production exec fr-5fbd89d5db-kqgt8 -- curl -s http://localhost
<!DOCTYPE html>
<html lang="ru">
<head>
    <title>Список</title>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link href="/build/main.css" rel="stylesheet">
</head>
<body>
    <main class="b-page">
        <h1 class="b-page__title">Список</h1>
        <div class="b-page__content b-items js-list"></div>
    </main>
    <script src="/build/main.js"></script>
</body>
<html>%       
```
Бекенд, но по какой-то причине у меня нет в БД данных. При этом, если набрать изначально кривой адрес, то буде ошибка (показана ниже):
```bash
❯ kubectl -n production exec ba-86cdf6fff5-wdh9r -- curl -s http://localhost:9000/api/news
❯ kubectl -n production exec ba-86cdf6fff5-wdh9r -- curl -s http://localhost:9000/api/news12
{"detail":"Not Found"}% 
```           

## Задание 3 (*): добавить endpoint на внешний ресурс api
Приложению потребовалось внешнее api, и для его использования лучше добавить endpoint в кластер, направленный на это api. Требования:
* добавлен endpoint до внешнего api (например, геокодер).
