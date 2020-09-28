resource "tls_private_key" "cert" {
  count       = var.vault_tls_disable == true ? 0 : 1
  algorithm   = "RSA"
  ecdsa_curve = "P384"
  rsa_bits    = "2048"
}

resource "tls_self_signed_cert" "primary_cert" {
  count           = var.vault_tls_disable == true ? 0 : 1
  key_algorithm   = tls_private_key.cert.algorithm
  private_key_pem = tls_private_key.cert.private_key_pem

  validity_period_hours = 12

  allowed_uses = [
    "key_encipherment",
    "digital_signature",
  ]

  dns_names = [var.domain]

  subject {
    common_name  = "${var.primary_hostname}.${var.domain}"
    organization = "Arctiq (NonTrusted)"
  }
}

resource "tls_self_signed_cert" "secondary_cert" {
  count = var.deploy_secondary == true ? 1 : 0

  key_algorithm   = tls_private_key.cert.algorithm
  private_key_pem = tls_private_key.cert.private_key_pem

  validity_period_hours = 12

  allowed_uses = [
    "key_encipherment",
    "digital_signature",
  ]

  dns_names = [var.domain]

  subject {
    common_name  = "${var.secondary_hostname}.${var.domain}"
    organization = "Arctiq (NonTrusted)"
  }
}