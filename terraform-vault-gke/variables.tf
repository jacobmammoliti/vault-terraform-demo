# GCP variables
variable "project_id" {
  type        = string
  description = "(required) The project ID to host the cluster in"
}

variable "region" {
  type        = string
  description = "The region to host the GKE cluster in"
  default     = "us-east1"
}

variable "zone" {
  type        = list(string)
  description = "The zones to host the cluster in"
  default     = ["b"]
}

variable "network" {
  type        = string
  description = "(required) The VPC network to host the cluster in"
}

# GKE variables
variable "gke_cluster_name" {
  type        = string
  description = "The name of the GKE cluster"
  default     = "vault"
}

variable "gke_node_count" {
  type        = number
  description = "The number of nodes to create in the cluster's default node pool"
  default     = 3
}

variable "gke_machine_type" {
  type        = string
  description = "The machine type to use for the cluster nodes"
  default     = "e2-small"
}

variable "gke_preemptible_nodes" {
  type        = bool
  description = "Whether to use preemptible cluster nodes"
  default     = true
}

variable "gke_oauth_scopes" {
  type        = list(string)
  description = "List containing node oauth scopes"
  default = [
    "https://www.googleapis.com/auth/cloud-platform"
  ]
}

variable "gke_service_account_iam_roles" {
  type        = list(string)
  description = "List of IAM roles to assign to the GCP Service Account leveraged by Vault"
  default = [
    "roles/compute.viewer",
    "roles/cloudkms.cryptoKeyEncrypterDecrypter"
  ]
}

variable "use_google_workload_identity" {
  type        = bool
  description = "Whether to use Workload Identity for Vault. If enabled, the underlying GKE nodes will not have any IAM permissions."
  default     = false
}

# Kubernetes variables
variable "kubernetes_namespace" {
  type        = string
  description = "The Kubernetes namespace to deploy Vault into"
  default     = "vault"
}

variable "kubernetes_sa_name" {
  type        = string
  description = "The Kubernetes Service Account that Vault will use"
  default     = "vault-sa"
}

variable "kubernetes_image_pull_secrets" {
  type        = list(string)
  description = "A list of Kubernetes secrets that hold any required image registry credentials"
  default     = null
}

variable "kubernetes_extra_secret_environment_variables" {
  type        = list(map(string))
  description = "A list of maps referencing Kubernetes secrets and their environment variable to mount to the Vault pods"
  default     = null
}

variable "kubernetes_vault_server_service_type" {
  type        = string
  description = "The kubernetes service type for the Vault service"
  default     = "ClusterIP"
}

variable "kubernetes_vault_ui_service_type" {
  type        = string
  description = "The kubernetes service type for the Vault UI"
  default     = "ClusterIP"
}

variable "helm_release_name" {
  type        = string
  description = "The name of the Helm release"
  default     = "vault"
}

variable "helm_chart_name" {
  type        = string
  description = "The chart name in the Helm repository"
  default     = "vault"
}

variable "helm_repository" {
  type        = string
  description = "The location of the Helm repository"
  default     = "https://helm.releases.hashicorp.com/"
}

# Vault variables
variable "vault_injector_enable" {
  type        = bool
  description = "Whether or not to enable the Vault agent injector"
  default     = true
}

variable "vault_injector_image_repository" {
  type        = string
  description = "The repository to pull the Vault injector image from"
  default     = "hashicorp/vault-k8s"
}

variable "vault_injector_image_tag" {
  type        = string
  description = "The image tag to use when pulling the Vault injector image"
  default     = "0.14.1"
}

variable "vault_image_repository" {
  type        = string
  description = "The repository to pull the Vault image from"
  default     = "hashicorp/vault"
}

variable "vault_image_tag" {
  type        = string
  description = "The image tag to use when pulling the Vault image"
  default     = "1.9.4"
}

variable "vault_leader_tls_servername" {
  type        = string
  description = "The TLS server name to use when connecting with HTTPS"
  default     = null
}

variable "vault_data_storage_size" {
  type        = string
  description = "The size, in Gi, of the data storage volume"
  default     = "10"
}

variable "vault_license" {
  type        = string
  description = "(optional)The name of the vault license secret in Secrets Manager"
  default     = null
}

variable "vault_api_signed_certificate" {
  type        = string
  description = "The name of the signed certificate secret in Secrets Manager"
  default     = null
}

variable "vault_api_private_key" {
  type        = string
  description = "The name of the certificate private key secret in Secrets Manager"
  default     = null
}

variable "vault_api_ca_bundle" {
  type        = string
  description = "The name of the CA bundle secret in Secrets Manager"
  default     = null
}

variable "vault_kms_seal_config" {
  type        = map(string)
  description = "A map containing the seal configuration information"
  default     = null
}

variable "vault_ui" {
  type        = bool
  description = "Enable the Vault UI"
  default     = true
}

variable "vault_seal_method" {
  type        = string
  description = "The Vault seal method to use"
  default     = "shamir"
}

variable "vault_enable_audit" {
  type        = bool
  description = "Enables Vault audit storage"
  default     = true
}