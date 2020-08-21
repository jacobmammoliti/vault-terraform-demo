resource "kubernetes_namespace" "vault_primary" {
  metadata {
    name = "vault-primary"
  }
}

resource "kubernetes_namespace" "vault_secondary" {
  count = var.deploy_secondary == true ? 1 : 0

  metadata {
    name = "vault-secondary"
  }
}

resource "helm_release" "vault_primary" {
  name       = "vault-primary"
  repository = "https://helm.releases.hashicorp.com/"
  chart      = "vault"
  namespace  = kubernetes_namespace.vault_primary.metadata.0.name

  values = [
    templatefile("templates/values.tmpl", {
      replicas               = var.initial_node_count,
      enable_vault_ui        = var.enable_vault_ui,
      vault_service_type     = var.vault_service_type,
      tls_disable            = var.vault_tls_disable,
      gcp_kms_project_id     = var.gcp_kms_project_id,
      gcp_kms_region         = var.gcp_kms_region,
      gcp_kms_key_ring       = var.gcp_kms_key_ring,
      gcp_kms_crypto_key     = var.gcp_kms_crypto_key,
      vault_image_repository = var.vault_image_repository,
      vault_image_tag        = var.vault_image_tag
      vault_enable_audit     = var.vault_enable_audit
    })
  ]
}

resource "helm_release" "vault_secondary" {
  count = var.deploy_secondary == true ? 1 : 0

  name       = "vault-secondary"
  repository = "https://helm.releases.hashicorp.com/"
  chart      = "vault"
  namespace  = kubernetes_namespace.vault_secondary.0.metadata.0.name

  values = [
    templatefile("templates/values.tmpl", {
      replicas               = var.initial_node_count,
      enable_vault_ui        = var.enable_vault_ui,
      vault_service_type     = var.vault_service_type,
      tls_disable            = var.vault_tls_disable,
      gcp_kms_project_id     = var.gcp_kms_project_id,
      gcp_kms_region         = var.gcp_kms_region,
      gcp_kms_key_ring       = var.gcp_kms_key_ring,
      gcp_kms_crypto_key     = var.gcp_kms_crypto_key,
      vault_image_repository = var.vault_image_repository,
      vault_image_tag        = var.vault_image_tag
      vault_enable_audit     = var.vault_enable_audit
    })
  ]
}

resource "kubernetes_secret" "vault_tls_primary" {
  metadata {
    name      = "tls"
    namespace = kubernetes_namespace.vault_primary.metadata.0.name
  }

  data = {
    "tls_crt" = tls_self_signed_cert.primary_cert.cert_pem,
    "tls_key" = tls_private_key.cert.private_key_pem
  }
}

resource "kubernetes_secret" "vault_tls_secondary" {
  count = var.deploy_secondary == true ? 1 : 0

  metadata {
    name      = "tls"
    namespace = kubernetes_namespace.vault_secondary.0.metadata.0.name
  }

  data = {
    "tls_crt" = tls_self_signed_cert.secondary_cert.0.cert_pem,
    "tls_key" = tls_private_key.cert.private_key_pem
  }
}
