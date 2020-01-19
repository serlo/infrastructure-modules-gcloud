# Manages the VCP network used by the cluster
#
# see https://www.terraform.io/docs/providers/google/r/compute_network.html
resource "google_compute_network" "cluster" {
  name                    = var.name
  routing_mode            = "REGIONAL"
  auto_create_subnetworks = false
}

# see https://www.terraform.io/docs/providers/google/r/compute_subnetwork.html
# see https://cloud.google.com/kubernetes-engine/docs/how-to/alias-ips#cluster_sizing
resource "google_compute_subnetwork" "cluster" {
  name                     = var.name
  region                   = var.region
  private_ip_google_access = true
  network                  = google_compute_network.cluster.self_link

  # IP address range for nodes, must not overlap with the ranges for pods or services
  ip_cidr_range = "10.0.0.0/20" # 10.0.0.0 - 10.0.15.255

  # IP adress range for pods, must not overlap with the ranges for nodes or services
  secondary_ip_range {
    range_name    = "pods"
    ip_cidr_range = "10.4.0.0/14" # 10.4.0.0 - 10.7.255.255
  }

  # IP address range for services, must not overlap with the ranges for nodes or pods
  secondary_ip_range {
    range_name    = "services"
    ip_cidr_range = "10.1.0.0/20" # 10.1.0.0 - 10.1.15.255
  }
}

output "network" {
  description = "VCP network used by the cluster"
  value       = google_compute_network.cluster.self_link
}
