data "google_client_config" "default" {}

data "google_secret_manager_secret_version" "vault_api_signed_certificate" {
  project = var.project_id
  secret  = var.vault_api_signed_certificate
}

data "google_secret_manager_secret_version" "vault_api_private_key" {
  project = var.project_id
  secret  = var.vault_api_private_key
}

data "google_secret_manager_secret_version" "vault_api_ca_bundle" {
  project = var.project_id
  secret  = var.vault_api_ca_bundle
}

data "google_secret_manager_secret_version" "vault_license" {
  count = var.vault_license != null ? 1 : 0

  project = var.project_id
  secret  = var.vault_license
}