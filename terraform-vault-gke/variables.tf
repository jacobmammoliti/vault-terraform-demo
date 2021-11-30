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

variable "google_workload_identity" {
  type        = bool
  description = "Use Workload Identity or not"
  default     = false
}

variable "kubernetes_namespace" {
  type        = string
  description = "The name of Kubernetes namespace to deploy Vault into"
  default     = "vault"
}

variable "kubernetes_sa_name" {
  type        = string
  description = "The name of the Kubernetes Service Account that Vault will use"
  default     = "vault-sa"
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

variable "helm_chart_name" {
  type        = string
  description = "Name of the Helm chart deployment"
  default     = "vault"
}

variable "kms_region" {
  type        = string
  description = "The region the KMS key ring is in"
  default     = null
}

variable "kms_project_id" {
  type        = string
  description = "The project ID the KMS key ring is in"
  default     = null
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
  default     = false
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