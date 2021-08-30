variable "project_id" {
  type        = string
  description = "The project ID to host the cluster in (required)"
}

variable "cluster_name" {
  type        = string
  description = "The name of the cluster"
  default     = "vault"
}

variable "region" {
  type        = string
  description = "The region to host the cluster in"
  default     = "us-central1"
}

variable "zone" {
  type        = list(string)
  description = "The zones to host the cluster in"
  default     = ["a", "c", "d", "f"]
}

variable "node_count" {
  type        = number
  description = "The number of nodes to create in this cluster's default node pool"
  default     = 3
}

variable "network" {
  type        = string
  description = "The VPC network to host the cluster in"
  default     = "default"
}

variable "oauth_scopes" {
  type        = list(string)
  description = "List containing node oauth scopes"
  default = [
    "https://www.googleapis.com/auth/cloud-platform"
  ]
}

variable "google_service_account_iam_roles" {
  type = list(string)

  default = [
    "roles/compute.viewer",
    "roles/cloudkms.cryptoKeyEncrypterDecrypter"
  ]
}

variable "machine_type" {
  type        = string
  description = "The machine type to use for the cluster nodes"
  default     = "e2-small"
}

variable "preemptible" {
  type        = bool
  description = "Enable preemptible cluster nodes"
  default     = true
}

variable "kms_key_ring" {
  type        = string
  description = "The name of the KMS key ring to use"
  default     = null
}

variable "kms_crypto_key" {
  type        = string
  description = "The name of the KMS cryptographic key to use"
  default     = null
}

variable "vault_ui" {
  type        = bool
  description = "Enable the Vault UI"
  default     = true
}

variable "vault_service_type" {
  type        = string
  description = "The kubernetes service type for Vault"
  default     = "ClusterIP"
}

variable "vault_tls_disable" {
  type        = bool
  description = "Disable TLS for Vault"
  default     = true
}

variable "vault_common_name" {
  type        = string
  description = "Common name (CN) for self-signed certificate"
  default     = "vault.local"
}

variable "vault_image_repository" {
  type        = string
  description = "The image repository to pull the Vault image from"
  default     = "vault"
}

variable "vault_image_tag" {
  type        = string
  description = "The image tag to use when pulling the Vault image"
  default     = "latest"
}

variable "vault_enable_audit" {
  type        = bool
  description = "Enables Vault audit storage"
  default     = true
}