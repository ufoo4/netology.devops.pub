resource "yandex_compute_instance" "node-external" {
  name                      = "node-external"
  zone                      = "ru-central1-a"
  hostname                  = "node-external.netology.cloud"
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
      name        = "root-node-external"
      type        = "network-hdd"
      size        = "10"
    }
  }

  network_interface {
    subnet_id  = "${yandex_vpc_subnet.public.id}"
    nat        = true
  }

  metadata = {
    ssh-keys           = "centos:${file("~/.ssh/id_rsa.pub")}"
    serial-port-enable = 1
  }
}