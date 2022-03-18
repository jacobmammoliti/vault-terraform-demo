project_id                   = "accelerator-gcp-vault-ci-001"
network                      = "default"
vault_api_signed_certificate = "signed_certificate"
vault_api_private_key        = "certificate_private_key"
vault_api_ca_bundle          = "ca_bundle"
vault_seal_method            = "gcpckms"
vault_leader_tls_servername  = "vault.hashicorp.com"
use_google_workload_identity = true

vault_kms_seal_config = {
  "GOOGLE_PROJECT"                = "accelerator-gcp-vault-ci-001"
  "GOOGLE_REGION"                 = "northamerica-northeast2"
  "VAULT_GCPCKMS_SEAL_KEY_RING"   = "vault"
  "VAULT_GCPCKMS_SEAL_CRYPTO_KEY" = "vault-key"
}

kubernetes_extra_secret_environment_variables = [
  {
    envName    = "GOOGLE_PROJECT",
    secretName = "gcp-kms-info",
    secretKey  = "GOOGLE_PROJECT"
  },
  {
    envName    = "GOOGLE_REGION",
    secretName = "gcp-kms-info",
    secretKey  = "GOOGLE_REGION"
  },
  {
    envName    = "VAULT_GCPCKMS_SEAL_KEY_RING",
    secretName = "gcp-kms-info",
    secretKey  = "VAULT_GCPCKMS_SEAL_KEY_RING"
  },
  {
    envName    = "VAULT_GCPCKMS_SEAL_CRYPTO_KEY",
    secretName = "gcp-kms-info",
    secretKey  = "VAULT_GCPCKMS_SEAL_CRYPTO_KEY"
  }
]