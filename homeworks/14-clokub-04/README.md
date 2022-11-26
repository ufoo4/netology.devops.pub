# Домашнее задание к занятию "14.4 Сервис-аккаунты"

## Задача 1: Работа с сервис-аккаунтами через утилиту kubectl в установленном minikube

Выполните приведённые команды в консоли. Получите вывод команд. Сохраните
задачу 1 как справочный материал.

### Как создать сервис-аккаунт?

```
kubectl create serviceaccount netology
```  
**Ответ:**  
```bash
❯ kubectl create serviceaccount netology
serviceaccount/netology created
```

### Как просмотреть список сервис-акаунтов?

```
kubectl get serviceaccounts
kubectl get serviceaccount
```  
**Ответ:**  
```bash
❯ kubectl get serviceaccounts
NAME       SECRETS   AGE
default    0         17h
netology   0         54s
❯ kubectl get serviceaccount
NAME       SECRETS   AGE
default    0         17h
netology   0         57s
```

### Как получить информацию в формате YAML и/или JSON?

```
kubectl get serviceaccount netology -o yaml
kubectl get serviceaccount default -o json
```  
**Ответ:**  
```yaml
❯ kubectl get serviceaccount netology -o yaml
apiVersion: v1
kind: ServiceAccount
metadata:
  creationTimestamp: "2022-11-26T09:36:09Z"
  name: netology
  namespace: default
  resourceVersion: "8013"
  uid: c3168735-d1fd-4a6d-b6cd-59b08507a536
```
```json
❯ kubectl get serviceaccount default -o json
{
    "apiVersion": "v1",
    "kind": "ServiceAccount",
    "metadata": {
        "creationTimestamp": "2022-11-25T16:04:10Z",
        "name": "default",
        "namespace": "default",
        "resourceVersion": "319",
        "uid": "d95a489e-8452-4560-956e-00f98aad190f"
    }
}
```

### Как выгрузить сервис-акаунты и сохранить его в файл?

```
kubectl get serviceaccounts -o json > serviceaccounts.json
kubectl get serviceaccount netology -o yaml > netology.yml
```  
**Ответ:**  
Получил 2 файла: [serviceaccounts.json](./src/serviceaccounts.json) и [netology.yml](./src/netology.yml)

### Как удалить сервис-акаунт?

```
kubectl delete serviceaccount netology
```  
**Ответ:**  
```bash
❯ kubectl delete serviceaccount netology
serviceaccount "netology" deleted
```

### Как загрузить сервис-акаунт из файла?

```
kubectl apply -f netology.yml
```  
**Ответ:**  
```bash
❯ kubectl apply -f netology.yml
serviceaccount/netology created
```

## Задача 2 (*): Работа с сервис-акаунтами внутри модуля

Выбрать любимый образ контейнера, подключить сервис-акаунты и проверить
доступность API Kubernetes

```
kubectl run -i --tty fedora --image=fedora --restart=Never -- sh
```

Просмотреть переменные среды

```
env | grep KUBE
```

Получить значения переменных

```
K8S=https://$KUBERNETES_SERVICE_HOST:$KUBERNETES_SERVICE_PORT
SADIR=/var/run/secrets/kubernetes.io/serviceaccount
TOKEN=$(cat $SADIR/token)
CACERT=$SADIR/ca.crt
NAMESPACE=$(cat $SADIR/namespace)
```

Подключаемся к API

```
curl -H "Authorization: Bearer $TOKEN" --cacert $CACERT $K8S/api/v1/
```

В случае с minikube может быть другой адрес и порт, который можно взять здесь

```
cat ~/.kube/config
```

или здесь

```
kubectl cluster-info
```
