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
    "https://www.googleapis.com/auth/monitoring"
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
  default     = "LoadBalancer"
}

variable "vault_tls_disable" {
  description = "controls whether to disable tls for Vault or not"
  default     = false
}

variable "hostname" {
  type        = string
  description = "hostname for self-signed certificate"
}