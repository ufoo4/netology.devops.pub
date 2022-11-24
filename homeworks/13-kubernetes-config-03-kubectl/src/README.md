# Как запускать
Перед сборкой и запуском нужно подготовить файлы .env в директориях backend и frontend, скопировав переменные из файлов .env.example. Значения переменных могут отличаться для запуска в разных средах. 
```
docker-compose up --build
```
Первый запуск может потребовать перезапуск из-за создания БД.

# Как работает
Запускаются 3 компонента (фронт, бек, база данных). Бекенд связывается с базой через link в докере.

Фронтенд запускается на 8000 порту, бекенд - на 9000. 