#------------------------------------------------------------------------------
# Certificate Authority
#------------------------------------------------------------------------------
resource "tls_private_key" "ca" {
  count = var.vault_tls_disable ? 0 : 1

  algorithm   = "RSA"
  ecdsa_curve = "P384"
  rsa_bits    = "2048"
}

resource "tls_self_signed_cert" "ca" {
  count = var.vault_tls_disable ? 0 : 1

  key_algorithm         = tls_private_key.ca[0].algorithm
  private_key_pem       = tls_private_key.ca[0].private_key_pem
  is_ca_certificate     = true
  validity_period_hours = "168"

  allowed_uses = [
    "cert_signing",
    "key_encipherment",
    "digital_signature"
  ]

  subject {
    organization = "HashiCorp (NonTrusted)"
    common_name  = "HashiCorp (NonTrusted) Private Certificate Authority"
    country      = "CA"
  }
}

#------------------------------------------------------------------------------
# Certificate
#------------------------------------------------------------------------------
resource "tls_private_key" "vault_private_key" {
  count = var.vault_tls_disable ? 0 : 1

  algorithm   = "RSA"
  ecdsa_curve = "P384"
  rsa_bits    = "2048"
}

resource "tls_cert_request" "vault_cert_request" {
  count = var.vault_tls_disable ? 0 : 1

  key_algorithm   = tls_private_key.vault_private_key[0].algorithm
  private_key_pem = tls_private_key.vault_private_key[0].private_key_pem

  dns_names = [for i in range(var.node_count) : format("vault-%s.%s-internal", i, var.helm_chart_name)]

  subject {
    common_name  = "HashiCorp Vault Certificate"
    organization = "HashiCorp Vault Certificate"
  }
}

resource "tls_locally_signed_cert" "vault_certificate" {
  count = var.vault_tls_disable ? 0 : 1

  cert_request_pem   = tls_cert_request.vault_cert_request[0].cert_request_pem
  ca_key_algorithm   = tls_private_key.ca[0].algorithm
  ca_private_key_pem = tls_private_key.ca[0].private_key_pem
  ca_cert_pem        = tls_self_signed_cert.ca[0].cert_pem

  validity_period_hours = "168"

  allowed_uses = [
    "key_encipherment",
    "digital_signature",
  ]
}