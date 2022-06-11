# Домашнее задание к занятию "09.01 Жизненный цикл ПО"

## Подготовка к выполнению
1. Получить бесплатную [JIRA](https://www.atlassian.com/ru/software/jira/free)  
2. Настроить её для своей "команды разработки"  
3. Создать доски kanban и scrum  
Ответ:  
<p align="left">
  <img width="1300" height="800" src="./img/start_jira.png">
</p> 

## Основная часть
В рамках основной части необходимо создать собственные workflow для двух типов задач: bug и остальные типы задач. Задачи типа bug должны проходить следующий жизненный цикл:
1. Open -> On reproduce
2. On reproduce -> Open, Done reproduce
3. Done reproduce -> On fix
4. On fix -> On reproduce, Done fix
5. Done fix -> On test
6. On test -> On fix, Done
7. Done -> Closed, Open  
Ответ:  
<p align="left">
  <img width="1300" height="800" src="./img/for_bug.png">
</p> 

Остальные задачи должны проходить по упрощённому workflow:
1. Open -> On develop
2. On develop -> Open, Done develop
3. Done develop -> On test
4. On test -> On develop, Done
5. Done -> Closed, Open  
Ответ:  
<p align="left">
  <img width="1300" height="800" src="./img/for_all.png">
</p> 

Создать задачу с типом bug, попытаться провести его по всему workflow до Done. Создать задачу с типом epic, к ней привязать несколько задач с типом task, провести их по всему workflow до Done. При проведении обеих задач по статусам использовать kanban. Вернуть задачи в статус Open.  
Ответ:  
<p align="left">
  <img width="1300" height="800" src="./img/kanban_epic_tasks_bug.png">
</p> 

Перейти в scrum, запланировать новый спринт, состоящий из задач эпика и одного бага, стартовать спринт, провести задачи до состояния Closed. Закрыть спринт.  
Ответ:  
<p align="left">
  <img width="1300" height="800" src="./img/close_sprint.png">
</p> 

Если всё отработало в рамках ожидания - выгрузить схемы workflow для импорта в XML. Файлы с workflow приложить к решению задания.  
Ответ:  
[For ALL](./src/For%20All.xml)  
[For BUG](./src/For%20BUG.xml)
