resource "yandex_mdb_mysql_cluster" "mysql-cluster" {
  name                = "mysql-cluster"
  environment         = "PRESTABLE"
  network_id          = yandex_vpc_network.net.id
  version             = "8.0"
  deletion_protection = true

  resources {
    resource_preset_id  = "b1.medium"
    disk_type_id        = "network-hdd"
    disk_size           = 20
  }

  maintenance_window {
    type = "ANYTIME"
  }

  backup_window_start {
    hours   = "23"
    minutes = "59"
  }

  host {
    zone      = yandex_vpc_subnet.private-subnet-a.zone
    subnet_id = yandex_vpc_subnet.private-subnet-a.id
  }

  host {
    zone      = yandex_vpc_subnet.private-subnet-b.zone
    subnet_id = yandex_vpc_subnet.private-subnet-b.id
  }

  host {
    zone      = yandex_vpc_subnet.private-subnet-c.zone
    subnet_id = yandex_vpc_subnet.private-subnet-c.id
  }
}
