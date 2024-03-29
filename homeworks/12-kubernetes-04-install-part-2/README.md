# Домашнее задание к занятию "12.4 Развертывание кластера на собственных серверах, лекция 2"
Новые проекты пошли стабильным потоком. Каждый проект требует себе несколько кластеров: под тесты и продуктив. Делать все руками — не вариант, поэтому стоит автоматизировать подготовку новых кластеров.

## Задание 1: Подготовить инвентарь kubespray
Новые тестовые кластеры требуют типичных простых настроек. Нужно подготовить инвентарь и проверить его работу. Требования к инвентарю:
* подготовка работы кластера из 5 нод: 1 мастер и 4 рабочие ноды;
* в качестве CRI — containerd;
* запуск etcd производить на мастере.  

**Ответ:**  
Мне стало лень создавать 5 нод в YC руками, вписывать ip-адреса инстансов в inventory.ini.   
Я подготовил конфиг TF для автоматического разворачивания ВМ и последующего запуска плейбуки Ansible.  
В конфигурационных файлах выбрано:
- CRI - containerd
- CNI - calico
- etcd - устанавливается на node01.ntlg.cloud (мастер)

Файл inventory.ini создается TF'ом, но после `terraform destroy -auto-approve` он удаляется.  
Вот файл inventory во время работы кластера:
<details>
  <summary>inventory.ini</summary>

```yml
# Ansible inventory containing variable values from Terraform.
# Generated by Terraform.

[all]
node01.ntlg.cloud ansible_host=51.250.75.214
node02.ntlg.cloud ansible_host=51.250.64.57
node03.ntlg.cloud ansible_host=51.250.72.68
node04.ntlg.cloud ansible_host=51.250.1.71
node05.ntlg.cloud ansible_host=51.250.4.24

[kube_control_plane]
node01.ntlg.cloud

[etcd]
node01.ntlg.cloud

[kube_node]
node02.ntlg.cloud
node03.ntlg.cloud
node04.ntlg.cloud
node05.ntlg.cloud

[calico_rr]

[k8s_cluster:children]
kube_control_plane
kube_node
calico_rr
```
</details>
<br>

Кластер развернулся:
```bash
null_resource.k8s-deploy (local-exec): PLAY RECAP *********************************************************************
null_resource.k8s-deploy (local-exec): localhost                  : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
null_resource.k8s-deploy (local-exec): node01.ntlg.cloud          : ok=760  changed=149  unreachable=0    failed=0    skipped=1247 rescued=0    ignored=8
null_resource.k8s-deploy (local-exec): node02.ntlg.cloud          : ok=510  changed=100  unreachable=0    failed=0    skipped=732  rescued=0    ignored=1
null_resource.k8s-deploy (local-exec): node03.ntlg.cloud          : ok=510  changed=100  unreachable=0    failed=0    skipped=731  rescued=0    ignored=1
null_resource.k8s-deploy (local-exec): node04.ntlg.cloud          : ok=510  changed=100  unreachable=0    failed=0    skipped=731  rescued=0    ignored=1
null_resource.k8s-deploy (local-exec): node05.ntlg.cloud          : ok=510  changed=100  unreachable=0    failed=0    skipped=731  rescued=0    ignored=1

null_resource.k8s-deploy: Creation complete after 25m34s [id=2252033386252876358]

Apply complete! Resources: 10 added, 0 changed, 0 destroyed.

Outputs:

external_ip_address_node01_yandex_cloud = "51.250.75.214"
external_ip_address_node02_yandex_cloud = "51.250.64.57"
external_ip_address_node03_yandex_cloud = "51.250.72.68"
external_ip_address_node04_yandex_cloud = "51.250.1.71"
external_ip_address_node05_yandex_cloud = "51.250.4.24"
internal_ip_address_node01_yandex_cloud = "192.168.101.13"
internal_ip_address_node02_yandex_cloud = "192.168.101.6"
internal_ip_address_node03_yandex_cloud = "192.168.101.8"
internal_ip_address_node04_yandex_cloud = "192.168.101.14"
internal_ip_address_node05_yandex_cloud = "192.168.101.29"
```

Проверяю получившейся кластер:
```bash
[centos@node01 ~]$ mkdir -p $HOME/.kube
[centos@node01 ~]$ sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
[centos@node01 ~]$ sudo chown $(id -u):$(id -g) $HOME/.kube/config
[centos@node01 ~]$ kubectl get nodes
NAME                STATUS   ROLES           AGE     VERSION
node01.ntlg.cloud   Ready    control-plane   11m     v1.24.4
node02.ntlg.cloud   Ready    <none>          9m56s   v1.24.4
node03.ntlg.cloud   Ready    <none>          9m56s   v1.24.4
node04.ntlg.cloud   Ready    <none>          9m56s   v1.24.4
node05.ntlg.cloud   Ready    <none>          9m56s   v1.24.4
[centos@node01 ~]$ kubectl get nodes -o wide
NAME                STATUS   ROLES           AGE   VERSION   INTERNAL-IP      EXTERNAL-IP   OS-IMAGE                KERNEL-VERSION                CONTAINER-RUNTIME
node01.ntlg.cloud   Ready    control-plane   12m   v1.24.4   192.168.101.13   <none>        CentOS Linux 7 (Core)   3.10.0-1160.66.1.el7.x86_64   containerd://1.6.8
node02.ntlg.cloud   Ready    <none>          10m   v1.24.4   192.168.101.6    <none>        CentOS Linux 7 (Core)   3.10.0-1160.66.1.el7.x86_64   containerd://1.6.8
node03.ntlg.cloud   Ready    <none>          10m   v1.24.4   192.168.101.8    <none>        CentOS Linux 7 (Core)   3.10.0-1160.66.1.el7.x86_64   containerd://1.6.8
node04.ntlg.cloud   Ready    <none>          10m   v1.24.4   192.168.101.14   <none>        CentOS Linux 7 (Core)   3.10.0-1160.66.1.el7.x86_64   containerd://1.6.8
node05.ntlg.cloud   Ready    <none>          10m   v1.24.4   192.168.101.29   <none>        CentOS Linux 7 (Core)   3.10.0-1160.66.1.el7.x86_64   containerd://1.6.8
[centos@node01 ~]$ kubectl get pods
NAME                          READY   STATUS    RESTARTS   AGE
hello-node-6d5f754cc9-pbxnm   1/1     Running   0          10m
```

Закончили упражнение:
```bash
[gnoy@manjarokde-ws01 terraform]$ terraform destroy -auto-approve
...
Destroy complete! Resources: 10 destroyed.
```


## Задание 2 (*): подготовить и проверить инвентарь для кластера в AWS
Часть новых проектов хотят запускать на мощностях AWS. Требования похожи:
* разворачивать 5 нод: 1 мастер и 4 рабочие ноды;
* работать должны на минимально допустимых EC2 — t3.small.
