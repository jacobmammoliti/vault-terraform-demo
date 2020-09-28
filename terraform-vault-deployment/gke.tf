resource "google_service_account" "gke_service_account" {
  account_id   = var.gke_service_account_id
  display_name = "Service Account for Kubernetes Cluster"
}

resource "google_service_account_iam_member" "admin-account-iam" {
  service_account_id = google_service_account.gke_service_account.name
  role               = "roles/cloudkms.cryptoKeyEncrypterDecrypter"
  member             = "serviceAccount:${google_service_account.gke_service_account.email}"
}

resource "google_container_cluster" "kubernetes_cluster" {
  name     = var.cluster_name
  location = var.location
  project  = var.project_id

  initial_node_count = var.initial_node_count
  network            = var.network

  node_config {
    oauth_scopes = var.oauth_scopes

    metadata = {
      disable-legacy-endpoints = "true"
    }

    machine_type = var.machine_type
    preemptible  = var.preemptible
    service_account = google_service_account.gke_service_account.email
  }
}