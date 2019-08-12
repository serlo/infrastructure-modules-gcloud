resource "google_service_account" "dbdump_writer" {
  account_id   = "dbdump-writer"
  display_name = "DBDump Writer - Generated by Terraform"
}

resource "google_service_account_key" "dbdump_writer_key" {
  service_account_id = "${google_service_account.dbdump_writer.name}"
}

resource "google_storage_bucket_iam_binding" "dbdump_writer_binding" {
  bucket = "anonymous-data"
  role   = "roles/storage.objectAdmin"

  members = ["serviceAccount:${google_service_account.dbdump_writer.email}"]
}