provider "google" {
  project = var.project_id
}

provider "kubernetes" {
  host  = google_container_cluster.vault.endpoint
  token = data.google_client_config.default.access_token

  cluster_ca_certificate = base64decode(
    google_container_cluster.vault.master_auth.0.cluster_ca_certificate
  )
}

provider "helm" {
  kubernetes {
    host  = google_container_cluster.vault.endpoint
    token = data.google_client_config.default.access_token

    cluster_ca_certificate = base64decode(
      google_container_cluster.vault.master_auth.0.cluster_ca_certificate
    )
  }
}