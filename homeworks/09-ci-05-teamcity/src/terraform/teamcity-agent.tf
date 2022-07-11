resource "yandex_compute_instance" "teamcity-agent" {
  name                      = "teamcity-agent"
  zone                      = "ru-central1-a"
  hostname                  = "teamcity-agent.netology.yc"
  allow_stopping_for_update = true

  resources {
    cores  = 2
    memory = 4
  }

  boot_disk {
    initialize_params {
      image_id    = data.yandex_compute_image.container-optimized-image.id
      name        = "root-teamcity-agent"
      type        = "network-ssd"
      size        = "30"
    }
  }

  network_interface {
    subnet_id  = "${yandex_vpc_subnet.default.id}"
    nat        = true
    ip_address = "10.74.10.12"
  }

  metadata = {
    docker-container-declaration = file("./declaration-agent.yml")
    ssh-keys = "gnoy:${file("~/.ssh/id_rsa.pub")}"
  }
}
