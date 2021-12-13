# Домашнее задание к занятию "4.1. Командная оболочка Bash: Практические навыки"

## Обязательные задания

1. Есть скрипт:
    ```bash
    a=1
    b=2
    c=a+b
    d=$a+$b
    e=$(($a+$b))
    ```
    * Какие значения переменным c,d,e будут присвоены?
    * Почему?  
Ответ:  В скрипт дописал команду `echo` для просмотра результата, ответ в терминале получил такой:
```bash
gnoy@LAPTOP-CHVMGVOQ:/mnt/c/Users/Gnoy/PycharmProjects/netology.devops.pub/04-script-01-bash$ cat ./one.sh
#!/usr/bin/env bash
a=1
b=2
c=a+b
  echo c=$c
d=$a+$b
  echo d=$d
e=$(($a+$b))
  echo e=$e
gnoy@LAPTOP-CHVMGVOQ:/mnt/c/Users/Gnoy/PycharmProjects/netology.devops.pub/04-script-01-bash$ ./one.sh
c=a+b
d=1+2
e=3
```
Теперь попробуем ответить на вопрос "почему?":  
* c: Впререди значений `a` и `b` нет символа `$`, значит переменной `с` присвоено просто строковое значение `a+b` 
* d: Не все то золото, что блестит :) Арифметические операции в bash'е  выполняются в конструкции `$((..))` или с использованием оператора `let`. Следовательно, переменная `d` сложила нам строки значений `a` и `b`, что является строкой `1+2`
* e: Тут сработало арифметическая операция т.к. аргументы `a` и `b` заключены в выражение `$((..))`. Результатом сложения 1 и 2 будет 3.  

2. На нашем локальном сервере упал сервис и мы написали скрипт, который постоянно проверяет его доступность, записывая дату проверок до тех пор, пока сервис не станет доступным. В скрипте допущена ошибка, из-за которой выполнение не может завершиться, при этом место на Жёстком Диске постоянно уменьшается. Что необходимо сделать, чтобы его исправить:
    ```bash
    while ((1==1)
    do
    curl https://localhost:4757
    if (($? != 0))
    then
    date >> curl.log
    fi
    done
    ```
Ответ:  Нам нужно чуть-чуть подебажить скрипт :)
```bash
#!/usr/bin/env bash
while ((1==1)) #Добавляем `)` т.к. цикл while требует наличия конструкции в условии `((..))`
do
curl https://localhost:4757
if (($? != 0))
then
date > curl.log # Меняем перенаправление вывода с записи в конец файла `>>` на перенаправление вывода с перезаписью файла `>`. Место на диске уменьшаться не будет.
fi
done
```
Запустим данный скрипт:
```bash
...
curl: (7) Failed to connect to localhost port 4757: Connection refused
curl: (7) Failed to connect to localhost port 4757: Connection refused
...
````
Запустим мини-web-сервер на базе netcat:
```bash
while true ; do  echo -e "HTTP/1.1 200 OK\n\n $(date)" | nc -l -p 4757  ; done
```
Получим ответ от мини-web-сервера и увидим, что скрипт проверки доступности сайта перешел в режим ожидания:
```bash
ubnt@ansible32776:~$ while true ; do  echo -e "HTTP/1.1 200 OK\n\n $(date)" | nc -l -p 4757  ; done
GET / HTTP/1.1
Host: localhost:4757
User-Agent: curl/7.68.0
Accept: */*
...
curl: (7) Failed to connect to localhost port 4757: Connection refused
curl: (7) Failed to connect to localhost port 4757: Connection refused
 Fri 10 Dec 2021 08:18:43 AM UTC
```
Как только мы остановим мини-web-сервер, скрипт продолжить стучаться на порт 4757 и писать дату в файл curl.log  
P.S. **По факту я проверку проводил на тестовом стенде по протоколу http, а не https, но суть от этого не меняется**  
3. Необходимо написать скрипт, который проверяет доступность трёх IP: 192.168.0.1, 173.194.222.113, 87.250.250.242 по 80 порту и записывает результат в файл log. Проверять доступность необходимо пять раз для каждого узла.  
Ответ:  Я бы добавил необходимые сайты или ip в массив, а уже с ним работал в скрипте. Например так:
```bash
ubnt@ansible32776:~$ cat availability_array.sh
#!/usr/bin/env bash

echo "" > log #Чистим лог
array_ip=(192.168.0.1:80 173.194.222.113:80 87.250.250.242:80) #Проверяемые ip
declare -i x
while ((x < 5)) #Цикл с количеством проходов, в нашем случае 5шт.
do
  let "x += 1" #Увеличиваем счетчик
  for i in ${array_ip[@]} #Проверяем элементы массива
  do
    curl $i > /dev/null 2>&1 #Выбрасываем весь вывод из консоли в утиль. Зачем нам его видеть? :D Магия!
    if (($? !=0)) #Проверяем усовие удачного выполнения команды
    then
      echo $x. !!!ALARM!!! site $i NOT available >>log #Пишем в лог о недоступности ip
    else
      echo $x. site $i available >>log #Пишем в лог о доступности ip
    fi
  done
done
```
Посмотрим `log` после отработки скрипта:
```bash
ubnt@ansible32776:~$ cat log

1. !!!ALARM!!! site 192.168.0.1:80 NOT available
1. site 173.194.222.113:80 available
1. site 87.250.250.242:80 available
2. !!!ALARM!!! site 192.168.0.1:80 NOT available
2. site 173.194.222.113:80 available
2. site 87.250.250.242:80 available
3. !!!ALARM!!! site 192.168.0.1:80 NOT available
3. site 173.194.222.113:80 available
3. site 87.250.250.242:80 available
4. !!!ALARM!!! site 192.168.0.1:80 NOT available
4. site 173.194.222.113:80 available
4. site 87.250.250.242:80 available
5. !!!ALARM!!! site 192.168.0.1:80 NOT available
5. site 173.194.222.113:80 available
5. site 87.250.250.242:80 available
```
**p.s. Нам необходимо проверить 80 порт, `curl` для этого вполне подходит. Если бы я проверял какие-либо другие порты, я бы воспользовался `nmap`'ом и, возможно, порты вынес в отдельный массив.**  
4. Необходимо дописать скрипт из предыдущего задания так, чтобы он выполнялся до тех пор, пока один из узлов не окажется недоступным. Если любой из узлов недоступен - IP этого узла пишется в файл error, скрипт прерывается  
Ответ: Нам необходимо соорудить бесконечный цикл. В моем случае придется часть кода удалить из скрипта :) Дополнительно хочу знать время отвала ip, подкинем дату в лог-файл:
```bash
#!/usr/bin/env bash

array_ip=(192.168.0.1:80 173.194.222.113:80 87.250.250.242:80) #Проверяемые ip
while ((1==1)) #Цикл с количеством проходов, в нашем случае "бесконечный" (пока условие верно)
do
  for i in ${array_ip[@]} #Проверяем элементы массива
  do
    curl $i > /dev/null 2>&1 #Выбрасываем весь вывод из консоли в утиль. Зачем нам его видеть? :D Магия!
    if (($? != 0)) #Проверяем усовие удачного выполнения команды
    then
      echo $(date) !!!ALARM!!! site $i NOT available >error #Пишем в лог о недоступности ip
      exit
    fi
  done
done
```
Лог-файл:
```bash
ubnt@ansible32776:~$ cat error
Fri 10 Dec 2021 06:26:58 PM UTC !!!ALARM!!! site 192.168.0.1:80 NOT available
```
Для теста закинул бредовый ip в центр массива, проверил лог. Работает!
```bash
ubnt@ansible32776:~$ cat availability_array.sh | head -n 3
#!/usr/bin/env bash

array_ip=(173.194.222.113:80 444.234.123.423:80 87.250.250.242:80) #Проверяемые ip
ubnt@ansible32776:~$
ubnt@ansible32776:~$ cat error
Fri 10 Dec 2021 06:31:58 PM UTC !!!ALARM!!! site 444.234.123.423:80 NOT available
```
## Дополнительное задание (со звездочкой*) - необязательно к выполнению

Мы хотим, чтобы у нас были красивые сообщения для коммитов в репозиторий. Для этого нужно написать локальный хук для git, который будет проверять, что сообщение в коммите содержит код текущего задания в квадратных скобках и количество символов в сообщении не превышает 30. Пример сообщения: \[04-script-01-bash\] сломал хук.  
Ответ:  У меня получился вот такой скрипт:
```bash
[gnoy@rhel-vm01 testproject]$ cat .git/hooks/commit-msg
#!/usr/bin/env bash

commitMsg='^(\[[0-9]+-[[:alpha:]]+-[0-9]+-[[:alpha:]]+\])$'
len=$(cat $1 | wc -m)
if [[ $len -gt 30 ]]
then
  echo "Комментарий к commit'у не должен превышать 30 символов!"
  exit 1
elif ! grep -qE "$commitMsg" "$1";
  then
    echo "Сообщение commit'а должно соответствовать виду: [XX-text-XX-text]"
    exit 1
fi
```
Тестирование:
```bash
[gnoy@rhel-vm01 testproject]$ git commit -m '[q04-script-01-bash]'
Сообщение commit'а должно соответствовать виду: [XX-text-XX-text]
[gnoy@rhel-vm01 testproject]$ git commit -m '[04-1script-01-bash]'
Сообщение commit'а должно соответствовать виду: [XX-text-XX-text]
[gnoy@rhel-vm01 testproject]$ git commit -m '[04-script-q01-bash]'
Сообщение commit'а должно соответствовать виду: [XX-text-XX-text]
[gnoy@rhel-vm01 testproject]$ git commit -m '[04-script-01-1bash]'
Сообщение commit'а должно соответствовать виду: [XX-text-XX-text]
[gnoy@rhel-vm01 testproject]$ git commit -m '[04-script-01-bashhajdvlhasjvlshvbhasjvblshvlhajvaljvl]'
Комментарий к commit'у не должен превышать 30 символов!
[gnoy@rhel-vm01 testproject]$ git commit -m '[04-script-01-bash'
Сообщение commit'а должно соответствовать виду: [XX-text-XX-text]
[gnoy@rhel-vm01 testproject]$ git commit -m '[04-script-01-bash]'
[main b34b76a] [04-script-01-bash]
 1 file changed, 1 insertion(+), 1 deletion(-)
[gnoy@rhel-vm01 testproject]$
```
