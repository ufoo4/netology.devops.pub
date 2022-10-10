# Домашнее задание к занятию "13.2 разделы и монтирование"
Приложение запущено и работает, но время от времени появляется необходимость передавать между бекендами данные. А сам бекенд генерирует статику для фронта. Нужно оптимизировать это.
Для настройки NFS сервера можно воспользоваться следующей инструкцией (производить под пользователем на сервере, у которого есть доступ до kubectl):
* установить helm: curl https://raw.githubusercontent.com/helm/helm/master/scripts/get-helm-3 | bash
* добавить репозиторий чартов: helm repo add stable https://charts.helm.sh/stable && helm repo update
* установить nfs-server через helm: helm install nfs-server stable/nfs-server-provisioner

В конце установки будет выдан пример создания PVC для этого сервера.

## Задание 1: подключить для тестового конфига общую папку
В stage окружении часто возникает необходимость отдавать статику бекенда сразу фронтом. Проще всего сделать это через общую папку. Требования:
* в поде подключена общая папка между контейнерами (например, /static);
* после записи чего-либо в контейнере с беком файлы можно получить из контейнера с фронтом.

**Ответ:**  
Выполнение текущего ДЗ буду выполнять на примере прошлого ДЗ [13-kubernetes-config-01-objects](../13-kubernetes-config-01-objects/).   
Модифицыровал [манифесты](./src/manifests/production/).   
Деплою в k8s, проверяю подключенную папку в обоих контейнерах:
```bash
❯ kubectl -n stage exec fr-ba-7f78fcc9c7-9q8cn -c fr -- ls -lh / | grep static
drwxrwxrwx.   2 root root    6 Oct 10 23:18 static
❯ kubectl -n stage exec fr-ba-7f78fcc9c7-9q8cn -c ba -- ls -lh / | grep static
drwxrwxrwx.   2 root root   6 Oct 10 23:18 static
```
Создам файл в контейнере frontend'а и проверю его содержимое в backend'е:
```bash
❯ kubectl -n stage exec fr-ba-7f78fcc9c7-9q8cn -c fr -- sh -c 'echo "Hello World! UP" > /static/HeWo.txt'
❯ kubectl -n stage exec fr-ba-7f78fcc9c7-9q8cn -c ba -- cat /static/HeWo.txt
Hello World! UP
```
Теперь дополню файл из контейнера backend'а и проверю его содержимое во frontend'е
```bash
❯ kubectl -n stage exec fr-ba-7f78fcc9c7-9q8cn -c ba -- sh -c 'echo "Hi World! ba->fr" >> /static/HeWo.txt'
❯ kubectl -n stage exec fr-ba-7f78fcc9c7-9q8cn -c fr -- cat /static/HeWo.txt
Hello World! UP
Hi World! ba->fr
```

## Задание 2: подключить общую папку для прода
Поработав на stage, доработки нужно отправить на прод. В продуктиве у нас контейнеры крутятся в разных подах, поэтому потребуется PV и связь через PVC. Сам PV должен быть связан с NFS сервером. Требования:
* все бекенды подключаются к одному PV в режиме ReadWriteMany;
* фронтенды тоже подключаются к этому же PV с таким же режимом;
* файлы, созданные бекендом, должны быть доступны фронту.

**Ответ:**  
Исправляю [манифесты](./src/manifests/production/). Деплою к k8s.   
Проверяю, что все запустилось:
```bash
❯ kubectl get po,pvc,pv -n production
NAME                      READY   STATUS    RESTARTS   AGE
pod/ba-5cc8999674-jvdrj   1/1     Running   0          7m8s
pod/fr-7b466b5477-f5chx   1/1     Running   0          7m1s

NAME                        STATUS   VOLUME                                     CAPACITY   ACCESS MODES   STORAGECLASS   AGE
persistentvolumeclaim/pvc   Bound    pvc-eb21fcf8-5bca-4e0b-a123-1465aadc84d9   500Mi      RWX            nfs            10m

NAME                                                        CAPACITY   ACCESS MODES   RECLAIM POLICY   STATUS   CLAIM            STORAGECLASS   REASON   AGE
persistentvolume/pvc-eb21fcf8-5bca-4e0b-a123-1465aadc84d9   500Mi      RWX            Delete           Bound    production/pvc   nfs                     10m
```
Создам файл в frontend'е и посмотрю его содержимое в backend'е:
```bash
❯ kubectl -n production exec fr-7b466b5477-f5chx -- sh -c 'echo "Hello World! nfs fr->ba" > /static/Hello.txt'
❯ kubectl -n production exec ba-5cc8999674-jvdrj -- sh -c "cat /static/Hello.txt"
Hello World! nfs fr->ba
```
Используя тот же принцип дополню файл из backend'а и проверю его из frontend'а:
```bash
❯ kubectl -n production exec ba-5cc8999674-jvdrj -- sh -c "echo 'Hi people! nfs ba->fr' >> /static/Hello.txt"
❯ kubectl -n production exec fr-7b466b5477-f5chx -- cat /static/Hello.txt
Hello World! nfs fr->ba
Hi people! nfs ba->fr
```
Работает. Закончили упражнение =)
