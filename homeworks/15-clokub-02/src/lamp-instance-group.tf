resource "yandex_compute_instance_group" "lamp-group" {
  name                = "lamp-ig"
  folder_id           = "${var.yandex_folder_id}"
  service_account_id  = "${var.editor-robot}"
  deletion_protection = false
  instance_template {
    platform_id = "standard-v1"
    resources {
      memory = 2
      cores  = 2
      core_fraction = 5
    }
    boot_disk {
      mode = "READ_WRITE"
      initialize_params {
        image_id = "${var.LAMP}"
        size     = 4
      }
    }
    network_interface {
      subnet_ids = ["${yandex_vpc_subnet.public.id}"]
      # nat        = true
    }

    metadata = {
      ssh-keys  = "ubuntu:${file("~/.ssh/id_rsa.pub")}"
      user-data = file("${path.module}/cloud_config.yaml")
    }
  }

  scale_policy {
    fixed_scale {
      size = 3
    }
  }

  allocation_policy {
    zones = ["ru-central1-a"]
  }

  deploy_policy {
    max_unavailable = 2
    max_creating    = 2
    max_expansion   = 2
    max_deleting    = 2
  }

  load_balancer {
    target_group_name = "lamp-target-group"
  }
}
