resource "kubernetes_namespace" "vault" {
  metadata {
    name = "vault"
  }
}

resource "helm_release" "vault" {
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
      gcp_kms_key_ring   = google_kms_key_ring.vault_key_ring.self_link,
      gcp_kms_crypto_key = google_kms_crypto_key.vault_crypto_key.self_link
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