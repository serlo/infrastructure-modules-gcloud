# Reserves an internal IP address range that is used for VPC Network Peering to connect to Cloud SQL instances
#
# see https://www.terraform.io/docs/providers/google/r/compute_global_address.html
# see https://cloud.google.com/vpc/docs/vpc-peering
resource "google_compute_global_address" "reserved_peering_range" {
  name          = "${var.name}-peering"
  address_type  = "INTERNAL"
  purpose       = "VPC_PEERING"
  prefix_length = 14
  network       = google_compute_network.cluster.self_link
}

output "reserved_peering_range" {
  description = "Reserved internal IP address range for VCP Network Peering"
  value = google_compute_global_address.reserved_peering_range
}
