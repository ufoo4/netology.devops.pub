# Домашнее задание к занятию "12.2 Команды для работы с Kubernetes"
Кластер — это сложная система, с которой крайне редко работает один человек. Квалифицированный devops умеет наладить работу всей команды, занимающейся каким-либо сервисом.
После знакомства с кластером вас попросили выдать доступ нескольким разработчикам. Помимо этого требуется служебный аккаунт для просмотра логов.

## Задание 1: Запуск пода из образа в деплойменте
Для начала следует разобраться с прямым запуском приложений из консоли. Такой подход поможет быстро развернуть инструменты отладки в кластере. Требуется запустить деплоймент на основе образа из hello world уже через deployment. Сразу стоит запустить 2 копии приложения (replicas=2). 

Требования:
 * пример из hello world запущен в качестве deployment
 * количество реплик в deployment установлено в 2
 * наличие deployment можно проверить командой kubectl get deployment
 * наличие подов можно проверить командой kubectl get pods

**Ответ:**  
Запускаю minikube, создаю [deployment](./src/helloworld-deployment.yml), проверяю, что получилось
```bash
[gnoy@manjarokde-ws01 ~]$ minikube start
😄  minikube v1.26.1 на Arch 21.3.7
✨  Automatically selected the docker driver. Other choices: virtualbox, ssh
📌  Using Docker driver with root privileges
👍  Запускается control plane узел minikube в кластере minikube
🚜  Скачивается базовый образ ...
💾  Скачивается Kubernetes v1.24.3 ...
    > preloaded-images-k8s-v18-v1...:  405.75 MiB / 405.75 MiB  100.00% 19.55 M
🔥  Creating docker container (CPUs=2, Memory=2200MB) ...
🐳  Подготавливается Kubernetes v1.24.3 на Docker 20.10.17 ...
    ▪ Generating certificates and keys ...
    ▪ Booting up control plane ...
    ▪ Configuring RBAC rules ...
🔎  Компоненты Kubernetes проверяются ...
    ▪ Используется образ gcr.io/k8s-minikube/storage-provisioner:v5
🌟  Включенные дополнения: default-storageclass, storage-provisioner
🏄  Готово! kubectl настроен для использования кластера "minikube" и "default" пространства имён по умолчанию
gnoy@manjarokde-ws01 src]$ kubectl apply -f helloworld-deployment.yml 
deployment.apps/hello-world-deployment created
[gnoy@manjarokde-ws01 src]$ kubectl get pods
NAME                                      READY   STATUS    RESTARTS   AGE
hello-world-deployment-7d598446cb-2pkqf   1/1     Running   0          57s
hello-world-deployment-7d598446cb-dn9lc   1/1     Running   0          57s
```

## Задание 2: Просмотр логов для разработки
Разработчикам крайне важно получать обратную связь от штатно работающего приложения и, еще важнее, об ошибках в его работе. 
Требуется создать пользователя и выдать ему доступ на чтение конфигурации и логов подов в app-namespace.

Требования: 
 * создан новый токен доступа для пользователя
 * пользователь прописан в локальный конфиг (~/.kube/config, блок users)
 * пользователь может просматривать логи подов и их конфигурацию (kubectl logs pod <pod_id>, kubectl describe pod <pod_id>)

**Ответ:**  
Создаю сервисный аккаунт, роль и привязываю роль к сервисному аккаунту:
Конфиги:
```yml
---
apiVersion: v1
kind: ServiceAccount
metadata:
  name: loguser
  namespace: default
```
```yml
---
apiVersion: rbac.authorization.k8s.io/v1
kind: Role
metadata:
  name: loguser-role
  namespace: default
rules:
- apiGroups: [""]
  resources: ["pods", "pods/log"]
  verbs: ["get", "list", "describe", "logs"]
```
```yml
---
apiVersion: rbac.authorization.k8s.io/v1
kind: RoleBinding
metadata:
  name: pods-logs
  namespace: default
subjects:
- kind: ServiceAccount
  name: loguser
  namespace: default
roleRef:
  kind: Role
  name: loguser-role
  apiGroup: rbac.authorization.k8s.io
```
Применяю:
```bash
[gnoy@manjarokde-ws01 src]$ kubectl apply -f account.yml 
serviceaccount/loguser created
[gnoy@manjarokde-ws01 src]$ kubectl apply -f role.yml 
role.rbac.authorization.k8s.io/loguser-role created
[gnoy@manjarokde-ws01 src]$ kubectl apply -f role-binding.yml 
rolebinding.rbac.authorization.k8s.io/pods-logs created
```
Получил связку сервисный аккаунт-роль-неймспейс. Тем самым при обращении к kube-api в нейсмпейсе от имени сервисного акканта появляется возможность использовать get, list, describe, logs для ресурсов pods и подресурса pods/logs.

Для проверки вызову список подов в неймспейсе default от имени сервисного аккаунта, используя конструкцию --as=system:serviceaccount:{namespace}:{user}
```bash
[gnoy@manjarokde-ws01 src]$ kubectl get pods --as=system:serviceaccount:default:loguser
NAME                                      READY   STATUS    RESTARTS   AGE
hello-world-deployment-7d598446cb-97z7n   1/1     Running   0          13m
hello-world-deployment-7d598446cb-vzwq4   1/1     Running   0          13m
```
Попробую получить список всех секретов в том же самом неймспейсе:
```bash
[gnoy@manjarokde-ws01 src]$ kubectl -n default get secrets --as=system:serviceaccount:default:loguser
Error from server (Forbidden): secrets is forbidden: User "system:serviceaccount:default:loguser" cannot list resource "secrets" in API group "" in the namespace "default"
```
Cписок POD-ов:
```bash
[gnoy@manjarokde-ws01 src]$ kubectl get pods --as=system:serviceaccount:default:loguser
NAME                                      READY   STATUS    RESTARTS   AGE
hello-world-deployment-7d598446cb-97z7n   1/1     Running   0          7m9s
hello-world-deployment-7d598446cb-vzwq4   1/1     Running   0          7m9s
```
Проверяю логи с подов:
```bash
[gnoy@manjarokde-ws01 src]$ kubectl logs -n default -l app=hello-world-deployment  --all-containers=true --as=system:serviceaccount:default:loguser
172.17.0.1 - - [28/Aug/2022:07:35:27 +0000] "GET / HTTP/1.1" 200 783 "-" "Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/104.0.5112.102 Safari/537.36 Edg/104.0.1293.63"
172.17.0.1 - - [28/Aug/2022:07:35:27 +0000] "GET /favicon.ico HTTP/1.1" 200 742 "http://192.168.49.2:31378/" "Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/104.0.5112.102 Safari/537.36 Edg/104.0.1293.63"
```
Работает!


## Задание 3: Изменение количества реплик 
Поработав с приложением, вы получили запрос на увеличение количества реплик приложения для нагрузки. Необходимо изменить запущенный deployment, увеличив количество реплик до 5. Посмотрите статус запущенных подов после увеличения реплик. 

Требования:
 * в deployment из задания 1 изменено количество реплик на 5
 * проверить что все поды перешли в статус running (kubectl get pods)

**Ответ:**  
Конфиг деплоймента исправлять не буду. Просто заскалирую количество подов до 5 штук:
```bash
[gnoy@manjarokde-ws01 src]$ kubectl scale deployment hello-world-deployment --replicas=5
deployment.apps/hello-world-deployment scaled
```
Проверяю:
```bash
[gnoy@manjarokde-ws01 src]$ kubectl get pods
NAME                                      READY   STATUS    RESTARTS   AGE
hello-world-deployment-7d598446cb-97z7n   1/1     Running   0          30m
hello-world-deployment-7d598446cb-9btdz   1/1     Running   0          17s
hello-world-deployment-7d598446cb-dhb2q   1/1     Running   0          17s
hello-world-deployment-7d598446cb-rg2kw   1/1     Running   0          17s
hello-world-deployment-7d598446cb-vzwq4   1/1     Running   0          30m
```