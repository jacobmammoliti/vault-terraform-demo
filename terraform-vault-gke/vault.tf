resource "kubernetes_namespace" "vault" {
  depends_on = [google_container_cluster.vault]

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
      replicas                 = var.node_count,
      vault_namespace          = kubernetes_namespace.vault.metadata.0.name
      vault_ui                 = var.vault_ui,
      vault_service_type       = var.vault_service_type,
      tls_disable              = var.vault_tls_disable,
      vault_tls_secret_name    = kubernetes_secret.tls[0].metadata.0.name,
      vault_tls_ca_secret_name = kubernetes_secret.tls_ca[0].metadata.0.name,
      kms_project_id           = data.google_client_config.default.project,
      kms_region               = var.region,
      kms_key_ring             = var.kms_key_ring == null ? "" : var.kms_key_ring,
      kms_crypto_key           = var.kms_crypto_key == null ? "" : var.kms_crypto_key,
      vault_image_repository   = var.vault_image_repository,
      vault_image_tag          = var.vault_image_tag
      vault_enable_audit       = var.vault_enable_audit
    })
  ]
}

resource "kubernetes_secret" "tls" {
  count = var.vault_tls_disable ? 0 : 1

  metadata {
    name      = "tls"
    namespace = kubernetes_namespace.vault.metadata.0.name
  }

  data = {
    "tls.crt" = tls_locally_signed_cert.vault_certificate[0].cert_pem,
    "tls.key" = tls_private_key.vault_private_key[0].private_key_pem
  }

  type = "kubernetes.io/tls"
}

resource "kubernetes_secret" "tls_ca" {
  count = var.vault_tls_disable ? 0 : 1

  metadata {
    name      = "tls-ca"
    namespace = kubernetes_namespace.vault.metadata.0.name
  }

  data = {
    "ca.crt" = tls_self_signed_cert.ca[0].cert_pem
  }
}