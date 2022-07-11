resource "yandex_compute_instance" "teamcity-server" {
  name                      = "teamcity-server"
  zone                      = "ru-central1-a"
  hostname                  = "teamcity-server.netology.yc"
  allow_stopping_for_update = true

  resources {
    cores  = 4
    memory = 4
  }

  boot_disk {
    initialize_params {
      image_id    = data.yandex_compute_image.container-optimized-image.id
      name        = "root-teamcity-server"
      type        = "network-ssd"
      size        = "30"
    }
  }

  network_interface {
    subnet_id  = "${yandex_vpc_subnet.default.id}"
    nat        = true
    ip_address = "10.74.10.11"
  }

  metadata = {
    docker-container-declaration = file("./declaration-server.yml")
    ssh-keys = "gnoy:${file("~/.ssh/id_rsa.pub")}"
  }
}
