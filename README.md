1. Найдите полный хеш и комментарий коммита, хеш которого начинается на aefea.  
Решение: `git show aefea`  
Ответ: `aefead2207ef7e2aa5dc81a34aedf0cad4c32545`  
2. Какому тегу соответствует коммит 85024d3?  
Решение: `git show 85024d3 -s --format=%s`  
Ответ: `v0.12.23`
3. Сколько родителей у коммита b8d720? Напишите их хеши.  
Решение: `git show b8d720^@ --oneline --no-patch`  
Ответ: `2`  
```
56cd7859e Merge pull request #23857 from hashicorp/cgriggs01-stable
9ea88f22f add/update community provider listings
```
4. Перечислите хеши и комментарии всех коммитов которые были сделаны между тегами v0.12.23 и v0.12.24.  
Решение: `git show v0.12.23..v0.12.24 --no-patch --oneline`  
Ответ:
```
33ff1c03b (tag: v0.12.24) v0.12.24
b14b74c49 [Website] vmc provider links
3f235065b Update CHANGELOG.md
6ae64e247 registry: Fix panic when server is unreachable
5c619ca1b website: Remove links to the getting started guide's old location
06275647e Update CHANGELOG.md
d5f9411f5 command: Fix bug when using terraform login on Windows
4b6d06cc5 Update CHANGELOG.md
dd01a3507 Update CHANGELOG.md
225466bc3 Cleanup after v0.12.23 release
```
5. Найдите коммит в котором была создана функция func providerSource, ее определение в коде выглядит так func providerSource(...) (вместо троеточего перечислены аргументы).  
Решение: `git log -S 'func providerSource' --all --reverse --pretty=format:'%H %as'`  
Ответ: `8c928e83589d90a031f811fae52a81be7153e82f`
6. Найдите все коммиты в которых была изменена функция globalPluginDirs.  
Решение:
```
$ git grep -p 'func globalPluginDirs'
$ git log -L :'func globalPluginDirs':plugins.go --oneline --no-patch
```
Ответ:
```
52dbf9483 keep .terraform.d/plugins for discovery
41ab0aef7 Add missing OS_ARCH dir to global plugin paths
66ebff90c move some more plugin search path logic to command
8364383c3 Push plugin discovery down into command package
```
7. Кто автор функции synchronizedWriters?  
Решение: `git log -S 'func synchronizedWriters(' --pretty=format:'%an'`  
Ответ: `Martin Atkins`

