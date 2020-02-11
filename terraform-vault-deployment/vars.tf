variable "project" {
  description = "project to deploy kubernetes cluster into"
}

variable "location" {
  description = "location to deploy kubernetes cluster into"
  default     = "us-central1-a"
}

variable "cluster_name" {
  description = "name of kubernetes cluster"
}

variable "initial_node_count" {
  description = "initial amount of nodes to deploy for the kubernetes cluster"
  default     = "1"
}

variable "network" {
  description = "network that the compute resources of the kubernetes cluster are in"
  default     = "default"
}

variable "machine_type" {
  description = "size of the compute resources"
  default     = "n1-standard-1"
}

variable "dns_managed_zone" {
}

variable "dns_name" {
}