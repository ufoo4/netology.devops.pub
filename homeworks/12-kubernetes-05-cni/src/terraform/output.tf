output "internal_ip_address_node01_yandex_cloud" {
  value = "${yandex_compute_instance.node01.network_interface.0.ip_address}"
}

output "external_ip_address_node01_yandex_cloud" {
  value = "${yandex_compute_instance.node01.network_interface.0.nat_ip_address}"
}

output "internal_ip_address_node03_yandex_cloud" {
  value = "${yandex_compute_instance.node03.network_interface.0.ip_address}"
}

output "external_ip_address_node03_yandex_cloud" {
  value = "${yandex_compute_instance.node03.network_interface.0.nat_ip_address}"
}

output "internal_ip_address_node04_yandex_cloud" {
  value = "${yandex_compute_instance.node04.network_interface.0.ip_address}"
}

output "external_ip_address_node04_yandex_cloud" {
  value = "${yandex_compute_instance.node04.network_interface.0.nat_ip_address}"
}
