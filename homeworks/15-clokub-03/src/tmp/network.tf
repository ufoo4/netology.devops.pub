resource "yandex_vpc_network" "default" {
  name = "net"
}

resource "yandex_vpc_gateway" "nat-instance" {
  name = "nat-instance"
  shared_egress_gateway {}
}

resource "yandex_vpc_route_table" "private-inet" {
  name = "private-inet"
  network_id = "${yandex_vpc_network.default.id}"

  static_route {
    destination_prefix = "0.0.0.0/0"
    gateway_id         = "${yandex_vpc_gateway.nat-instance.id}"
  }
}

resource "yandex_vpc_subnet" "public" {
  name           = "public"
  zone           = "ru-central1-a"
  network_id     = "${yandex_vpc_network.default.id}"
  v4_cidr_blocks = ["192.168.10.0/24"]
}

resource "yandex_vpc_subnet" "private" {
  name           = "private"
  zone           = "ru-central1-a"
  network_id     = "${yandex_vpc_network.default.id}"
  route_table_id = "${yandex_vpc_route_table.private-inet.id}"
  v4_cidr_blocks = ["192.168.20.0/24"]
}
