resource "yandex_compute_instance" "nexus" {
  name                      = "nexus"
  zone                      = "ru-central1-a"
  hostname                  = "nexus.netology.yc"
  allow_stopping_for_update = true

  resources {
    cores  = 4
    memory = 4
  }

  boot_disk {
    initialize_params {
      image_id    = "${var.centos-7}"
      name        = "root-nexus"
      type        = "network-ssd"
      size        = "20"
    }
  }

  network_interface {
    subnet_id  = "${yandex_vpc_subnet.default.id}"
    nat        = true
    ip_address = "10.74.10.13"
  }

  metadata = {
    ssh-keys = "gnoy:${file("~/.ssh/id_rsa.pub")}"
  }
}
