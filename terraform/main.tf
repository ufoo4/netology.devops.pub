provider "yandex" {
  cloud_id    = "b1gffcps5oa5h9clc5o9"
  folder_id   = "b1g27gpcstr1l1bi3a22"
  zone        = "ru-central1-a"
}

resource "yandex_compute_instance" "vm01" {
  name                      = "vm01"
  hostname                  = "vm01.netology.cloud"
  allow_stopping_for_update = true
  platform_id               = "standard-v1"

  resources {
    cores         = 2
    memory        = 2
    core_fraction = 5
  }

  boot_disk {
    initialize_params {
      image_id    = "fd80le4b8gt2u33lvubr"
      name        = "root-node01"
      type        = "network-hdd"
      size        = "10"
    }
  }

  network_interface {
    subnet_id = "${yandex_vpc_subnet.default.id}"
    nat       = true
  }

  metadata = {
    ssh-keys           = "centos:${file("~/.ssh/id_rsa.pub")}"
    serial-port-enable = 1
  }
}

  resource "yandex_vpc_network" "default" {
    name = "net"
  }

  resource "yandex_vpc_subnet" "default" {
    name           = "subnet"
    network_id     = "${yandex_vpc_network.default.id}"
    v4_cidr_blocks = ["192.168.101.0/24"]
  }