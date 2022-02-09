output "external_ips" {
  value = [ for v in yandex_compute_instance.vm-app : v.network_interface.0.nat_ip_address ]
}
output "internal_ips" {
  value = [ for v in yandex_compute_instance.vm-app : v.network_interface.0.ip_address ]
}
