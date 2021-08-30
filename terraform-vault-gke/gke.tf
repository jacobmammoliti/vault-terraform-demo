resource "google_project_service" "cloudresourcemanager" {
  service = "cloudresourcemanager.googleapis.com"

  disable_dependent_services = true
}

resource "google_service_account" "vault-sa" {
  account_id   = "vault-service-account"
  display_name = "Vault Service Account"
}

resource "google_project_iam_member" "vault-sa-iam" {
  depends_on = [google_project_service.cloudresourcemanager]

  role   = "roles/storage.objectAdmin"
  member = "serviceAccount:${google_service_account.vault-sa.email}"
}

resource "google_container_cluster" "vault" {
  depends_on = [google_project_iam_member.vault-sa-iam]

  name     = var.cluster_name
  location = "${var.region}-${var.zone[0]}"

  initial_node_count = var.node_count
  network            = var.network

  node_config {
    preemptible  = var.preemptible
    machine_type = var.machine_type

    service_account = google_service_account.vault-sa.email
    oauth_scopes    = var.oauth_scopes

    metadata = {
      disable-legacy-endpoints = true
    }
  }
}