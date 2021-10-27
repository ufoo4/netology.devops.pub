#Hello World!
new new line!
new line 123!
look git diff

Каталог проекта:
В корневом каталоге (netology.devops.pub) проекта игнорироваться ничего не будет т.к. скрытый файл .gitignore пуст

Каталог terraform:
1. Поиск по маскам будет произведен в скрытом каталоге .terraform и во всех вложенных каталогах 

2. Будут проигнорированы все файлы c расширениями:
.tfstate
.tfstate.*
.tfvars

3. Так же будут проигнорированы отдельные файлы:
crash.log
override.tf
override.tf.json
.terraformrc
terraform.rc

4. Будут проигнорированы все файлы оканчивающиеся на:
_override.tf
_override.tf.json
