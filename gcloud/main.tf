#####################################################################
# google kubernetes engine cluster
#####################################################################
data "google_client_config" "default" {}

resource "google_compute_address" "staticip_regional" {
  name   = "${var.clustername}-staticip-regional"
  region = "${var.region}"
}

resource "google_container_cluster" "primary" {
  name       = "${var.clustername}"
  zone       = "${var.zone}"
  project    = "${var.project}"
  network    = google_compute_network.vpc_network.self_link
  subnetwork = google_compute_subnetwork.vpc_subnetwork.self_link

  ip_allocation_policy {
    #Pod IPs
    cluster_secondary_range_name = google_compute_subnetwork.vpc_subnetwork.secondary_ip_range[0].range_name
    #Service IPs
    services_secondary_range_name = google_compute_subnetwork.vpc_subnetwork.secondary_ip_range[0].range_name
  }

  # Setting an empty username and password explicitly disables basic auth
  master_auth {
    client_certificate_config {
      issue_client_certificate = var.issue_client_certificate
    }

    username = ""
    password = ""
  }


  maintenance_policy {
    daily_maintenance_window {
      start_time = "01:00"
    }
  }

  addons_config {
    http_load_balancing {
      disabled = false
    }

    horizontal_pod_autoscaling {
      disabled = true
    }

    kubernetes_dashboard {
      disabled = true
    }
  }

  node_pool {
    name               = "default-pool"
    initial_node_count = 2

    autoscaling {
      min_node_count = 2
      max_node_count = 10
    }

    management {
      auto_repair  = true
      auto_upgrade = true
    }

    node_config {
      preemptible     = false
      service_account = google_service_account.service_account.email
      machine_type    = "${var.machine_type}"

      oauth_scopes = [
        "https://www.googleapis.com/auth/compute",
        "https://www.googleapis.com/auth/devstorage.read_only",
        "https://www.googleapis.com/auth/logging.write",
        "https://www.googleapis.com/auth/monitoring"
      ]
    }
  }

  logging_service    = var.logging_service
  monitoring_service = var.monitoring_service
  enable_legacy_abac = true
}

# Network
resource "google_compute_network" "vpc_network" {
  name                    = "default-network"
  project                 = var.project
  routing_mode            = "REGIONAL"
  auto_create_subnetworks = "false"
}

resource "google_compute_subnetwork" "vpc_subnetwork" {
  name = "default-subnetwork"

  project                  = var.project
  region                   = var.region
  private_ip_google_access = true
  network                  = google_compute_network.vpc_network.self_link
  ip_cidr_range            = cidrsubnet("10.1.0.0/16", 4, 0)
  secondary_ip_range {
    range_name    = "public-services"
    ip_cidr_range = cidrsubnet("10.2.0.0/16", 4, 0)
  }
  enable_flow_logs = false
}

# service account
resource "google_service_account" "service_account" {
  project      = var.project
  account_id   = "cluster-service-account"
  display_name = "service account for kubernetes cluster"
}

resource "google_project_iam_member" "service_account-log_writer" {
  project = google_service_account.service_account.project
  role    = "roles/logging.logWriter"
  member  = "serviceAccount:${google_service_account.service_account.email}"
}

resource "google_project_iam_member" "service_account-metric_writer" {
  project = google_service_account.service_account.project
  role    = "roles/monitoring.metricWriter"
  member  = "serviceAccount:${google_service_account.service_account.email}"
}

resource "google_project_iam_member" "service_account-monitoring_viewer" {
  project = google_service_account.service_account.project
  role    = "roles/monitoring.viewer"
  member  = "serviceAccount:${google_service_account.service_account.email}"
}

resource "google_project_iam_member" "service_account-stackdriver_resourceMetadata_writer" {
  project = google_service_account.service_account.project
  role    = "roles/stackdriver.resourceMetadata.writer"
  member  = "serviceAccount:${google_service_account.service_account.email}"
}

resource "google_compute_global_address" "private_ip_address" {
  provider      = "google-beta"
  name          = "private-ip-address"
  purpose       = "VPC_PEERING"
  address_type  = "INTERNAL"
  prefix_length = 16
  network       = "${google_compute_network.vpc_network.self_link}"
}
