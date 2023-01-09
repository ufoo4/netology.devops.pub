# Домашнее задание к занятию 15.2 "Вычислительные мощности. Балансировщики нагрузки".
Домашнее задание будет состоять из обязательной части, которую необходимо выполнить на провайдере Яндекс.Облако, и дополнительной части в AWS (можно выполнить по желанию). Все домашние задания в 15 блоке связаны друг с другом и в конце представляют пример законченной инфраструктуры.
Все задания требуется выполнить с помощью Terraform, результатом выполненного домашнего задания будет код в репозитории. Перед началом работ следует настроить доступ до облачных ресурсов из Terraform, используя материалы прошлых лекций и ДЗ.

---
## Задание 1. Яндекс.Облако (обязательное к выполнению)

1. Создать bucket Object Storage и разместить там файл с картинкой:
- Создать bucket в Object Storage с произвольным именем (например, _имя_студента_дата_);
- Положить в bucket файл с картинкой;
- Сделать файл доступным из Интернет.
2. Создать группу ВМ в public подсети фиксированного размера с шаблоном LAMP и web-страничкой, содержащей ссылку на картинку из bucket:
- Создать Instance Group с 3 ВМ и шаблоном LAMP. Для LAMP рекомендуется использовать `image_id = fd827b91d99psvq5fjit`;
- Для создания стартовой веб-страницы рекомендуется использовать раздел `user_data` в [meta_data](https://cloud.yandex.ru/docs/compute/concepts/vm-metadata);
- Разместить в стартовой веб-странице шаблонной ВМ ссылку на картинку из bucket;
- Настроить проверку состояния ВМ.
3. Подключить группу к сетевому балансировщику:
- Создать сетевой балансировщик;
- Проверить работоспособность, удалив одну или несколько ВМ.
4. *Создать Application Load Balancer с использованием Instance group и проверкой состояния.

Документация
- [Compute instance group](https://registry.terraform.io/providers/yandex-cloud/yandex/latest/docs/resources/compute_instance_group)
- [Network Load Balancer](https://registry.terraform.io/providers/yandex-cloud/yandex/latest/docs/resources/lb_network_load_balancer)
- [Группа ВМ с сетевым балансировщиком](https://cloud.yandex.ru/docs/compute/operations/instance-groups/create-with-balancer)
---

**Ответ:**  
Все конфигурационные файлы [ТУТ](./src/)  
Прокатываю tf. вывод в консоль:
```bash
Apply complete! Resources: 15 added, 0 changed, 0 destroyed.

Outputs:

external_ip_address_nat-instance = "62.84.112.234"
external_ip_address_node-external = "62.84.112.16"
internal_ip_address_nat-instance = "192.168.10.254"
internal_ip_address_node-external = "192.168.10.24"
internal_ip_address_node-internal = "192.168.20.30"
lamp_balancer_ip_address = [
  tolist([
    tolist([
      "51.250.14.11",
    ]),
  ]),
]
lamp_nodes_ip_address = [
  tolist([
    "192.168.10.25",
    "192.168.10.11",
    "192.168.10.33",
  ]),
]
```
Проверяю созданные ВМ'ки:  
```bash
❯ yc compute instance list
+----------------------+---------------------------+---------------+---------+---------------+----------------+
|          ID          |           NAME            |    ZONE ID    | STATUS  |  EXTERNAL IP  |  INTERNAL IP   |
+----------------------+---------------------------+---------------+---------+---------------+----------------+
| fhm2ja8c5ql9ncghj06l | cl1rci1u3s7m95aev5cd-edyj | ru-central1-a | RUNNING |               | 192.168.10.11  |
| fhm2m2euitqu0iiej4el | cl1rci1u3s7m95aev5cd-ynob | ru-central1-a | RUNNING |               | 192.168.10.25  |
| fhm3u6dkfm1r0nj5982k | node-external             | ru-central1-a | RUNNING | 62.84.112.16  | 192.168.10.24  |
| fhm6jrt02kku0da84hdd | s-cored                   | ru-central1-a | RUNNING | 51.250.9.170  | 10.10.10.20    |
| fhm9vbans15if4kru640 | nat-instance              | ru-central1-a | RUNNING | 62.84.112.234 | 192.168.10.254 |
| fhmas5r78olksfun8t6a | node-internal             | ru-central1-a | RUNNING |               | 192.168.20.30  |
| fhmr8vtrcsurqveibhhn | cl1rci1u3s7m95aev5cd-ucyk | ru-central1-a | RUNNING |               | 192.168.10.33  |
+----------------------+---------------------------+---------------+---------+---------------+----------------+
```
Проверяю балансировщик и таргет-группу:
```bash
❯ yc load-balancer target-group list
+----------------------+-------------------+---------------------+-------------+--------------+
|          ID          |       NAME        |       CREATED       |  REGION ID  | TARGET COUNT |
+----------------------+-------------------+---------------------+-------------+--------------+
| enpg6tm9hl7bvouph38h | lamp-target-group | 2023-01-09 19:15:27 | ru-central1 |            3 |
+----------------------+-------------------+---------------------+-------------+--------------+
❯ yc load-balancer network-load-balancer list
+----------------------+----------------------------+-------------+----------+----------------+------------------------+--------+
|          ID          |            NAME            |  REGION ID  |   TYPE   | LISTENER COUNT | ATTACHED TARGET GROUPS | STATUS |
+----------------------+----------------------------+-------------+----------+----------------+------------------------+--------+
| enp0306267ec59p7h812 | lamp-network-load-balancer | ru-central1 | EXTERNAL |              1 | enpg6tm9hl7bvouph38h   | ACTIVE |
+----------------------+----------------------------+-------------+----------+----------------+------------------------+--------+
```
Проверяю HEALTHY-статус у таргет-группы:
```bash
❯ yc load-balancer network-load-balancer target-states lamp-network-load-balancer --target-group-id enpg6tm9hl7bvouph38h
+----------------------+---------------+---------+
|      SUBNET ID       |    ADDRESS    | STATUS  |
+----------------------+---------------+---------+
| e9bq1qbgkf7nllbjdikl | 192.168.10.11 | HEALTHY |
| e9bq1qbgkf7nllbjdikl | 192.168.10.25 | HEALTHY |
| e9bq1qbgkf7nllbjdikl | 192.168.10.33 | HEALTHY |
+----------------------+---------------+---------+
```
curl'ыкаю до балансира, проверяю ответ:
```bash
❯ curl 51.250.14.11
<!DOCTYPE html>
  <html lang="en">
    <head>
      <meta charset="utf-8">
      <title>my-site</title>
    </head>
    <body>
      <h3>Hi!</h3> <br>
      <big><big>Web-server:</big></big> <br>
      192.168.10.33      <br>
      <img src="https://storage.yandexcloud.net/gny-201222/avatar" alt="avatar" />
    </body>
  </html>
```
Удалю ВМ'ку c ip-адресом 192.168.10.33, вновь проверю результат:
```bash
❯ yc compute instance delete --name cl1rci1u3s7m95aev5cd-ucyk
done (25s)
❯ curl 51.250.14.11
<!DOCTYPE html>
  <html lang="en">
    <head>
      <meta charset="utf-8">
      <title>my-site</title>
    </head>
    <body>
      <h3>Hi!</h3> <br>
      <big><big>Web-server:</big></big> <br>
      192.168.10.25      <br>
      <img src="https://storage.yandexcloud.net/gny-201222/avatar" alt="avatar" />
    </body>
  </html>
```
Как видно из ответа на curl - отвечающие ноды за балансиром меняются (судя по ip-адресу).  
Дополнительно [СКРИНШОТ](./src/img/web-server.png) из браузера.  
Закончили упражнение, дестрою инфру: `terraform destroy --auto-approve`
