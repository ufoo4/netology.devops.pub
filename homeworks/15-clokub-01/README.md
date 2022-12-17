# Домашнее задание к занятию "15.1. Организация сети"

Домашнее задание будет состоять из обязательной части, которую необходимо выполнить на провайдере Яндекс.Облако и дополнительной части в AWS по желанию. Все домашние задания в 15 блоке связаны друг с другом и в конце представляют пример законченной инфраструктуры.  
Все задания требуется выполнить с помощью Terraform, результатом выполненного домашнего задания будет код в репозитории. 

Перед началом работ следует настроить доступ до облачных ресурсов из Terraform используя материалы прошлых лекций и [ДЗ](https://github.com/netology-code/virt-homeworks/tree/master/07-terraform-02-syntax ). А также заранее выбрать регион (в случае AWS) и зону.

---
## Задание 1. Яндекс.Облако (обязательное к выполнению)

1. Создать VPC.
- Создать пустую VPC. Выбрать зону.
2. Публичная подсеть.
- Создать в vpc subnet с названием public, сетью 192.168.10.0/24.
- Создать в этой подсети NAT-инстанс, присвоив ему адрес 192.168.10.254. В качестве image_id использовать fd80mrhj8fl2oe87o4e1
- Создать в этой публичной подсети виртуалку с публичным IP и подключиться к ней, убедиться что есть доступ к интернету.
3. Приватная подсеть.
- Создать в vpc subnet с названием private, сетью 192.168.20.0/24.
- Создать route table. Добавить статический маршрут, направляющий весь исходящий трафик private сети в NAT-инстанс
- Создать в этой приватной подсети виртуалку с внутренним IP, подключиться к ней через виртуалку, созданную ранее и убедиться что есть доступ к интернету

Resource terraform для ЯО
- [VPC subnet](https://registry.terraform.io/providers/yandex-cloud/yandex/latest/docs/resources/vpc_subnet)
- [Route table](https://registry.terraform.io/providers/yandex-cloud/yandex/latest/docs/resources/vpc_route_table)
- [Compute Instance](https://registry.terraform.io/providers/yandex-cloud/yandex/latest/docs/resources/compute_instance)
---

**Ответ:**  
Манифест terrafirm'а находится [тут](./src/)  
Настройка yc опущу (было в прошлых лекциях). Применяю манифест терраформа ``terraform apply --auto-approve`  
Проверяю, что получилось:
```bash
❯ yc compute instance list
+----------------------+---------------+---------------+---------+----------------+----------------+
|          ID          |     NAME      |    ZONE ID    | STATUS  |  EXTERNAL IP   |  INTERNAL IP   |
+----------------------+---------------+---------------+---------+----------------+----------------+
| fhmdmafuvu2n4jo6dq2n | node-internal | ru-central1-a | RUNNING |                | 192.168.20.4   |
| fhmg62sp82vfdrps204k | nat-instance  | ru-central1-a | RUNNING | 158.160.46.247 | 192.168.10.254 |
| fhmklcatfcdu3056c2op | node-external | ru-central1-a | RUNNING | 84.201.130.50  | 192.168.10.30  |
+----------------------+---------------+---------------+---------+----------------+----------------+
❯ yc vpc gateway list
+----------------------+--------------+-------------+
|          ID          |     NAME     | DESCRIPTION |
+----------------------+--------------+-------------+
| enpkq1jgpj9noj3s58qm | nat-instance |             |
+----------------------+--------------+-------------+
❯ yc vpc network list
+----------------------+------+
|          ID          | NAME |
+----------------------+------+
| enpfpodkvt7bd4ukde8m | net  |
+----------------------+------+
❯ yc vpc network list-subnets --name net
+----------------------+---------+----------------------+----------------------+----------------------+---------------+-------------------+
|          ID          |  NAME   |      FOLDER ID       |      NETWORK ID      |    ROUTE TABLE ID    |     ZONE      |       RANGE       |
+----------------------+---------+----------------------+----------------------+----------------------+---------------+-------------------+
| e9b28vvc3085h108sf45 | public  | b1g27gpcstr1l1bi3a22 | enpfpodkvt7bd4ukde8m |                      | ru-central1-a | [192.168.10.0/24] |
| e9bv45f9ucvmemam93kj | private | b1g27gpcstr1l1bi3a22 | enpfpodkvt7bd4ukde8m | enpk02dacovht9q7nns8 | ru-central1-a | [192.168.20.0/24] |
+----------------------+---------+----------------------+----------------------+----------------------+---------------+-------------------+
❯ yc vpc network list-route-tables --name net
+----------------------+--------------+----------------------+----------------------+
|          ID          |     NAME     |      FOLDER ID       |      NETWORK ID      |
+----------------------+--------------+----------------------+----------------------+
| enpk02dacovht9q7nns8 | private-inet | b1g27gpcstr1l1bi3a22 | enpfpodkvt7bd4ukde8m |
+----------------------+--------------+----------------------+----------------------+
```
Захожу на ВМ и проверяю доступ к интернету.  
```bash
❯ ssh centos@84.201.130.50
[centos@node-external ~]$ ssh centos@192.168.20.4
[centos@node-internal ~]$ 
[centos@node-internal ~]$ ping netology.ru
PING netology.ru (188.114.99.224) 56(84) bytes of data.
64 bytes from 188.114.99.224 (188.114.99.224): icmp_seq=1 ttl=61 time=14.4 ms
64 bytes from 188.114.99.224 (188.114.99.224): icmp_seq=2 ttl=61 time=8.70 ms
64 bytes from 188.114.99.224 (188.114.99.224): icmp_seq=3 ttl=61 time=3.81 ms
^C
--- netology.ru ping statistics ---
3 packets transmitted, 3 received, 0% packet loss, time 2003ms
rtt min/avg/max/mdev = 3.814/8.981/14.425/4.337 ms
[centos@node-internal ~]$ 
```

Закончили упражнение: `terraform destroy --auto-approve`