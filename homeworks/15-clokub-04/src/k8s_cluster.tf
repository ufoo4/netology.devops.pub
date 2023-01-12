resource "yandex_kubernetes_cluster" "k8s-regional-cluster" {
  network_id = yandex_vpc_network.net.id
  master {
    version = "${var.k8s_version}"
    public_ip = true
    regional {
      region = "ru-central1"
      location {
        zone      = yandex_vpc_subnet.public-subnet-a.zone
        subnet_id = yandex_vpc_subnet.public-subnet-a.id
      }
      location {
        zone      = yandex_vpc_subnet.public-subnet-b.zone
        subnet_id = yandex_vpc_subnet.public-subnet-b.id
      }
      location {
        zone      = yandex_vpc_subnet.public-subnet-c.zone
        subnet_id = yandex_vpc_subnet.public-subnet-c.id
      }
    }
    security_group_ids = [yandex_vpc_security_group.k8s-main-sg.id]
  }
  service_account_id      = yandex_iam_service_account.k8s-robot.id
  node_service_account_id = yandex_iam_service_account.k8s-robot.id
  depends_on = [
    yandex_resourcemanager_folder_iam_binding.k8s-clusters-agent,
    yandex_resourcemanager_folder_iam_binding.vpc-public-admin,
    yandex_resourcemanager_folder_iam_binding.images-puller
  ]
  kms_provider {
    key_id = yandex_kms_symmetric_key.my-kms-key.id
  }
}
