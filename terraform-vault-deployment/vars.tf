variable "project_id" {
  description = "id of project to deploy kubernetes cluster into"
}

variable "cluster_name" {
  description = "name given to kubernetes cluster"
}

variable "location" {
  description = "location to deploy kubernetes cluster into"
  default     = "us-central1-a"
}

variable "initial_node_count" {
  description = "inital node count for kubernetes cluster"
  default     = "1"
}

variable "network" {
  description = "network where kubernetes nodes will live in"
  default     = "default"
}

variable "oauth_scopes" {
  description = "list of oauth scopes kubernetes nodes has"
  default = [
    "https://www.googleapis.com/auth/logging.write",
    "https://www.googleapis.com/auth/monitoring",
    "https://www.googleapis.com/auth/cloud-platform",
    "https://www.googleapis.com/auth/cloudkms"
  ]
  type = list
}

variable "machine_type" {
  description = "compute resource type that each kubernetes node will live on"
  default     = "n1-standard-1"
}

variable "preemptible" {
  description = "controls whether kubernetes nodes should be preemtible or not"
  default     = true
}

variable "enable_vault_ui" {
  description = "controls whether to enable the UI for Vault or not"
  default     = true
}

variable "vault_service_type" {
  description = "controls the type of Kubernetes service the Vault UI service gets"
  default     = "ClusterIP"
}

variable "vault_tls_disable" {
  description = "controls whether to disable tls for Vault or not"
  default     = false
}

variable "primary_hostname" {
  type        = string
  description = "hostname for self-signed certificate"
  default     = "vault-primary"
}

variable "secondary_hostname" {
  type        = string
  description = "hostname for self-signed certificate"
  default     = "vault-secondary"
}

variable "domain" {
  type        = string
  description = "domain for self-signed certificate"
}

variable "gcp_kms_project_id" {
  type        = string
  description = "define project id that GCP KMS will be deployed into"
}

variable "gcp_kms_region" {
  type        = string
  description = "define the GCP KMS region will be deployed into"
  default     = "us-central1"
}

variable "gcp_kms_key_ring" {
  type        = string
  description = "the name of the GCP KMS key ring"
}

variable "gcp_kms_crypto_key" {
  type        = string
  description = "the name of the GCP KMS crypto key"
}

variable "vault_image_repository" {
  type        = string
  description = "controls which repository to pull vault from"
  default     = "vault"
}

variable "vault_image_tag" {
  type        = string
  description = "controls which image to use"
  default     = "latest"
}

variable "vault_enable_audit" {
  description = "controls the enablement audit storage"
  default     = true
}

variable "deploy_secondary" {
  type        = bool
  description = "controls whether or not to deploy a second vault in a separate namespace"
  default     = false
}

variable "gke_service_account_id" {
  type        = string
  description = "ID of the Service Account that GKE will use"
  default     = "gke-vault"
}