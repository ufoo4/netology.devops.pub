# Домашнее задание к занятию "10.01. Зачем и что нужно мониторить"

## Обязательные задания

1. Вас пригласили настроить мониторинг на проект. На онбординге вам рассказали, что проект представляет из себя 
платформу для вычислений с выдачей текстовых отчетов, которые сохраняются на диск. Взаимодействие с платформой 
осуществляется по протоколу http. Также вам отметили, что вычисления загружают ЦПУ. Какой минимальный набор метрик вы
выведите в мониторинг и почему?  
Ответ:  
- Мониторинг CPU позволит понимать как проект нагружает ВМ в плане вычислений, нужны ли еще дополнительные ядра, раннее реагирование поможет избежать зависания приложений в проекте
- Мониторинг RAM так же позволит быстро реагировать на нехватку ОП в процессе развития проекта 
- Мониторинг дисков (доступный размер, iops) позволит оценивать доступное пространство на дисковой системе, так же нагрузку на эти диски в режиме записи\чтения
- Мониторинг сетевых интерфесов даст понимание о сетевом трафике к приложениям на проекте, поможет определить количество коннектов и в целом загруженность каналов передачи данных
- Мониторинг кодов запроса с использованием метода GET к проекту по http протоколу, что позволит понимать работает ли у нас приложения в проекте или нет (например, код ответа 200 - все ок, 500 - сервер не смог обработать запрос, 400 - ошибка запроса). Так же большое количество 400 ошибок может сигнализировать о  возможной попытке "взлома" проекта
- Мониторинг количества нажатий на баннер\кнопку даст понимание о "интересной" фишке приложения. Пользуются ли пользователи данной фичей.

2. Менеджер продукта посмотрев на ваши метрики сказал, что ему непонятно что такое RAM/inodes/CPUla. Также он сказал, 
что хочет понимать, насколько мы выполняем свои обязанности перед клиентами и какое качество обслуживания. Что вы 
можете ему предложить?  
Ответ:  
Необходимо внедрить SLO (целевой уровень качества обслуживания). В SLA (cоглашение об уровне обслуживания) законтрактовать невыполнение SLO с определенными последствиями. Метрикой выполнения или не выполнения контракта будет конкретная величина SLI (индикатор качества обслуживания).  
Примеры конкретных метрик: в соглашении SLO мы можем установить определенное значение для конкретных метрик, например,сказав, что процент отданных 200 кодов от сайта будет равен 99.9% или скорость ответа по какому-то запросу будет не более 1мс в 99.9% случаев. При несоответствии этим процентным соотношениям для этих метрик мы будем расплачиваться в рамках соглашения SLA в котором прописаны конкретные "санкции" для нас.

3. Вашей DevOps команде в этом году не выделили финансирование на построение системы сбора логов. Разработчики в свою 
очередь хотят видеть все ошибки, которые выдают их приложения. Какое решение вы можете предпринять в этой ситуации, 
чтобы разработчики получали ошибки приложения?  
Ответ:  
Установить бесплатную систему перехвата ошибок в облаке - Sentry

3. Вы, как опытный SRE, сделали мониторинг, куда вывели отображения выполнения SLA=99% по http кодам ответов. 
Вычисляете этот параметр по следующей формуле: summ_2xx_requests/summ_all_requests. Данный параметр не поднимается выше 
70%, но при этом в вашей системе нет кодов ответа 5xx и 4xx. Где у вас ошибка?  
Ответ:  
Ошибка в самой формуле. Правильная: (summ_2xx_requests + summ_3xx_requests)/(summ_all_requests)