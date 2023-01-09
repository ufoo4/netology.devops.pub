output "internal_ip_address_node-external" {
  value = "${yandex_compute_instance.node-external.network_interface.0.ip_address}"
}

output "external_ip_address_node-external" {
  value = "${yandex_compute_instance.node-external.network_interface.0.nat_ip_address}"
}

output "internal_ip_address_node-internal" {
  value = "${yandex_compute_instance.node-internal.network_interface.0.ip_address}"
}

output "internal_ip_address_nat-instance" {
  value = "${yandex_compute_instance.nat-instance.network_interface.0.ip_address}"
}

output "external_ip_address_nat-instance" {
  value = "${yandex_compute_instance.nat-instance.network_interface.0.nat_ip_address}"
}

output "lamp_balancer_ip_address" {
  value = [yandex_lb_network_load_balancer.lamp-balancer.listener[*].external_address_spec[*].address]
}

output "lamp_nodes_ip_address" {
  value = [yandex_compute_instance_group.lamp-group.instances[*].network_interface[0].ip_address]
}
