5. Ознакомьтесь с графическим интерфейсом VirtualBox, посмотрите как выглядит виртуальная машина, которую создал для вас Vagrant, какие аппаратные ресурсы ей выделены. Какие ресурсы выделены по-умолчанию?  
Ответ: `CPU 2\1Gb\64GbHDD\no audio\LAN NAT\`
6. Ознакомьтесь с возможностями конфигурации VirtualBox через Vagrantfile: [документация](https://www.vagrantup.com/docs/providers/virtualbox/configuration.html). Как добавить оперативной памяти или ресурсов процессора виртуальной машине?  
Ответ: `Нам необходимо в конфигурационном файле добавить параметры v.cpus и v.memory`
```
Vagrant.configure("2") do |config|
 	config.vm.box = "bento/ubuntu-20.04"
	config.vm.provider "virtualbox" do |v|
		v.gui = false
		v.cpus = 1
		v.memory = 2048
		end
end
```
8. Ознакомиться с разделами `man bash`, почитать о настройках самого bash:
* какой переменной можно задать длину журнала `history`, и на какой строчке manual это описывается?  
Ответ: `Переменная HISTSIZE. Строка 612. Пример использования: vagrant@vagrant:~$ HISTSIZE=1000`
* что делает директива `ignoreboth` в bash?  
Ответ: `Является сокращением для ignorespace и ignoredups. Строка man bash - 597`
9. В каких сценариях использования применимы скобки `{}` и на какой строчке `man bash` это описано?  
Ответ: `Применяется для создания списков. Описание man bash на строке 200.`  
Пример: 
``` 
vagrant@vagrant:~$ echo {0..10}
0 1 2 3 4 5 6 7 8 9 10
```
10. С учётом ответа на предыдущий вопрос, как создать однократным вызовом `touch` 100000 файлов? Получится ли аналогичным образом создать 300000? Если нет, то почему?  
Ответ: ``
```
Первая команда, приходящая на ум (touch newfile{1..100000}.txt) - не выполнится. Будет ошибка.
Есть огранечения оболочки на длину списка аргументов для программы.
Нам поможет простейший цикл!
Он сможет создать сколько угодно файлов, хоть 100000, хоть мульярд :)
Самое главное, позаботиться о свободном месте на HDD и свободным временем (операция займет какое-то время, зависит от скорости HDD\SSD)
Итак цикл:
vagrant@vagrant:~/test/test2$ for create_file in {1..300000}; do touch newfile_${create_file}'.txt'; done
vagrant@vagrant:~/test/test2$ ls -lah ./newfile_
Display all 300000 possibilities? (y or n)
```
11. В man bash поищите по `/\[\[`. Что делает конструкция `[[ -d /tmp ]]`  
Ответ: 
```
Описание конструкции на строке 209 в man bash. Возвращает 1 при верном условии в конструкции [[]] и 0 при неверном.
В данном конкретном случае конструкция вернет 1 т.к. 
-d проверяет, существует ли файл, и является ли он директорией
```
12. Основываясь на знаниях о просмотре текущих (например, PATH) и установке новых переменных; командах, которые мы рассматривали, добейтесь в выводе `type -a bash` в виртуальной машине наличия первым пунктом в списке:

    ```
    bash is /tmp/new_path_directory/bash
    bash is /usr/local/bin/bash
    bash is /bin/bash
    ```

    (прочие строки могут отличаться содержимым и порядком)
    В качестве ответа приведите команды, которые позволили вам добиться указанного вывода или соответствующие скриншоты.  
Ответ: 
```
vagrant@vagrant:~$ mkdir -v /tmp/new_path_directory/
mkdir: created directory '/tmp/new_path_directory/'
vagrant@vagrant:~$ cd /tmp/new_path_directory/
vagrant@vagrant:/tmp/new_path_directory$ cp /usr/bin/bash ./
vagrant@vagrant:/tmp/new_path_directory$ PATH=$PATH:/tmp/new_path_directory/
vagrant@vagrant:/tmp/new_path_directory$ type -a bash
bash is /usr/bin/bash
bash is /bin/bash
bash is /tmp/new_path_directory/bash
```
13. Чем отличается планирование команд с помощью `batch` и `at`?  
Ответ: 
```
batch - задания будут выполнены один раз как только средняя нагрузка на систему будет меньше 0.8 
at - используется для выполнения задания один раз в определенное время
```
14. Завершите работу виртуальной машины чтобы не расходовать ресурсы компьютера и/или батарею ноутбука.  
Ответ:
```
vagrant@vagrant:~$ exit
logout
Connection to 172.27.112.1 closed.
gnoy@LAPTOP-CHVMGVOQ:/mnt/c/Users/Gnoy/vagrant/homework-03.01$ vagrant halt
==> default: Attempting graceful shutdown of VM...
```
