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
  }
}