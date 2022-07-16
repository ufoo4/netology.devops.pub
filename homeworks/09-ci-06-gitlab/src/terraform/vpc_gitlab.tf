resource "yandex_compute_instance" "gitlab" {
  name                      = "gitlab"
  zone                      = "ru-central1-a"
  hostname                  = "gitlab.netology.yc"
  allow_stopping_for_update = true
  # platform_id               = "standard-v1"

  resources {
    cores  = 2
    memory = 4
    # core_fraction = 20
  }

  boot_disk {
    initialize_params {
      image_id    = "${var.gitlab_148}"
      name        = "root-gitlab"
      type        = "network-ssd"
      size        = "16"
    }
  }

  network_interface {
    subnet_id  = "${yandex_vpc_subnet.default.id}"
    nat        = true
    ip_address = "10.74.10.10"
  }

  metadata = {
    ssh-keys = "ubuntu:${file("~/.ssh/id_rsa.pub")}"
    # serial-port-enable = 1
  }
}
