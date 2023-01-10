resource "yandex_compute_instance" "node-internal" {
  name                      = "node-internal"
  zone                      = "ru-central1-a"
  hostname                  = "node-internal.netology.cloud"
  allow_stopping_for_update = true
  platform_id               = "standard-v1"

  resources {
    cores         = 2
    memory        = 2
    core_fraction = 5
  }

  boot_disk {
    initialize_params {
      image_id    = "${var.Centos7}"
      name        = "root-node-internal"
      type        = "network-hdd"
      size        = "10"
    }
  }

  network_interface {
    subnet_id  = "${yandex_vpc_subnet.private.id}"
  }

  metadata = {
    ssh-keys           = "centos:${file("~/.ssh/id_rsa.pub")}"
    serial-port-enable = 1
  }
}