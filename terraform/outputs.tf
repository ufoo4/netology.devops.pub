output "internal_ip_address_vm01" {
  value = "${yandex_compute_instance.vm01.network_interface.0.ip_address}"
}

output "instance_id" {
  value       = "${yandex_compute_instance.vm01.id}" 
}
