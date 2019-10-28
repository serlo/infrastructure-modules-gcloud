#####################################################################
# variables for google cloud
#####################################################################
variable "project" {
  description = "The project the cluster is setup in."
}

variable "clustername" {
  description = "The name of the cluster."
}

variable "location" {
  description = "The location (region or zone) in which the cluster master will be created, as well as the default node location."
}

variable "region" {
  description = "The region that the cluster master and nodes should be created in."
}

variable "machine_type" {
  description = "The name of a Google Compute Engine machine type."
}

variable "issue_client_certificate" {
  type        = bool
  description = "Create client certificates which finally means create a new cluster"
}

variable "logging_service" {
  default = "logging.googleapis.com"
}

variable "monitoring_service" {
  default = "monitoring.googleapis.com"
}