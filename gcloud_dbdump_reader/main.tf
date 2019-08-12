resource "google_service_account" "dbdump_reader" {
  account_id   = "dbdump-reader"
  display_name = "DBDump Reader - Generated by Terraform"
}

resource "google_service_account_key" "dbdump_reader_key" {
  service_account_id = "${google_service_account.dbdump_reader.name}"
}

resource "google_storage_bucket_iam_binding" "dbdump_reader_binding" {
  bucket = "anonymous-data"
  role   = "roles/storage.objectViewer"

  members = ["serviceAccount:${google_service_account.dbdump_reader.email}"]
}