# Домашнее задание к занятию "12.5 Сетевые решения CNI"
После работы с Flannel появилась необходимость обеспечить безопасность для приложения. Для этого лучше всего подойдет Calico.
## Задание 1: установить в кластер CNI плагин Calico
Для проверки других сетевых решений стоит поставить отличный от Flannel плагин — например, Calico. Требования: 
* установка производится через ansible/kubespray;
* после применения следует настроить политику доступа к hello-world извне. Инструкции [kubernetes.io](https://kubernetes.io/docs/concepts/services-networking/network-policies/), [Calico](https://docs.projectcalico.org/about/about-network-policy)

**Ответ:**  
Первоначальную настройку k8s кластера произведу из прошлого ДЗ, с использованием TF и kubespray.  
После установки кластера, TF запустит установку приложения в кластер k8s.  
 
Проверяю сетевой плагин и запущено ли приложение:

```bash
[centos@node01 ~]$ ls -lh /etc/cni/net.d
total 12K
-rw-r--r--. 1 root root  728 Sep 27 16:12 10-calico.conflist
-rw-r--r--. 1 root root  726 Sep 27 16:11 calico.conflist.template
-rw-------. 1 root root 2.7K Sep 27 16:13 calico-kubeconfig
[centos@node01 ~]$ kubectl get pods
NAME                          READY   STATUS    RESTARTS   AGE
hello-node-6d5f754cc9-cqt7v   1/1     Running   0          100s
```
Видно, что приложение установилось, плагин установлен calico.  

Настраиваю политику доступа к hello-node извне:  
Проверяю сервисы, их нет, подключиться извне невозможно:
```bash
[centos@node01 ~]$ kubectl get service
NAME         TYPE        CLUSTER-IP   EXTERNAL-IP   PORT(S)   AGE
kubernetes   ClusterIP   10.233.0.1   <none>        443/TCP   10m
```
Создам сервис и проверю что получилось:
```bash
[centos@node01 ~]$ kubectl expose deployment hello-node --type=LoadBalancer --port=8080
service/hello-node exposed
[centos@node01 ~]$ kubectl get service
NAME         TYPE           CLUSTER-IP     EXTERNAL-IP   PORT(S)          AGE
hello-node   LoadBalancer   10.233.51.97   <pending>     8080:32750/TCP   6s
kubernetes   ClusterIP      10.233.0.1     <none>        443/TCP          12m
```
Сервис создался. Доступен порт 32750, к нему попробую подключиться:
```bash
root@DESKTOP-234VSMB:~# curl 178.154.207.23:32750
CLIENT VALUES:
client_address=10.233.125.64
command=GET
real path=/
query=nil
request_version=1.1
request_uri=http://178.154.207.23:8080/

SERVER VALUES:
server_version=nginx: 1.10.0 - lua: 10001

HEADERS RECEIVED:
accept=*/*
host=178.154.207.23:32750
user-agent=curl/7.74.0
BODY:
-no body in request-
root@DESKTOP-234VSMB:~#
```
Как видно, приложение доступно извне.



## Задание 2: изучить, что запущено по умолчанию
Самый простой способ — проверить командой calicoctl get <type>. Для проверки стоит получить список нод, ipPool и profile.
Требования: 
* установить утилиту calicoctl;
* получить 3 вышеописанных типа в консоли.

**Ответ:**  
Утилита уже была установлена.  
Ноды:
```bash
[centos@node01 ~]$ calicoctl get node
NAME
node01.ntlg.cloud   
node03.ntlg.cloud   
node04.ntlg.cloud   
```
Пул:
```bash
[centos@node01 ~]$ calicoctl get ippool
NAME           CIDR             SELECTOR   
default-pool   10.233.64.0/18   all()      
```
Профили:
```bash
[centos@node01 ~]$ calicoctl get profile
NAME
projectcalico-default-allow
kns.default
kns.kube-node-lease
kns.kube-public
kns.kube-system
ksa.default.default
ksa.kube-node-lease.default
ksa.kube-public.default
ksa.kube-system.attachdetach-controller
ksa.kube-system.bootstrap-signer
ksa.kube-system.calico-node
ksa.kube-system.certificate-controller
ksa.kube-system.clusterrole-aggregation-controller   
ksa.kube-system.coredns
ksa.kube-system.cronjob-controller
ksa.kube-system.daemon-set-controller
ksa.kube-system.default
ksa.kube-system.deployment-controller
ksa.kube-system.disruption-controller
ksa.kube-system.dns-autoscaler
ksa.kube-system.endpoint-controller
ksa.kube-system.endpointslice-controller
ksa.kube-system.endpointslicemirroring-controller
ksa.kube-system.ephemeral-volume-controller
ksa.kube-system.expand-controller
ksa.kube-system.generic-garbage-collector
ksa.kube-system.horizontal-pod-autoscaler
ksa.kube-system.job-controller
ksa.kube-system.kube-proxy
ksa.kube-system.namespace-controller
ksa.kube-system.node-controller
ksa.kube-system.nodelocaldns
ksa.kube-system.persistent-volume-binder
ksa.kube-system.pod-garbage-collector
ksa.kube-system.pv-protection-controller
ksa.kube-system.pvc-protection-controller
ksa.kube-system.replicaset-controller
ksa.kube-system.replication-controller
ksa.kube-system.resourcequota-controller
ksa.kube-system.root-ca-cert-publisher
ksa.kube-system.service-account-controller
ksa.kube-system.service-controller
ksa.kube-system.statefulset-controller
ksa.kube-system.token-cleaner
ksa.kube-system.ttl-after-finished-controller
ksa.kube-system.ttl-controller
```
