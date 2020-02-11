resource "google_container_cluster" "kubernetes_cluster" {
  name     = var.cluster_name
  project  = var.project
  location = var.location

  initial_node_count = var.initial_node_count
  network            = var.network

  node_config {
    machine_type = var.machine_type

    oauth_scopes = [
      "https://www.googleapis.com/auth/compute",
      "https://www.googleapis.com/auth/devstorage.read_only",
      "https://www.googleapis.com/auth/logging.write",
      "https://www.googleapis.com/auth/monitoring",
    ]
  }
}