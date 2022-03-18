#------------------------------------------------------------------------------
# Kubernetes resources
#------------------------------------------------------------------------------
resource "kubernetes_namespace" "vault" {
  depends_on = [google_container_cluster.vault]

  metadata {
    name = var.kubernetes_namespace
  }
}

resource "kubernetes_secret" "tls" {
  metadata {
    name      = "tls"
    namespace = kubernetes_namespace.vault.metadata.0.name
  }

  data = {
    "tls.crt" = local.generate_tls_certs ? tls_locally_signed_cert.vault_signed_certificate[0].cert_pem : data.google_secret_manager_secret_version.vault_api_signed_certificate.secret_data
    "tls.key" = local.generate_tls_certs ? tls_private_key.vault_private_key[0].private_key_pem : data.google_secret_manager_secret_version.vault_api_private_key.secret_data
  }

  type = "kubernetes.io/tls"
}

resource "kubernetes_secret" "tls_ca" {
  metadata {
    name      = "tls-ca"
    namespace = kubernetes_namespace.vault.metadata.0.name
  }

  data = {
    "ca.crt" = local.generate_tls_certs ? tls_self_signed_cert.ca[0].cert_pem : data.google_secret_manager_secret_version.vault_api_ca_bundle.secret_data
  }
}

resource "kubernetes_secret" "kms_data" {
  metadata {
    name      = "gcp-kms-info"
    namespace = kubernetes_namespace.vault.metadata.0.name
  }

  data = {
    for key, value in var.vault_kms_seal_config : upper(key) => lower(value)
  }
}

resource "kubernetes_secret" "vault_license" {
  count = var.vault_license != null ? 1 : 0

  metadata {
    name      = "vault-license"
    namespace = kubernetes_namespace.vault.metadata.0.name
  }

  data = {
    "license.hclic" = data.google_secret_manager_secret_version.vault_license[0].secret_data
  }
}

resource "kubernetes_service_account" "vault" {
  metadata {
    name        = var.kubernetes_sa_name
    namespace   = var.kubernetes_namespace
    annotations = var.use_google_workload_identity ? { "iam.gke.io/gcp-service-account" = google_service_account.vault_sa.email } : null
  }
}

#------------------------------------------------------------------------------
# Vault deployment
#------------------------------------------------------------------------------
resource "helm_release" "vault" {
  name       = var.helm_release_name
  repository = var.helm_repository
  chart      = var.helm_chart_name
  namespace  = var.kubernetes_namespace

  values = [
    templatefile("templates/values.tmpl", {
      helm_release_name = var.helm_release_name

      kubernetes_namespace                          = var.kubernetes_namespace
      kubernetes_vault_service_account              = kubernetes_service_account.vault.metadata.0.name
      kubernetes_secret_name_tls_cert               = kubernetes_secret.tls.metadata.0.name
      kubernetes_secret_name_tls_ca                 = kubernetes_secret.tls_ca.metadata.0.name
      kubernetes_secret_name_vault_license          = var.vault_license != null ? kubernetes_secret.vault_license[0].metadata.0.name : null
      kubernetes_image_pull_secrets                 = var.kubernetes_image_pull_secrets
      kubernetes_extra_secret_environment_variables = var.kubernetes_extra_secret_environment_variables
      kubernetes_vault_server_service_type          = var.kubernetes_vault_server_service_type
      kubernetes_vault_ui_service_type              = var.kubernetes_vault_ui_service_type

      vault_replica_count             = var.gke_node_count
      vault_injector_enable           = var.vault_injector_enable
      vault_injector_image_repository = var.vault_injector_image_repository
      vault_injector_image_tag        = var.vault_injector_image_tag
      vault_image_repository          = var.vault_image_repository
      vault_image_tag                 = var.vault_image_tag
      vault_data_storage_size         = var.vault_data_storage_size
      vault_leader_tls_servername     = var.vault_leader_tls_servername
      vault_seal_method               = var.vault_seal_method
    })
  ]
}