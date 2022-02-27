# Домашнее задание к занятию "3.6. Компьютерные сети, лекция 1"

1. Работа c HTTP через телнет.
- Подключитесь утилитой телнет к сайту stackoverflow.com
`telnet stackoverflow.com 80`
- отправьте HTTP запрос
```bash
GET /questions HTTP/1.0
HOST: stackoverflow.com
[press enter]
[press enter]
```
- В ответе укажите полученный HTTP код, что он означает?  
Ответ: Описание сделаю прямо в листинге.
```bash
gnoy@LAPTOP-CHVMGVOQ:~$ telnet stackoverflow.com 80
Trying 151.101.1.69...
Connected to stackoverflow.com.
Escape character is '^]'.
GET /questions HTTP/1.0
HOST: stackoverflow.com

HTTP/1.1 301 Moved Permanently #Ответ сервера о перенаправлении
cache-control: no-cache, no-store, must-revalidate #Данные о кеше
location: https://stackoverflow.com/questions #Местоназначение при перенаправлении
x-request-guid: 293f916f-fe67-424f-ba31-ae68d48bc518 #Этот идентификатор сервер включает в каждый оператор журнала. Необходим что бы не полагаться на IP-адреса временных меток и т.д
feature-policy: microphone 'none'; speaker 'none' # Позволяет выборочно включать, отключать и изменять поведение определенных функций и API в браузере
content-security-policy: upgrade-insecure-requests; frame-ancestors 'self' https://stackexchange.com #Политика безопасности контента. Уровень безопасности, который помогает обнаруживать и смягчать определенные типы атак
Accept-Ranges: bytes #Маркер. Используемым сервером , чтобы рекламировать свою поддержку частичных запросов от клиента для загрузки файлов
Date: Sat, 27 Nov 2021 15:55:06 GMT #Дата запроса
Via: 1.1 varnish #Используется для отслеживания пересылки сообщений, предотвращения зацикливания запросов
Connection: close #Состояние по умолчанию после отдачи контента
X-Served-By: cache-fra19168-FRA #Идентификационные данные серверов Fastly cache, обрабатывающих ответ
X-Cache: MISS #Указывает, был ли запрос HIT или MISS 
X-Cache-Hits: 0 #Список с указанием количества попаданий в кеш на узле
X-Timer: S1638028506.362955,VS0,VE92 #Информация о времени ответа
Vary: Fastly-SSL #Добавляет указанные заголовки запроса в ключ кеша для ресурса
X-DNS-Prefetch-Control: off #Функция, с помощью котороцй браузеры выполняют разрешение доменных имен
Set-Cookie: prov=cbc3d3cc-c057-ef37-832c-cb02f56915cc; domain=.stackoverflow.com; expires=Fri, 01-Jan-2055 00:00:00 GMT; path=/; HttpOnly #Используется для отправки coocie с сервера пользователю

Connection closed by foreign host. #Закрытие коннекта с сервером
```
2. Повторите задание 1 в браузере, используя консоль разработчика F12.
- откройте вкладку `Network`
- отправьте запрос http://stackoverflow.com
- найдите первый ответ HTTP сервера, откройте вкладку `Headers`
- укажите в ответе полученный HTTP код.
- проверьте время загрузки страницы, какой запрос обрабатывался дольше всего?
- приложите скриншот консоли браузера в ответ.
Ответ:
```bash
Заголовки ответов:
accept-ranges: bytes
cache-control: private
content-encoding: gzip
content-security-policy: upgrade-insecure-requests; frame-ancestors 'self' https://stackexchange.com
content-type: text/html; charset=utf-8
date: Sun, 28 Nov 2021 06:11:18 GMT
feature-policy: microphone 'none'; speaker 'none'
strict-transport-security: max-age=15552000
vary: Accept-Encoding,Fastly-SSL
via: 1.1 varnish
x-cache: MISS
x-cache-hits: 0
x-dns-prefetch-control: off
x-frame-options: SAMEORIGIN
x-request-guid: b0b29783-faec-411b-893e-b349f27fbb07
x-served-by: cache-fra19181-FRA
x-timer: S1638079878.316442,VS0,VE96

Заголовки запросов:
:authority: stackoverflow.com
:method: GET
:path: /
:scheme: https
accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.9
accept-encoding: gzip, deflate, br
accept-language: ru,en-US;q=0.9,en;q=0.8
cache-control: max-age=0
cookie: prov=0e43034f-217c-771a-ed4e-4779e3fd5269; _ga=GA1.2.1181635200.1634890171; _gid=GA1.2.141015999.1638002250
sec-ch-ua: " Not A;Brand";v="99", "Chromium";v="96", "Google Chrome";v="96"
sec-ch-ua-mobile: ?0
sec-ch-ua-platform: "Windows"
sec-fetch-dest: document
sec-fetch-mode: navigate
sec-fetch-site: none
sec-fetch-user: ?1
upgrade-insecure-requests: 1
user-agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/96.0.4664.45 Safari/537.36
```
Самый долгий запрос, который был обработан (111мс)
```bash
https://www.google-analytics.com/j/collect?v=1&_v=j96&a=657622818&t=pageview&_s=1&dl=https://stackoverflow.com/&dp=/&ul=ru&de=UTF-8&dt=Stack Overflow - Where Developers Learn, Share, & Build Careers&sd=24-bit&sr=1920x1080&vp=1903x267&je=0&_u=SCCACEABFAAAAC~&jid=603834798&gjid=903806306&cid=1181635200.1634890171&tid=UA-108242619-1&_gid=141015999.1638002250&_r=1&cd42=1&cd3=Home/Index&cd7=1638080221.753643167&cd6=1181635200.1634890171&cd8=2021-11-28T06:17:01.604+05:00&cd11=https://stackoverflow.com/&z=347697250
```
Скриншот консоли браузера:
![console-screenshot](https://github.com/gnoy4eg/netology.devops.pub/blob/main/img/console.png)
3. Какой IP адрес у вас в интернете?  
Ответ:
```bash
gnoy@LAPTOP-CHVMGVOQ:~$ wget -qO- ifconfig.co
92.xxx.xxx.8
```
4. Какому провайдеру принадлежит ваш IP адрес? Какой автономной системе AS? Воспользуйтесь утилитой `whois`  
Ответ: Мой провайдер MKS Chelyabinsk Customers' Network (МТС), Автономная система - AS28832
```bash
gnoy@LAPTOP-CHVMGVOQ:~$ whois -h whois.radb.net 92.ххх.ххх.8
route:          92.ххх.ххх.0/23
descr:          MKS Chelyabinsk Customers' Network
origin:         AS28832
mnt-by:         UTC-MNT
notify:         lir.ural@mts.ru
created:        2014-01-15T07:37:07Z
last-modified:  2020-11-12T11:15:44Z
source:         RIPE
remarks:        ****************************
remarks:        * THIS OBJECT IS MODIFIED
remarks:        * Please note that all data that is generally regarded as personal
remarks:        * data has been removed from this object.
remarks:        * To view the original object, please query the RIPE Database at:
remarks:        * http://www.ripe.net/whois
remarks:        ****************************

```
5. Через какие сети проходит пакет, отправленный с вашего компьютера на адрес 8.8.8.8? Через какие AS? Воспользуйтесь утилитой `traceroute`  
Ответ:
```bash
gnoy@LAPTOP-CHVMGVOQ:~$ traceroute -An 8.8.8.8
traceroute to 8.8.8.8 (8.8.8.8), 30 hops max, 60 byte packets
 1  172.30.16.1 [*]  0.357 ms  0.276 ms  0.270 ms
 2  192.168.1.1 [*]  4.783 ms  2.939 ms  4.746 ms
 3  92.xxx.xxx.1 [AS28832]  8.690 ms  8.542 ms  8.536 ms
 4  10.221.128.33 [*]  17.366 ms  17.258 ms  17.156 ms
 5  212.188.22.97 [AS8359]  6.915 ms  6.908 ms  8.466 ms
 6  212.188.0.61 [AS8359]  8.219 ms  6.150 ms  6.111 ms
 7  212.188.42.129 [AS8359]  36.669 ms  36.697 ms  36.266 ms
 8  212.188.29.25 [AS8359]  37.700 ms  41.584 ms  41.580 ms
 9  195.34.50.74 [AS8359]  36.308 ms  36.586 ms  36.281 ms
10  212.188.29.82 [AS8359]  36.128 ms  36.623 ms  36.792 ms
11  108.170.250.34 [AS15169]  36.918 ms 108.170.250.130 [AS15169]  36.594 ms  35.879 ms
12  142.250.239.64 [AS15169]  50.203 ms * 142.251.49.24 [AS15169]  50.047 ms
13  209.85.254.6 [AS15169]  52.851 ms 72.14.235.69 [AS15169]  53.541 ms 72.14.238.168 [AS15169]  50.053 ms
14  172.253.79.237 [AS15169]  50.053 ms 172.253.51.187 [AS15169]  53.543 ms  52.834 ms
15  * * *
16  * * *
17  * * *
18  * * *
19  * * *
20  * * *
21  * * *
22  * * *
23  * * *
24  8.8.8.8 [AS15169]  52.710 ms  52.700 ms *
```
6. Повторите задание 5 в утилите `mtr`. На каком участке наибольшая задержка - delay?  
Ответ: Правильнее учитывать среднее значение задержки. В моем случае это 14 хоп 142.250.56.129 (54.8мс)
```bash
                         My traceroute  [v0.93]
LAPTOP-CHVMGVOQ (172.30.29.227)                  2021-11-28T11:45:14+0500
Keys:  Help   Display mode   Restart statistics   Order of fields   quit
                                 Packets               Pings
 Host                          Loss%   Snt   Last   Avg  Best  Wrst StDev
 1. AS???    172.30.16.1        0.0%   102    0.6   0.5   0.3   0.9   0.1
 2. AS???    192.168.1.1        0.0%   102    2.4   4.6   2.1  23.4   4.1
 3. AS28832  92.xxx.xx.1        0.0%   102    3.7   6.5   3.4  26.2   4.5
 4. AS???    10.221.128.33      0.0%   102    4.2   7.8   3.7  30.1   5.8
 5. AS8359   212.188.22.97      0.0%   102    4.2   7.0   3.4  28.7   5.9
 6. AS8359   212.188.0.61       1.0%   101    8.3   8.7   4.7  30.3   4.8
 7. AS8359   212.188.42.129     0.0%   101   36.0  42.3  35.3 121.9  12.3
 8. AS8359   212.188.29.25      1.0%   101   35.7  38.4  34.9  51.6   3.7
 9. AS8359   195.34.50.74       0.0%   101   35.6  37.1  34.7  55.1   3.8
10. AS8359   212.188.29.82      0.0%   101   35.6  37.4  34.8  56.9   3.7
11. AS15169  108.170.250.130    0.0%   101   35.2  37.5  34.5  55.6   3.7
12. AS15169  209.85.255.136     0.0%   101   53.4  55.7  52.5  88.3   5.3
13. AS15169  209.85.254.20      0.0%   101   52.1  54.7  51.4  76.8   5.0
14. AS15169  142.250.56.129     0.0%   101   52.8  54.8  51.6  71.2   4.1
15. (waiting for reply)
16. (waiting for reply)
17. (waiting for reply)
18. (waiting for reply)
19. (waiting for reply)
20. (waiting for reply)
21. (waiting for reply)
22. (waiting for reply)
23. (waiting for reply)
24. AS15169  8.8.8.8           11.9%   101   50.9  53.4  50.7  77.0   4.6


```
7. Какие DNS сервера отвечают за доменное имя dns.google? Какие A записи? воспользуйтесь утилитой `dig`  
Ответ: Отвечают две A-записи: 8.8.8.8 и 8.8.4.4
```bash
gnoy@LAPTOP-CHVMGVOQ:~$ dig dns.google

; <<>> DiG 9.16.1-Ubuntu <<>> dns.google
;; global options: +cmd
;; Got answer:
;; ->>HEADER<<- opcode: QUERY, status: NOERROR, id: 26505
;; flags: qr rd ad; QUERY: 1, ANSWER: 2, AUTHORITY: 0, ADDITIONAL: 0
;; WARNING: recursion requested but not available

;; QUESTION SECTION:
;dns.google.                    IN      A

;; ANSWER SECTION:
dns.google.             0       IN      A       8.8.8.8
dns.google.             0       IN      A       8.8.4.4

;; Query time: 0 msec
;; SERVER: 172.30.16.1#53(172.30.16.1)
;; WHEN: Sun Nov 28 11:58:12 +05 2021
;; MSG SIZE  rcvd: 70
```
8. Проверьте PTR записи для IP адресов из задания 7. Какое доменное имя привязано к IP? воспользуйтесь утилитой `dig`  
Ответ: Привязанное имя dns.google.
```bash
gnoy@LAPTOP-CHVMGVOQ:~$ dig -x 8.8.8.8

; <<>> DiG 9.16.1-Ubuntu <<>> -x 8.8.8.8
;; global options: +cmd
;; Got answer:
;; ->>HEADER<<- opcode: QUERY, status: NOERROR, id: 13867
;; flags: qr rd ad; QUERY: 1, ANSWER: 1, AUTHORITY: 0, ADDITIONAL: 0
;; WARNING: recursion requested but not available

;; QUESTION SECTION:
;8.8.8.8.in-addr.arpa.          IN      PTR

;; ANSWER SECTION:
8.8.8.8.in-addr.arpa.   0       IN      PTR     dns.google.

;; Query time: 0 msec
;; SERVER: 172.30.16.1#53(172.30.16.1)
;; WHEN: Sun Nov 28 11:56:05 +05 2021
;; MSG SIZE  rcvd: 82

gnoy@LAPTOP-CHVMGVOQ:~$ dig -x 8.8.4.4

; <<>> DiG 9.16.1-Ubuntu <<>> -x 8.8.4.4
;; global options: +cmd
;; Got answer:
;; ->>HEADER<<- opcode: QUERY, status: NOERROR, id: 41574
;; flags: qr rd ad; QUERY: 1, ANSWER: 1, AUTHORITY: 0, ADDITIONAL: 0
;; WARNING: recursion requested but not available

;; QUESTION SECTION:
;4.4.8.8.in-addr.arpa.          IN      PTR

;; ANSWER SECTION:
4.4.8.8.in-addr.arpa.   0       IN      PTR     dns.google.

;; Query time: 10 msec
;; SERVER: 172.30.16.1#53(172.30.16.1)
;; WHEN: Sun Nov 28 11:56:14 +05 2021
;; MSG SIZE  rcvd: 82

```

В качестве ответов на вопросы можно приложите лог выполнения команд в консоли или скриншот полученных результатов.

