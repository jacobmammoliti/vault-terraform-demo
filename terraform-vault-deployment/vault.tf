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
      tls_disable        = var.vault_tls_disable
    })
  ]
}

resource "tls_private_key" "cert" {
  algorithm   = "RSA"
  ecdsa_curve = "P384"
  rsa_bits    = "2048"
}

resource "tls_self_signed_cert" "cert" {
  key_algorithm   = tls_private_key.cert.algorithm
  private_key_pem = tls_private_key.cert.private_key_pem

  validity_period_hours = 12

  allowed_uses = [
    "key_encipherment",
    "digital_signature",
  ]

  dns_names = [var.hostname]

  subject {
    common_name  = var.hostname
    organization = "Arctiq (NonTrusted)"
  }
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