resource "yandex_compute_instance" "node03" {
  name                      = "node03"
  zone                      = "ru-central1-a"
  hostname                  = "node03.ntlg.cloud"
  allow_stopping_for_update = true
  platform_id               = "standard-v1"

  resources {
    cores         = 2
    memory        = 2
    # core_fraction = 5
  }

  boot_disk {
    initialize_params {
      image_id    = "${var.centos-7}"
      name        = "root-node03"
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