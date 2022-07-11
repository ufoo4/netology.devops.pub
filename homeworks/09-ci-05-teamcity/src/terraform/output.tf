output "internal_ip_address_teamcity-server" {
  value = "${yandex_compute_instance.teamcity-server.network_interface.0.ip_address}"
}

output "external_ip_address_teamcity-server" {
  value = "${yandex_compute_instance.teamcity-server.network_interface.0.nat_ip_address}"
}

output "internal_ip_address_teamcity-agent" {
  value = "${yandex_compute_instance.teamcity-agent.network_interface.0.ip_address}"
}

output "external_ip_address_teamcity-agent" {
  value = "${yandex_compute_instance.teamcity-agent.network_interface.0.nat_ip_address}"
}

output "internal_ip_address_nexus" {
  value = "${yandex_compute_instance.nexus.network_interface.0.ip_address}"
}

output "external_ip_address_nexus" {
  value = "${yandex_compute_instance.nexus.network_interface.0.nat_ip_address}"
}
