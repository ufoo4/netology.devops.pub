# Домашнее задание к занятию "14.3 Карты конфигураций"

## Задача 1: Работа с картами конфигураций через утилиту kubectl в установленном minikube

Выполните приведённые команды в консоли. Получите вывод команд. Сохраните
задачу 1 как справочный материал.

### Как создать карту конфигураций?

```
kubectl create configmap nginx-config --from-file=nginx.conf
kubectl create configmap domain --from-literal=name=netology.ru
```  
**Ответ:**  
```bash
❯ kubectl create configmap nginx-config --from-file=nginx.conf
configmap/nginx-config created
❯ kubectl create configmap domain --from-literal=name=netology.ru
configmap/domain created
```

### Как просмотреть список карт конфигураций?

```
kubectl get configmaps
kubectl get configmap
```  
**Ответ:**  
```bash
❯ kubectl get configmaps
NAME               DATA   AGE
domain             1      55s
kube-root-ca.crt   1      6m6s
nginx-config       1      66s
❯ kubectl get configmap
NAME               DATA   AGE
domain             1      60s
kube-root-ca.crt   1      6m11s
nginx-config       1      71s
```

### Как просмотреть карту конфигурации?

```
kubectl get configmap nginx-config
kubectl describe configmap domain
```  
**Ответ:**  
```bash
❯ kubectl get configmap nginx-config
NAME           DATA   AGE
nginx-config   1      90s
❯ kubectl describe configmap domain
Name:         domain
Namespace:    default
Labels:       <none>
Annotations:  <none>

Data
====
name:
----
netology.ru

BinaryData
====

Events:  <none>
```

### Как получить информацию в формате YAML и/или JSON?

```
kubectl get configmap nginx-config -o yaml
kubectl get configmap domain -o json
```  
**Ответ:**  
```yaml
❯ kubectl get configmap nginx-config -o yaml
apiVersion: v1
data:
  nginx.conf: |
    server {
        listen 80;
        server_name  netology.ru www.netology.ru;
        access_log  /var/log/nginx/domains/netology.ru-access.log  main;
        error_log   /var/log/nginx/domains/netology.ru-error.log info;
        location / {
            include proxy_params;
            proxy_pass http://10.10.10.10:8080/;
        }
    }
kind: ConfigMap
metadata:
  creationTimestamp: "2022-11-25T16:09:10Z"
  name: nginx-config
  namespace: default
  resourceVersion: "584"
  uid: 34d4b762-c69a-4d58-b8bd-aa7b3293b272
```
```json
❯ kubectl get configmap domain -o json
{
    "apiVersion": "v1",
    "data": {
        "name": "netology.ru"
    },
    "kind": "ConfigMap",
    "metadata": {
        "creationTimestamp": "2022-11-25T16:09:21Z",
        "name": "domain",
        "namespace": "default",
        "resourceVersion": "594",
        "uid": "706a8059-1479-437f-aa99-a202e27cc98b"
    }
}
```

### Как выгрузить карту конфигурации и сохранить его в файл?

```
kubectl get configmaps -o json > configmaps.json
kubectl get configmap nginx-config -o yaml > nginx-config.yml
```  
**Ответ:**  
Получил 2 файла: [configmaps.json](./src/configmaps.json) и [nginx-config.yml](./src/nginx-config.yml)

### Как удалить карту конфигурации?

```
kubectl delete configmap nginx-config
```  
**Ответ:**  
```bash
❯ kubectl delete configmap nginx-config
configmap "nginx-config" deleted
```

### Как загрузить карту конфигурации из файла?

```
kubectl apply -f nginx-config.yml
```  
**Ответ:**  
```bash
❯ kubectl apply -f nginx-config.yml
configmap/nginx-config created
```

## Задача 2 (*): Работа с картами конфигураций внутри модуля

Выбрать любимый образ контейнера, подключить карты конфигураций и проверить
их доступность как в виде переменных окружения, так и в виде примонтированного
тома
