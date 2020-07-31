# resource "google_kms_key_ring" "vault_key_ring" {
#   project  = var.gcp_kms_project_id
#   name     = var.gcp_kms_key_ring
#   location = var.gcp_kms_region
# }

# resource "google_kms_crypto_key" "vault_crypto_key" {
#   name     = var.gcp_kms_crypto_key
#   key_ring = google_kms_key_ring.vault_key_ring.self_link
# }