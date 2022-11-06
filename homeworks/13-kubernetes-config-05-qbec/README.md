# Домашнее задание к занятию "13.5 поддержка нескольких окружений на примере Qbec"
Приложение обычно существует в нескольких окружениях. Для удобства работы следует использовать соответствующие инструменты, например, Qbec.

## Задание 1: подготовить приложение для работы через qbec
Приложение следует упаковать в qbec. Окружения должно быть 2: stage и production. 

Требования:
* stage окружение должно поднимать каждый компонент приложения в одном экземпляре;
* production окружение — каждый компонент в трёх экземплярах;
* для production окружения нужно добавить endpoint на внешний адрес.

**Ответ:**
Установил в систему qbec и jsonnet
```bash
❯ qbec version
qbec version: 0.15.2
jsonnet version: v0.18.0
client-go version: kubernetes-1.23.1
go version: 1.17.7
commit: 9f26fb9d14300b3aefd87b89f8d346c3dce48092
❯ jsonnet --version
Jsonnet commandline interpreter v0.15.0
```
Создал пример конфигурации:
```bash
❯ qbec init src --with-example
using server URL "https://192.168.1.20:6443/" and default namespace "default" for the default environment
wrote src/params.libsonnet
wrote src/environments/base.libsonnet
wrote src/environments/default.libsonnet
wrote src/components/hello.jsonnet
wrote src/qbec.yaml
```
Список компонентов для окружений:
```bash
❯ qbec component list stage
COMPONENT                      FILES
backend                        components/backend.jsonnet
db                             components/db.jsonnet
frontend                       components/frontend.jsonnet
❯ qbec component list prod
COMPONENT                      FILES
backend                        components/backend.jsonnet
db                             components/db.jsonnet
endpoint                       components/endpoint.jsonnet
frontend                       components/frontend.jsonnet
```
Деплою в stage:
```bash
❯ qbec apply stage --yes
setting cluster to cluster.local
setting context to cluster.local
cluster metadata load took 31ms
3 components evaluated in 22ms

will synchronize 6 object(s)

3 components evaluated in 21ms
create deployments backend -n stage (source backend)
create deployments frontend -n stage (source frontend)
create statefulsets db -n stage (source db)
create services backend -n stage (source backend)
create services db -n stage (source db)
create services frontend -n stage (source frontend)
server objects load took 206ms
---
stats:
  created:
  - deployments backend -n stage (source backend)
  - deployments frontend -n stage (source frontend)
  - statefulsets db -n stage (source db)
  - services backend -n stage (source backend)
  - services db -n stage (source db)
  - services frontend -n stage (source frontend)

waiting for readiness of 3 objects
  - deployments backend -n stage
  - deployments frontend -n stage
  - statefulsets db -n stage

  0s    : deployments frontend -n stage :: 0 of 1 updated replicas are available
✓ 0s    : statefulsets db -n stage :: 1 new pods updated (2 remaining)
  0s    : deployments backend -n stage :: 0 of 1 updated replicas are available
✓ 0s    : deployments frontend -n stage :: successfully rolled out (1 remaining)
✓ 0s    : deployments backend -n stage :: successfully rolled out (0 remaining)

✓ 0s: rollout complete
command took 1.99s
```
Проверяю:
```bash
❯ kubectl get deployments.apps,statefulsets.apps -n stage -o wide
NAME                       READY   UP-TO-DATE   AVAILABLE   AGE   CONTAINERS   IMAGES                                          SELECTOR
deployment.apps/backend    1/1     1            1           44s   backend      foo4/13-kub-config-01-obj_src-backend:latest    app=backend
deployment.apps/frontend   1/1     1            1           44s   frontend     foo4/13-kub-config-01-obj_src-frontend:latest   app=frontend

NAME                  READY   AGE   CONTAINERS   IMAGES
statefulset.apps/db   1/1     44s   db           postgres:13-alpine
```
Удаляю:
```bash
❯ qbec delete stage --yes
setting cluster to cluster.local
setting context to cluster.local
cluster metadata load took 28ms
3 components evaluated in 23ms
waiting for deletion list to be returned
server objects load took 221ms

will delete 6 object(s)

delete services frontend -n stage
delete services db -n stage
delete services backend -n stage
delete statefulsets db -n stage
delete deployments frontend -n stage
delete deployments backend -n stage
---
stats:
  deleted:
  - services frontend -n stage
  - services db -n stage
  - services backend -n stage
  - statefulsets db -n stage
  - deployments frontend -n stage
  - deployments backend -n stage

command took 950ms
```
То же самое проделываю на drop окружении:
```bash
❯ qbec apply prod --yes
  - endpoints quiz -n prod (source endpoint)
  - deployments backend -n prod (source backend)
  - deployments frontend -n prod (source frontend)
  - statefulsets db -n prod (source db)
  - services backend -n prod (source backend)
  - services db -n prod (source db)
  - services frontend -n prod (source frontend)

waiting for readiness of 3 objects
  - deployments backend -n prod
  - deployments frontend -n prod
  - statefulsets db -n prod

  0s    : deployments backend -n prod :: 0 of 3 updated replicas are available
  0s    : deployments frontend -n prod :: 0 of 3 updated replicas are available
  0s    : statefulsets db -n prod :: 1 of 3 updated
  0s    : deployments backend -n prod :: 1 of 3 updated replicas are available
  0s    : deployments backend -n prod :: 2 of 3 updated replicas are available
  0s    : deployments frontend -n prod :: 1 of 3 updated replicas are available
✓ 0s    : deployments backend -n prod :: successfully rolled out (2 remaining)
  1s    : statefulsets db -n prod :: 2 of 3 updated
  1s    : deployments frontend -n prod :: 2 of 3 updated replicas are available
✓ 1s    : deployments frontend -n prod :: successfully rolled out (1 remaining)
✓ 5s    : statefulsets db -n prod :: 3 new pods updated (0 remaining)

✓ 5s: rollout complete
command took 6.63s
```
Проверяю:
```bash
❯ kubectl get deployments.apps,statefulsets.apps,endpoints -n prod -o wide
NAME                       READY   UP-TO-DATE   AVAILABLE   AGE   CONTAINERS   IMAGES                                          SELECTOR
deployment.apps/backend    3/3     3            3           69s   backend      foo4/13-kub-config-01-obj_src-backend:latest    app=backend
deployment.apps/frontend   3/3     3            3           69s   frontend     foo4/13-kub-config-01-obj_src-frontend:latest   app=frontend

NAME                  READY   AGE   CONTAINERS   IMAGES
statefulset.apps/db   3/3     69s   db           postgres:13-alpine

NAME                 ENDPOINTS                                                   AGE
endpoints/backend    10.233.104.172:9000,10.233.89.54:9000,10.233.89.55:9000     68s
endpoints/db         10.233.104.174:5432,10.233.104.175:5432,10.233.89.58:5432   68s
endpoints/frontend   10.233.104.173:80,10.233.89.56:80,10.233.89.57:80           67s
endpoints/app        92.43.188.80:80                                             69s
```
Закончили упражнение. Удаляю:
```bash
❯ qbec delete prod --yes
setting cluster to cluster.local
setting context to cluster.local
cluster metadata load took 31ms
4 components evaluated in 29ms
waiting for deletion list to be returned
server objects load took 206ms

will delete 6 object(s)

delete services frontend -n prod
delete services db -n prod
delete services backend -n prod
delete statefulsets db -n prod
delete deployments frontend -n prod
delete deployments backend -n prod
---
stats:
  deleted:
  - services frontend -n prod
  - services db -n prod
  - services backend -n prod
  - statefulsets db -n prod
  - deployments frontend -n prod
  - deployments backend -n prod

command took 950ms
```
