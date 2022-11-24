# Домашнее задание к занятию "14.2 Синхронизация секретов с внешними сервисами. Vault"

## Задача 1: Работа с модулем Vault

Запустить модуль Vault конфигураций через утилиту kubectl в установленном minikube

```
kubectl apply -f 14.2/vault-pod.yml
```  
**Ответ:**  
```bash
❯ kubectl apply -f vault-pod.yml
pod/14.2-netology-vault created
```
Получить значение внутреннего IP пода

```
kubectl get pod 14.2-netology-vault -o json | jq -c '.status.podIPs'
```
Примечание: jq - утилита для работы с JSON в командной строке  
**Ответ:**  
```bash
❯ kubectl get pod 14.2-netology-vault -o json | jq -c '.status.podIPs'
[{"ip":"172.17.0.3"}]
```

Запустить второй модуль для использования в качестве клиента

```
kubectl run -i --tty fedora --image=fedora --restart=Never -- sh
```
  
**Ответ:**  
```bash
❯ kubectl run -i --tty fedora --image=fedora --restart=Never -- sh
If you don't see a command prompt, try pressing enter.
sh-5.1#
```

Установить дополнительные пакеты

```
dnf -y install pip
pip install hvac
```

Запустить интепретатор Python и выполнить следующий код, предварительно
поменяв IP и токен

```
import hvac
client = hvac.Client(
    url='http://172.17.0.3:8200',
    token='aiphohTaa0eeHei'
)
client.is_authenticated()

# Пишем секрет
client.secrets.kv.v2.create_or_update_secret(
    path='hvac',
    secret=dict(netology='Big secret!!!'),
)

# Читаем секрет
client.secrets.kv.v2.read_secret_version(
    path='hvac',
)
```
  
**Ответ:**  
```python
>>> import hvac
>>> client = hvac.Client(
...     url='http://172.17.0.3:8200',
phohTaa0eeHei'...     token='aiphohTaa0eeHei'
... )
>>> client.is_authenticated()
рет
client.secTrue
>>>
>>> # Пишем секрет
>>> client.secrets.kv.v2.create_or_update_secret(
...     path='hvac',
...     secret=dict(netology='Big secret!!!'),
... )
{'request_id': '8563857b-49f8-69d0-49d4-a35c46f979b2', 'lease_id': '', 'renewable': False, 'lease_duration': 0, 'data': {'created_time': '2022-11-24T19:25:22.94241484Z', 'custom_metadata': None, 'deletion_time': '', 'destroyed': False, 'version': 2}, 'wrap_info': None, 'warnings': None, 'auth': None}
>>>
>>> # Читаем секрет
crets.kv.v2.read>>> client.secrets.kv.v2.read_secret_version(
...     path='hvac',
... )
{'request_id': 'aa6fd0a3-2eab-d922-2a2d-eb00fb17e989', 'lease_id': '', 'renewable': False, 'lease_duration': 0, 'data': {'data': {'netology': 'Big secret!!!'}, 'metadata': {'created_time': '2022-11-24T19:25:22.94241484Z', 'custom_metadata': None, 'deletion_time': '', 'destroyed': False, 'version': 2}}, 'wrap_info': None, 'warnings': None, 'auth': None}
```

## Задача 2 (*): Работа с секретами внутри модуля

* На основе образа fedora создать модуль;
* Создать секрет, в котором будет указан токен;
* Подключить секрет к модулю;
* Запустить модуль и проверить доступность сервиса Vault.
