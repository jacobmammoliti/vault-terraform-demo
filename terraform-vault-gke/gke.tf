#------------------------------------------------------------------------------
# Service Account
#------------------------------------------------------------------------------
resource "google_project_service" "cloudresourcemanager" {
  service = "cloudresourcemanager.googleapis.com"

  disable_dependent_services = true
}

resource "google_service_account" "vault_sa" {
  account_id   = "vault-service-account"
  display_name = "Vault Service Account"
}

resource "google_project_iam_member" "vault_sa_iam" {
  depends_on = [google_project_service.cloudresourcemanager]
  for_each   = toset(var.google_service_account_iam_roles)

  role   = each.value
  member = format("serviceAccount:%s", google_service_account.vault_sa.email)
}

#------------------------------------------------------------------------------
# Compute
#------------------------------------------------------------------------------
resource "google_container_cluster" "vault" {
  depends_on = [google_project_iam_member.vault_sa_iam]

  name     = var.cluster_name
  location = format("%s-%s", var.region, var.zone[0])

  initial_node_count = var.node_count
  network            = var.network

  node_config {
    preemptible  = var.preemptible
    machine_type = var.machine_type

    service_account = google_service_account.vault_sa.email
    oauth_scopes    = var.oauth_scopes

    metadata = {
      disable-legacy-endpoints = true
    }
  }
}