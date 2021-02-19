resource "google_container_cluster" "vault" {
  name     = var.cluster_name
  location = "${var.region}-${var.zone[0]}"

  initial_node_count = var.node_count
  network            = var.network

  node_config {
    preemptible  = var.preemptible
    machine_type = var.machine_type

    oauth_scopes = var.oauth_scopes

    metadata = {
      disable-legacy-endpoints = true
    }
  }
}