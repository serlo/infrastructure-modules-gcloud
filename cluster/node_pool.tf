# Manages the node pool used by the Google Kubernetes Engine (GKE) cluster
#
# see https://www.terraform.io/docs/providers/google/r/container_node_pool.html
# see https://www.terraform.io/docs/providers/google/r/container_cluster.html#node_pool
resource "google_container_node_pool" "cluster" {
  name               = var.name
  location           = var.location
  cluster            = google_container_cluster.cluster.name
  initial_node_count = var.node_pool.initial_node_count

  node_config {
    machine_type    = var.node_pool.machine_type
    preemptible     = var.node_pool.preemptible
    service_account = google_service_account.cluster.email

    metadata = {
      disable-legacy-endpoints = "true"
    }

    oauth_scopes = [
      "https://www.googleapis.com/auth/devstorage.read_only",
      "https://www.googleapis.com/auth/logging.write",
      "https://www.googleapis.com/auth/monitoring",
    ]
  }

  autoscaling {
    min_node_count = var.node_pool.min_node_count
    max_node_count = var.node_pool.max_node_count
  }

  management {
    auto_repair  = true
    auto_upgrade = true
  }
}

variable "node_pool" {
  description = "Node pool configuration"
  type = object({
    machine_type       = string
    preemptible        = bool
    initial_node_count = number
    min_node_count     = number
    max_node_count     = number
  })
}
