# Домашнее задание к занятию "13.4 инструменты для упрощения написания конфигурационных файлов. Helm и Jsonnet"
В работе часто приходится применять системы автоматической генерации конфигураций. Для изучения нюансов использования разных инструментов нужно попробовать упаковать приложение каждым из них.

## Задание 1: подготовить helm чарт для приложения
Необходимо упаковать приложение в чарт для деплоя в разные окружения. Требования:
* каждый компонент приложения деплоится отдельным deployment’ом/statefulset’ом;
* в переменных чарта измените образ приложения для изменения версии.   

**Ответ:**  
Docker-образы у меня уже были подготовлены и находятся на hub.docker.com, их и буду указывать в чарте.  
Версия образа у меня одна - latest, но tag можно менять в [values](./src/helmcharts/my-app/values.yaml)  
Сами чарты [тут](./src/helmcharts/my-app/).  
Предварительно, для более простой проверки, вывел получаемые манифесты в отдельный .yaml-файл - [debug.yaml](./src/helmcharts/my-app/debug.yaml)  
```bash
❯ helm template first-app ./ > debug.yaml
```

## Задание 2: запустить 2 версии в разных неймспейсах
Подготовив чарт, необходимо его проверить. Попробуйте запустить несколько копий приложения:
* одну версию в namespace=app1;
* вторую версию в том же неймспейсе;
* третью версию в namespace=app2.   

**Ответ:**   
Деплою первую первую версию прилоений в ns app1 и проверяю результат:
```bash
❯ helm install -n app1 first-app ./
NAME: first-app
LAST DEPLOYED: Mon Oct 24 00:38:06 2022
NAMESPACE: app1
STATUS: deployed
REVISION: 1
TEST SUITE: None
❯ kubectl -n app1 get po,svc,pv,pvc,statefulsets
NAME                                READY   STATUS    RESTARTS   AGE
pod/first-app-ba-755d779879-vrksj   1/1     Running   0          101s
pod/first-app-db-0                  1/1     Running   0          101s
pod/first-app-fr-599c75bd78-tfmdp   1/1     Running   0          101s

NAME                   TYPE        CLUSTER-IP      EXTERNAL-IP   PORT(S)    AGE
service/first-app-ba   ClusterIP   10.233.18.193   <none>        9000/TCP   102s
service/first-app-db   ClusterIP   10.233.53.231   <none>        5432/TCP   102s
service/first-app-fr   ClusterIP   10.233.60.238   <none>        80/TCP     102s

NAME                                                        CAPACITY   ACCESS MODES   RECLAIM POLICY   STATUS   CLAIM                        STORAGECLASS   REASON   AGE
persistentvolume/first-app-pv-db                            1Gi        RWO            Retain           Bound    app1/pvc-db-first-app-db-0   nfs-client              102s        
persistentvolume/pvc-adf33fa6-863f-4bf2-a68f-6bec03f24209   500Mi      RWX            Delete           Bound    app1/first-app-pvc           nfs-client              102s        

NAME                                          STATUS   VOLUME                                     CAPACITY   ACCESS MODES   STORAGECLASS   AGE
persistentvolumeclaim/first-app-pvc           Bound    pvc-adf33fa6-863f-4bf2-a68f-6bec03f24209   500Mi      RWX            nfs-client     102s
persistentvolumeclaim/pvc-db-first-app-db-0   Bound    first-app-pv-db                            1Gi        RWO            nfs-client     101s

NAME                            READY   AGE
statefulset.apps/first-app-db   1/1     102s
```
Готово.   
Деплою вторую версию того же приложения в ns app1 и проверяю:
```bash
❯ helm install -n app1 second-app ./
NAME: second-app
LAST DEPLOYED: Mon Oct 24 00:41:55 2022
NAMESPACE: app1
STATUS: deployed
REVISION: 1
TEST SUITE: None
❯ kubectl -n app1 get po,svc,pv,pvc,statefulsets
NAME                                 READY   STATUS    RESTARTS   AGE
pod/first-app-ba-755d779879-vrksj    1/1     Running   0          4m22s
pod/first-app-db-0                   1/1     Running   0          4m22s
pod/first-app-fr-599c75bd78-tfmdp    1/1     Running   0          4m22s
pod/second-app-ba-66d97f9fbf-xc7jm   1/1     Running   0          33s
pod/second-app-db-0                  1/1     Running   0          33s
pod/second-app-fr-574fc949b4-djxmm   1/1     Running   0          33s

NAME                    TYPE        CLUSTER-IP      EXTERNAL-IP   PORT(S)    AGE
service/first-app-ba    ClusterIP   10.233.18.193   <none>        9000/TCP   4m23s
service/first-app-db    ClusterIP   10.233.53.231   <none>        5432/TCP   4m23s
service/first-app-fr    ClusterIP   10.233.60.238   <none>        80/TCP     4m23s
service/second-app-ba   ClusterIP   10.233.57.95    <none>        9000/TCP   33s
service/second-app-db   ClusterIP   10.233.32.181   <none>        5432/TCP   33s
service/second-app-fr   ClusterIP   10.233.29.2     <none>        80/TCP     33s

NAME                                                        CAPACITY   ACCESS MODES   RECLAIM POLICY   STATUS   CLAIM                         STORAGECLASS   REASON   AGE        
persistentvolume/first-app-pv-db                            1Gi        RWO            Retain           Bound    app1/pvc-db-first-app-db-0    nfs-client              4m23s      
persistentvolume/pvc-422fe799-18b0-4310-a282-e04299267491   500Mi      RWX            Delete           Bound    app1/second-app-pvc           nfs-client              33s        
persistentvolume/pvc-adf33fa6-863f-4bf2-a68f-6bec03f24209   500Mi      RWX            Delete           Bound    app1/first-app-pvc            nfs-client              4m23s      
persistentvolume/second-app-pv-db                           1Gi        RWO            Retain           Bound    app1/pvc-db-second-app-db-0   nfs-client              33s        

NAME                                           STATUS   VOLUME                                     CAPACITY   ACCESS MODES   STORAGECLASS   AGE
persistentvolumeclaim/first-app-pvc            Bound    pvc-adf33fa6-863f-4bf2-a68f-6bec03f24209   500Mi      RWX            nfs-client     4m23s
persistentvolumeclaim/pvc-db-first-app-db-0    Bound    first-app-pv-db                            1Gi        RWO            nfs-client     4m22s
persistentvolumeclaim/pvc-db-second-app-db-0   Bound    second-app-pv-db                           1Gi        RWO            nfs-client     33s
persistentvolumeclaim/second-app-pvc           Bound    pvc-422fe799-18b0-4310-a282-e04299267491   500Mi      RWX            nfs-client     33s

NAME                             READY   AGE
statefulset.apps/first-app-db    1/1     4m23s
statefulset.apps/second-app-db   1/1     33s
```
Готово.   
Деплою третью версию приложения в ns app2 и проверяю:
```bash
❯ helm install -n app2 third-app ./
NAME: third-app
LAST DEPLOYED: Mon Oct 24 00:43:53 2022
NAMESPACE: app2
STATUS: deployed
REVISION: 1
TEST SUITE: None
❯ kubectl -n app2 get po,svc,pv,pvc,statefulsets
NAME                                READY   STATUS    RESTARTS   AGE
pod/third-app-ba-84cc48f87f-48w8p   1/1     Running   0          2m44s
pod/third-app-db-0                  1/1     Running   0          2m44s
pod/third-app-fr-5f4d5bc888-f245m   1/1     Running   0          2m44s

NAME                   TYPE        CLUSTER-IP      EXTERNAL-IP   PORT(S)    AGE
service/third-app-ba   ClusterIP   10.233.14.20    <none>        9000/TCP   2m46s
service/third-app-db   ClusterIP   10.233.18.125   <none>        5432/TCP   2m46s
service/third-app-fr   ClusterIP   10.233.13.80    <none>        80/TCP     2m46s

NAME                                                        CAPACITY   ACCESS MODES   RECLAIM POLICY   STATUS   CLAIM                         STORAGECLASS   REASON   AGE        
persistentvolume/first-app-pv-db                            1Gi        RWO            Retain           Bound    app1/pvc-db-first-app-db-0    nfs-client              8m34s      
persistentvolume/pvc-422fe799-18b0-4310-a282-e04299267491   500Mi      RWX            Delete           Bound    app1/second-app-pvc           nfs-client              4m44s      
persistentvolume/pvc-75ae4fbd-d1ff-49e2-992c-450b1b689a71   500Mi      RWX            Delete           Bound    app2/third-app-pvc            nfs-client              2m47s      
persistentvolume/pvc-adf33fa6-863f-4bf2-a68f-6bec03f24209   500Mi      RWX            Delete           Bound    app1/first-app-pvc            nfs-client              8m34s      
persistentvolume/second-app-pv-db                           1Gi        RWO            Retain           Bound    app1/pvc-db-second-app-db-0   nfs-client              4m44s      
persistentvolume/third-app-pv-db                            1Gi        RWO            Retain           Bound    app2/pvc-db-third-app-db-0    nfs-client              2m47s      

NAME                                          STATUS   VOLUME                                     CAPACITY   ACCESS MODES   STORAGECLASS   AGE
persistentvolumeclaim/pvc-db-third-app-db-0   Bound    third-app-pv-db                            1Gi        RWO            nfs-client     2m47s
persistentvolumeclaim/third-app-pvc           Bound    pvc-75ae4fbd-d1ff-49e2-992c-450b1b689a71   500Mi      RWX            nfs-client     2m47s

NAME                            READY   AGE
statefulset.apps/third-app-db   1/1     2m47s
```

## Задание 3 (*): повторить упаковку на jsonnet
Для изучения другого инструмента стоит попробовать повторить опыт упаковки из задания 1, только теперь с помощью инструмента jsonnet.
