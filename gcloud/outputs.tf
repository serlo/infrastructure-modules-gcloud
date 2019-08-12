# The following outputs allow authentication and connectivity to the GKE Cluster
# by using certificate-based authentication.
output "client_certificate" {
  value = "${google_container_cluster.primary.master_auth.0.client_certificate}"
}

output "client_key" {
  value = "${google_container_cluster.primary.master_auth.0.client_key}"
}

output "cluster_ca_certificate" {
  value = "${google_container_cluster.primary.master_auth.0.cluster_ca_certificate}"
}

output "host" {
  value     = "${google_container_cluster.primary.endpoint}"
  sensitive = true
}

output "staticip_regional_address" {
  value = "${google_compute_address.staticip_regional.address}"
}

output "staticip_regional_name" {
  value = "${google_compute_address.staticip_regional.name}"
}

output "network" {
  value = "${google_compute_network.vpc_network.self_link}"
}

output "private_ip_address_range" {
  value = "${google_compute_global_address.private_ip_address.name}"
}