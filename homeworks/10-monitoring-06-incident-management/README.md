# Домашнее задание к занятию "10.06. Инцидент-менеджмент"

## Задание 1

Составьте постмотрем, на основе реального сбоя системы Github в 2018 году.

Информация о сбое доступна [в виде краткой выжимки на русском языке](https://habr.com/ru/post/427301/) , а
также [развёрнуто на английском языке](https://github.blog/2018-10-30-oct21-post-incident-analysis/).  

Ответ:  

Шаг | Описание
:-----|:-----
Краткое описание инцидента | Сбой нескольких кластеров баз данных MySQL
Предшествующие события | Плановые работы по техническому обслуживанию сетевого оборудования. В результате работ отсутствовала связь между датацентрами в течении 43 секунд
Воздействие | Было невозможно пользоваться webhook'ами или создавать и публиковать GitHub Pages  
Обнаружение | Внутренние системы мониторинга начали генерировать оповещения о проблемах  
Реакция | Инженеры из команды бастрого реагирования определили, что топология кластеров БД находится в деградированном состоянии  
Восстановление | Восстановление заняло 24 часа 11 минут. Было принято решение сохранить данные пользователей взамен скорости восстановления. Восстановление было произведено из резервных копий, затем производилась репликация данных между датацентрами и в конце возобновление обработки заданий в очереди  
Таймлайн | 21.10.18 22:52 UTC Потеря связи между датацентрами <br> 21.10.18 22:54 UTC Системы мониторинга показали оповещения о неисправности <br> 21.10.18 23:02 UTC Инженеры определили, что кластера БД находятся в деградированном состоянии <br> 21.10.18 23:07 UTC Группа реагирования в ручную заблокировала внутренние инструменты деплоя для предотвращения внесения каких-либо изменений <br> 21.10.18 23:09 UTC Команда помещает сайт в "Желтый статус" <br> 21.10.18 23:11 UTC Координатор инцидента принимает решение о присвоении "Красного статуса" <br> 21.10.18 23:13 UTC Были привлечены дополнительные инженеры из команды разработчиков <br> 21.10.18 23:19 UTC Анализ показал, что необходимо прекратить выполнение заданий о записи метаданных. Принято решение сохранить данные пользователей <br> 22.10.18 00:05 UTC Разработка плана восстановления <br> 22.10.18 00:41 UTC Начат процесс резервного копирования для затронутых кластеров БД <br> 22.10.18 06:51 UTC Несколько кластеров БД завершили процесс резервного копирования <br> 22.10.18 07:46 UTC Опубликовано сообщение в блоге GitHub о случившейся проблеме <br> 22.10.18 11:12 UTC Созданы новые primary БД в датацентре на Восточном побережье США <br> 22.10.18 13:15 UTC Приближение к пиковым нагрузкам на GitHub, начата подготовка для создания дополнительных реплик MySQL для чтения <br> 22.10.18 16:24 UTC Реплики синхронизировались, выполнен переход на исходную топологию <br> 22.10.18 16:45 UTC Включение обработки данных из очереди <br> 22.10.18 23:03 UTC Завершилась обработка данных в очереди. Статус сайта изменен на "Зеленый"
Последующие действия | Часть данных с Западного побережья США не была реплицирована, проводится анализ этих журналов <br> Настройка конфигурации Orchestrator <br> Ускорен переход к статусу сайта "Зеленый-Желтый-Красный" <br> Добавлена срочность для реализации инициативы по поддержке сетевой доступности GitHub на переход к схеме active/active/active <br> Более четко анализировать и тестировать последствия <br> Изменение мышления в отношении надежности GitHub, будет введена практика проверки неудачных сценариев и как они повлияют на GitHub