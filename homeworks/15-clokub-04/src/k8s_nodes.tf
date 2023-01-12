resource "yandex_kubernetes_node_group" "k8s-regional-nodes-a" {
  cluster_id = yandex_kubernetes_cluster.k8s-regional-cluster.id
  name       = "k8s-regional-nodes-a"
  version    = "${var.k8s_version}"

  instance_template {
    platform_id = "standard-v1"

    resources {
      memory = 1
      cores  = 2
      core_fraction = 20
    }
    boot_disk {
      type = "network-hdd"
      size = 30
    }

    container_runtime {
     type = "containerd"
    }

    network_interface {
      subnet_ids = [yandex_vpc_subnet.public-subnet-a.id]
    }

    metadata = {
      ssh-keys = "ubuntu:${file("~/.ssh/id_rsa.pub")}"
      serial-port-enable = 1
    }
  }
  scale_policy {
    auto_scale {
      min     = 1
      max     = 2
      initial = 1
    }
  }

  allocation_policy {
    location {
      zone = yandex_vpc_subnet.public-subnet-a.zone
    }
  }

  depends_on = [
    yandex_kubernetes_cluster.k8s-regional-cluster
  ]
}

resource "yandex_kubernetes_node_group" "k8s-regional-nodes-b" {
  cluster_id = yandex_kubernetes_cluster.k8s-regional-cluster.id
  name       = "k8s-regional-nodes-b"
  version    = "${var.k8s_version}"

  instance_template {
    platform_id = "standard-v1"

    resources {
      memory = 1
      cores  = 2
      core_fraction = 20
    }
    boot_disk {
      type = "network-hdd"
      size = 30
    }

    container_runtime {
     type = "containerd"
    }

    network_interface {
      subnet_ids = [yandex_vpc_subnet.public-subnet-b.id]
    }

    metadata = {
      ssh-keys = "ubuntu:${file("~/.ssh/id_rsa.pub")}"
      serial-port-enable = 1
    }
  }
  scale_policy {
    auto_scale {
      min     = 1
      max     = 2
      initial = 1
    }
  }

  allocation_policy {
    location {
      zone = yandex_vpc_subnet.public-subnet-b.zone
    }
  }

  depends_on = [
    yandex_kubernetes_cluster.k8s-regional-cluster
  ]
}

resource "yandex_kubernetes_node_group" "k8s-regional-nodes-c" {
  cluster_id = yandex_kubernetes_cluster.k8s-regional-cluster.id
  name       = "k8s-regional-nodes-c"
  version    = "${var.k8s_version}"

  instance_template {
    platform_id = "standard-v1"

    resources {
      memory = 1
      cores  = 2
      core_fraction = 20
    }
    boot_disk {
      type = "network-hdd"
      size = 30
    }

    container_runtime {
     type = "containerd"
    }

    network_interface {
      subnet_ids = [yandex_vpc_subnet.public-subnet-c.id]
    }

    metadata = {
      ssh-keys = "ubuntu:${file("~/.ssh/id_rsa.pub")}"
      serial-port-enable = 1
    }
  }
  scale_policy {
    auto_scale {
      min     = 1
      max     = 2
      initial = 1
    }
  }

  allocation_policy {
    location {
      zone = yandex_vpc_subnet.public-subnet-c.zone
    }
  }

  depends_on = [
    yandex_kubernetes_cluster.k8s-regional-cluster
  ]
}
