#------------------------------------------------------------------------------
# Service Account and IAM Permissions
#------------------------------------------------------------------------------
resource "google_service_account" "vault_sa" {
  account_id   = "vault-service-account"
  display_name = "HashiCorp Vault Service Account"
}

resource "google_project_iam_member" "vault_sa" {
  project  = var.project_id
  for_each = toset(var.google_service_account_iam_roles)

  role   = each.value
  member = format("serviceAccount:%s", google_service_account.vault_sa.email)
}

# IAM binding for Workload Identity
resource "google_service_account_iam_binding" "vault_sa" {
  count = var.google_workload_identity == true ? 1 : 0

  service_account_id = google_service_account.vault_sa.name
  role               = "roles/iam.workloadIdentityUser"

  members = [
    format("serviceAccount:%s.svc.id.goog[%s/%s]", var.project_id, var.kubernetes_namespace, var.kubernetes_sa_name)
  ]
}

#------------------------------------------------------------------------------
# GKE Cluster
#------------------------------------------------------------------------------
resource "google_container_cluster" "vault" {
  depends_on = [google_service_account_iam_binding.vault_sa]

  name     = var.cluster_name
  location = format("%s-%s", var.region, var.zone[0])

  initial_node_count = var.node_count
  network            = var.network

  node_config {
    preemptible  = var.preemptible
    machine_type = var.machine_type

    service_account = var.google_workload_identity == true ? null : google_service_account.vault_sa.email
    oauth_scopes    = var.google_workload_identity == true ? null : var.oauth_scopes

    metadata = {
      disable-legacy-endpoints = true
    }
  }
  
  dynamic "workload_identity_config" {
    for_each = var.google_workload_identity == true ? [true] : []
    content {
      workload_pool = format("%s.svc.id.goog", var.project_id)
    }
  }
}