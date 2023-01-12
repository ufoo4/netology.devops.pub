resource "yandex_vpc_network" "net" {
  name = "net"
}

resource "yandex_vpc_gateway" "nat-instance" {
  name = "nat-instance"
  shared_egress_gateway {}
}

resource "yandex_vpc_route_table" "private-to-inet" {
  name = "private-inet"
  network_id = "${yandex_vpc_network.net.id}"

  static_route {
    destination_prefix = "0.0.0.0/0"
    gateway_id         = "${yandex_vpc_gateway.nat-instance.id}"
  }
}

resource "yandex_vpc_subnet" "public-subnet-a" {
  name           = "public-a"
  zone           = "ru-central1-a"
  network_id     = "${yandex_vpc_network.net.id}"
  v4_cidr_blocks = ["192.168.10.0/24"]
}

resource "yandex_vpc_subnet" "public-subnet-b" {
  name           = "public-b"
  zone           = "ru-central1-b"
  network_id     = "${yandex_vpc_network.net.id}"
  v4_cidr_blocks = ["192.168.11.0/24"]
}

resource "yandex_vpc_subnet" "public-subnet-c" {
  name           = "public-c"
  zone           = "ru-central1-c"
  network_id     = "${yandex_vpc_network.net.id}"
  v4_cidr_blocks = ["192.168.12.0/24"]
}

resource "yandex_vpc_subnet" "private-subnet-a" {
  name           = "private-a"
  zone           = "ru-central1-a"
  network_id     = "${yandex_vpc_network.net.id}"
  route_table_id = "${yandex_vpc_route_table.private-to-inet.id}"
  v4_cidr_blocks = ["192.168.20.0/24"]
}

resource "yandex_vpc_subnet" "private-subnet-b" {
  name           = "private-b"
  zone           = "ru-central1-b"
  network_id     = "${yandex_vpc_network.net.id}"
  route_table_id = "${yandex_vpc_route_table.private-to-inet.id}"
  v4_cidr_blocks = ["192.168.21.0/24"]
}

resource "yandex_vpc_subnet" "private-subnet-c" {
  name           = "private-c"
  zone           = "ru-central1-c"
  network_id     = "${yandex_vpc_network.net.id}"
  route_table_id = "${yandex_vpc_route_table.private-to-inet.id}"
  v4_cidr_blocks = ["192.168.22.0/24"]
}
