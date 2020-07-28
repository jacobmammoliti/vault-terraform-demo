resource "kubernetes_namespace" "vault" {
  metadata {
    name = "vault"
  }
}

resource "helm_release" "vault" {
  depends_on = [google_kms_crypto_key.vault_crypto_key]
  name       = "vault"
  repository = "https://helm.releases.hashicorp.com/"
  chart      = "vault"
  namespace  = kubernetes_namespace.vault.metadata.0.name

  values = [
    templatefile("templates/values.tmpl", {
      replicas           = var.initial_node_count,
      enable_vault_ui    = var.enable_vault_ui,
      vault_service_type = var.vault_service_type,
      tls_disable        = var.vault_tls_disable,
      gcp_kms_project_id = var.gcp_kms_project_id,
      gcp_kms_region     = var.gcp_kms_region,
      gcp_kms_key_ring   = var.gcp_kms_key_ring,
      gcp_kms_crypto_key = var.gcp_kms_crypto_key
    })
  ]
}

resource "kubernetes_secret" "vault_tls" {
  metadata {
    name      = "tls"
    namespace = "vault"
  }

  data = {
    "tls_crt" = tls_self_signed_cert.cert.cert_pem,
    "tls_key" = tls_private_key.cert.private_key_pem
  }
}