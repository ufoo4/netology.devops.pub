terraform {
  required_providers {
    yandex = {
      source  = "yandex-cloud/yandex"
      version = "0.61.0"
    }
  }
  backend "s3" {
    endpoint   = "storage.yandexcloud.net"
    bucket     = "netology-backet"
    region     = "ru-central1-a"
    key        = "terraform.tfstate.d/terraform.tfstate"
    access_key = ""
    secret_key = ""

    skip_region_validation      = true
    skip_credentials_validation = true
  }
}

provider "yandex" {
  cloud_id  = var.yc_cloud_id
  zone      = var.yc_region
}

data "yandex_compute_image" "image" {
  family = "centos-8"
}

locals {
  instance_type_count = {
    stage = 1
    prod  = 2
  }
  cores = {
    stage = 2
    prod  = 2
  }
  memory = {
    stage = 1
    prod  = 2
  }
  disk_size = {
    stage = 10
    prod  = 20
  }

  instance_type_for-each  = {
    stage = toset(["node1"]),
    prod  = toset(["node1", "node2", "node3"])
  }

  vpc_subnets = {
    stage = [
      {
        zone           = var.yc_region
        v4_cidr_blocks = ["10.128.0.0/24"]
      },
    ]
    prod = [
      {
        zone           = var.yc_region
        v4_cidr_blocks = ["10.128.0.0/24"]
      },
    ]
  }
}

module "vpc" {
  source        = "hamnsk/vpc/yandex"
  version       = "0.5.0"
  description   = "managed by terraform"
  create_folder = length(var.yc_folder_id) > 0 ? false : true
  name          = terraform.workspace
  subnets       = local.vpc_subnets[terraform.workspace]
}

# COUNT
resource yandex_compute_instance "count_vm" {
  count       = local.instance_type_count[terraform.workspace]
  name        = "${format("count-vm-%01d", count.index + 1)}"
  folder_id   = module.vpc.folder_id
  platform_id = "standard-v1"

  resources {
    cores         = local.cores[terraform.workspace]
    memory        = local.memory[terraform.workspace]
    core_fraction = 5
  }

  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.image.id
      type     = "network-hdd"
      size     = local.disk_size[terraform.workspace]
    }
  }

  network_interface {
    subnet_id = module.vpc.subnet_ids[0]
    nat       = true
  }

  metadata = {
    ssh-keys = "centos:${file("~/.ssh/id_rsa.pub")}"
  }
}

#FOR_EACH
resource yandex_compute_instance "for-each_vm" {
  # for_each = {
  #   stage = { cores = "4", memory = "4", disk_size = "20" },
  #   prod  = { cores = "6", memory = "6", disk_size = "30" }
  # }

  for_each    = local.instance_type_for-each[terraform.workspace]
  name        = "for-each-vm-${each.key}"
  folder_id   = module.vpc.folder_id
  platform_id = "standard-v1"

  lifecycle {
    create_before_destroy = true
  }

  resources {
    cores         = local.cores[terraform.workspace]
    memory        = local.memory[terraform.workspace]
  }

  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.image.id
      type     = "network-hdd"
      size     = local.disk_size[terraform.workspace]
    }
  }

  network_interface {
    subnet_id = module.vpc.subnet_ids[0]
    nat       = true
  }

  metadata = {
    ssh-keys = "centos:${file("~/.ssh/id_rsa.pub")}"
  }
}
