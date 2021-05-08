variable "project_name" {
  type        = string
  description = "Name of the project."
  default     = "arrendafacil"
}

variable "workspace_to_environment_map" {
  type = map
  default = {
    dev         = "dev"
    staging     = "staging"
    production  = "prod"
  }
}

variable "enable_digitalocean" {
  description = "Enable / Disable Digital Ocean (e.g. `true`)"
  type        = bool
  default     = true
}

variable "random_cluster_suffix" {
  description = "Random 6 byte hex suffix for cluster name"
  type        = string
  default     = ""
}

variable "do_token" {
  description = "Digital Ocean Personal access token"
  type        = string
  default     = ""
}

variable "do_region" {
  description = "Digital Ocean region (e.g. `nyc1` => New York)"
  type        = string
  default     = "nyc1"
}

variable "do_vpc_name" {
  description = "Digital Ocean VPC name (e.g. `vpc-do`)"
  type        = string
  default     = "vpc-do"
}

variable "do_k8s_name" {
  description = "Digital Ocean Kubernetes cluster name (e.g. `k8s-do`)"
  type        = string
  default     = "k8s-do"
}

variable "do_k8s_version" {
  description = "Digital Ocean Kubernetes cluster version (e.g. `1.20.2-do.0`)"
  type        = string
  default     = "1.20.2-do.0"
}

variable "do_k8s_pool_name" {
  description = "Digital Ocean Kubernetes default node pool name (e.g. `k8s-do-nodepool`)"
  type        = string
  default     = "k8s-mainpool"
}

variable "do_k8s_nodes" {
  description = "Digital Ocean Kubernetes default node pool size (e.g. `2`)"
  type        = number
  default     = 1
}

variable "do_k8s_node_type" {
  description = "Digital Ocean Kubernetes default node pool type (e.g. `s-1vcpu-2gb` => 1vCPU, 2GB RAM)"
  type        = string
  default     = "s-1vcpu-2gb"
}

variable "do_k8s_nodepool_name" {
  description = "Digital Ocean Kubernetes additional node pool name (e.g. `k8s-do-nodepool`)"
  type        = string
  default     = "k8s-nodepool"
}

variable "do_k8s_nodepool_type" {
  description = "Digital Ocean Kubernetes additional node pool type (e.g. `s-1vcpu-2gb` => 1vCPU, 2GB RAM)"
  type        = string
  default     = "s-1vcpu-2gb"
}

variable "do_k8s_nodepool_size" {
  description = "Digital Ocean Kubernetes additional node pool size (e.g. `3`)"
  type        = number
  default     = 2
}

locals {
  env = lookup(var.workspace_to_environment_map, terraform.workspace, "dev")
  cluster_name = "${var.project_name}-${var.do_k8s_name}-${local.env}"
}