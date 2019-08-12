variable "database_instance_name" {
  description = "Name for kpi database instance in GCP."
}

variable "database_name" {
  description = "Name for kpi database in GCP."
}

variable "database_connection_name" {
  description = "Name for kpi database connection in GCP."
}

variable "database_region" {
  description = "Region for kpi database."
}

variable "database_tier" {
  default     = "db-f1-micro"
  description = "Tier for kpi database. See https://cloud.google.com/sql/pricing#2nd-gen-pricing"
}

variable "database_password_postgres" {
  description = "Password for default postgres database user."
}
variable "database_username_default" {
  description = "Username for default database user."
}

variable "database_password_default" {
  description = "Username for default database user."
}

variable "database_username_readonly" {
  description = "Username for readonly database user."
}

variable "database_password_readonly" {
  description = "Password for readonly database user."
}

variable "database_private_network" {
  description = "The name or self_link of the Google Compute Engine private network to which the database is connected."
}

variable "private_ip_address_range" {
  type        = string
  description = "Name of private ip address range from gcloud"
}