provider "google" {}

provider "kubernetes" {
  host  = format("https://%s", google_container_cluster.vault.endpoint)
  token = data.google_client_config.default.access_token

  cluster_ca_certificate = base64decode(
    google_container_cluster.vault.master_auth.0.cluster_ca_certificate
  )
}

provider "helm" {
  kubernetes {
    host  = format("https://%s", google_container_cluster.vault.endpoint)
    token = data.google_client_config.default.access_token

    cluster_ca_certificate = base64decode(
      google_container_cluster.vault.master_auth.0.cluster_ca_certificate
    )
  }
}