provider "google" {
}

provider "kubernetes" {
  load_config_file = "false"
  host             = google_container_cluster.kubernetes_cluster.endpoint
  token            = data.google_client_config.default.access_token

  cluster_ca_certificate = base64decode(
    google_container_cluster.kubernetes_cluster.master_auth.0.cluster_ca_certificate
  )
}

provider "helm" {
  kubernetes {
    load_config_file = "false"
    host             = google_container_cluster.kubernetes_cluster.endpoint
    token            = data.google_client_config.default.access_token

    cluster_ca_certificate = base64decode(
      google_container_cluster.kubernetes_cluster.master_auth.0.cluster_ca_certificate
    )
  }
}