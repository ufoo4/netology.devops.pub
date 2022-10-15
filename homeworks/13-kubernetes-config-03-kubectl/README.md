# Домашнее задание к занятию "13.3 работа с kubectl"
## Задание 1: проверить работоспособность каждого компонента
Для проверки работы можно использовать 2 способа: port-forward и exec. Используя оба способа, проверьте каждый компонент:
* сделайте запросы к бекенду;
* сделайте запросы к фронту;
* подключитесь к базе данных.  

**Ответ:**  
После прошлого ДЗ я все свернул.  
Вновь задеплою в k8s приложения.  
Проверяю, что получилось:
```bash
❯ kubectl -n production get po,pv,pvc
NAME                      READY   STATUS    RESTARTS   AGE
pod/ba-5cc8999674-w8lf8   1/1     Running   0          7m11s
pod/db-0                  1/1     Running   0          61m
pod/fr-7b466b5477-xtwl8   1/1     Running   0          2m58s

NAME                                                        CAPACITY   ACCESS MODES   RECLAIM POLICY   STATUS   CLAIM                    STORAGECLASS   REASON   AGE
persistentvolume/pv-db                                      1Gi        RWO            Retain           Bound    production/pvc-db-db-0   nfs                     61m
persistentvolume/pvc-37b74233-c876-4efc-ac29-dc46e077e76c   500Mi      RWX            Delete           Bound    production/pvc           nfs                     7m11s

NAME                                STATUS   VOLUME                                     CAPACITY   ACCESS MODES   STORAGECLASS   AGE
persistentvolumeclaim/pvc           Bound    pvc-37b74233-c876-4efc-ac29-dc46e077e76c   500Mi      RWX            nfs            7m11s
persistentvolumeclaim/pvc-db-db-0   Bound    pv-db                                      1Gi        RWO            nfs            61m
```
Запрос к бекенду:
```bash
❯ kubectl -n production exec ba-5cc8999674-w8lf8 -- curl -I -s http://localhost:9000/api/news
HTTP/1.1 307 Temporary Redirect
date: Sat, 15 Oct 2022 17:59:45 GMT
server: uvicorn
location: http://localhost:9000/api/news/
Transfer-Encoding: chunked
```
Запрос к фронту:
```bash
❯ kubectl -n production exec fr-7b466b5477-xtwl8 -- curl -s http://localhost
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
</html>%     
```
Запрос к БД:
```bash
❯ kubectl -n production exec db-0 -- psql -U postgres -c '\l'
                                 List of databases
   Name    |  Owner   | Encoding |  Collate   |   Ctype    |   Access privileges
-----------+----------+----------+------------+------------+-----------------------
 news      | postgres | UTF8     | en_US.utf8 | en_US.utf8 |
 postgres  | postgres | UTF8     | en_US.utf8 | en_US.utf8 |
 template0 | postgres | UTF8     | en_US.utf8 | en_US.utf8 | =c/postgres          +
           |          |          |            |            | postgres=CTc/postgres
 template1 | postgres | UTF8     | en_US.utf8 | en_US.utf8 | =c/postgres          +
           |          |          |            |            | postgres=CTc/postgres
(4 rows)
```

## Задание 2: ручное масштабирование

При работе с приложением иногда может потребоваться вручную добавить пару копий. Используя команду kubectl scale, попробуйте увеличить количество бекенда и фронта до 3. Проверьте, на каких нодах оказались копии после каждого действия (kubectl describe, kubectl get pods -o wide). После уменьшите количество копий до 1.

**Ответ:**  
Увеличил количество реплик до 3 для фронта и бека:
```bash
❯ kubectl -n production scale deployment ba --replicas=3
deployment.apps/ba scaled
❯ kubectl -n production scale deployment fr --replicas=3
deployment.apps/fr scaled
❯ kubectl -n production get pods -o wide
NAME                  READY   STATUS    RESTARTS   AGE   IP               NODE                          NOMINATED NODE   READINESS GATES
ba-5cc8999674-b7gj7   1/1     Running   0          33s   10.233.89.18     k8s-worker-02.cluster.local   <none>           <none>
ba-5cc8999674-jl5bx   1/1     Running   0          33s   10.233.104.147   k8s-worker-01.cluster.local   <none>           <none>
ba-5cc8999674-w8lf8   1/1     Running   0          15m   10.233.89.17     k8s-worker-02.cluster.local   <none>           <none>
db-0                  1/1     Running   0          70m   10.233.104.144   k8s-worker-01.cluster.local   <none>           <none>
fr-7b466b5477-jndn9   1/1     Running   0          16s   10.233.89.19     k8s-worker-02.cluster.local   <none>           <none>
fr-7b466b5477-xfxp6   1/1     Running   0          16s   10.233.104.148   k8s-worker-01.cluster.local   <none>           <none>
fr-7b466b5477-xtwl8   1/1     Running   0          11m   10.233.104.146   k8s-worker-01.cluster.local   <none>           <none>
```
Возвращаю количество реплик до 1:
```bash
❯ kubectl -n production scale deployment fr --replicas=1
deployment.apps/fr scaled
❯ kubectl -n production scale deployment ba --replicas=1
deployment.apps/ba scaled
❯ kubectl -n production get pods -o wide
NAME                  READY   STATUS    RESTARTS   AGE     IP               NODE                          NOMINATED NODE   READINESS GATES
ba-5cc8999674-jl5bx   1/1     Running   0          3m1s    10.233.104.147   k8s-worker-01.cluster.local   <none>           <none>
db-0                  1/1     Running   0          73m     10.233.104.144   k8s-worker-01.cluster.local   <none>           <none>
fr-7b466b5477-jndn9   1/1     Running   0          2m44s   10.233.89.19     k8s-worker-02.cluster.local   <none>           <none>
```
Смотрю describe у фронта и бека:
```bash
❯ kubectl -n production describe deployments.apps ba
Name:                   ba
Namespace:              production
CreationTimestamp:      Sat, 15 Oct 2022 22:53:02 +0500
Labels:                 app=ba
Annotations:            deployment.kubernetes.io/revision: 1
Selector:               app=ba
Replicas:               1 desired | 1 updated | 1 total | 1 available | 0 unavailable
StrategyType:           RollingUpdate
MinReadySeconds:        0
RollingUpdateStrategy:  25% max unavailable, 25% max surge
Pod Template:
  Labels:  app=ba
  Containers:
   ba:
    Image:      foo4/13-kub-config-01-obj_src-backend
    Port:       9000/TCP
    Host Port:  0/TCP
    Limits:
      cpu:     500m
      memory:  128Mi
    Requests:
      cpu:     250m
      memory:  64Mi
    Environment:
      DATABASE_URL:  postgres://postgres:postgres@db:5432/news
    Mounts:
      /static from my-volume (rw)
  Volumes:
   my-volume:
    Type:       PersistentVolumeClaim (a reference to a PersistentVolumeClaim in the same namespace)
    ClaimName:  pvc
    ReadOnly:   false
Conditions:
  Type           Status  Reason
  ----           ------  ------
  Progressing    True    NewReplicaSetAvailable
  Available      True    MinimumReplicasAvailable
OldReplicaSets:  <none>
NewReplicaSet:   ba-5cc8999674 (1/1 replicas created)
Events:
  Type    Reason             Age        From                   Message
  ----    ------             ----       ----                   -------
  Normal  ScalingReplicaSet  <invalid>  deployment-controller  Scaled up replica set ba-5cc8999674 to 1
  Normal  ScalingReplicaSet  <invalid>  deployment-controller  Scaled up replica set ba-5cc8999674 to 3
  Normal  ScalingReplicaSet  <invalid>  deployment-controller  Scaled down replica set ba-5cc8999674 to 1

❯ kubectl -n production describe deployments.apps fr
Name:                   fr
Namespace:              production
CreationTimestamp:      Sat, 15 Oct 2022 22:57:15 +0500
Labels:                 app=fr
Annotations:            deployment.kubernetes.io/revision: 1
Selector:               app=fr
Replicas:               1 desired | 1 updated | 1 total | 1 available | 0 unavailable
StrategyType:           RollingUpdate
MinReadySeconds:        0
RollingUpdateStrategy:  25% max unavailable, 25% max surge
Pod Template:
  Labels:  app=fr
  Containers:
   fr:
    Image:      foo4/13-kub-config-01-obj_src-frontend
    Port:       80/TCP
    Host Port:  0/TCP
    Limits:
      cpu:     500m
      memory:  128Mi
    Requests:
      cpu:     250m
      memory:  64Mi
    Environment:
      BASE_URL:  http://localhost:9000
    Mounts:
      /static from my-volume (rw)
  Volumes:
   my-volume:
    Type:       PersistentVolumeClaim (a reference to a PersistentVolumeClaim in the same namespace)
    ClaimName:  pvc
    ReadOnly:   false
Conditions:
  Type           Status  Reason
  ----           ------  ------
  Progressing    True    NewReplicaSetAvailable
  Available      True    MinimumReplicasAvailable
OldReplicaSets:  <none>
NewReplicaSet:   fr-7b466b5477 (1/1 replicas created)
Events:
  Type    Reason             Age        From                   Message
  ----    ------             ----       ----                   -------
  Normal  ScalingReplicaSet  <invalid>  deployment-controller  Scaled up replica set fr-7b466b5477 to 1
  Normal  ScalingReplicaSet  <invalid>  deployment-controller  Scaled up replica set fr-7b466b5477 to 3
  Normal  ScalingReplicaSet  <invalid>  deployment-controller  Scaled down replica set fr-7b466b5477 to 1
```
