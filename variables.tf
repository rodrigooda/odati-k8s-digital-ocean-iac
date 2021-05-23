variable "project_name" {
  type        = string
  description = "Name of the project."
}

variable "project_description" {
  type        = string
  description = "Description of the project."
  default     = "Description of the project."
}

variable "project_purpose" {
  type        = string
  description = "Purpose of the project."
  default     = "Purpose of the project."
}

variable "workspace_to_environment_map" {
  type = map(any)
  default = {
    development = "development"
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

variable "do_db_name" {
  description = "Digital Ocean Kubernetes cluster name (e.g. `k8s-do`)"
  type        = string
  default     = "db-do"
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

variable "do_container_registry_name" {
  description = "Digital Ocean Container Registry name default size (e.g. `cr`)"
  type        = string
  default     = "cr"
}


variable "do_db_size" {
  description = "Digital Ocean Database default size (e.g. `s-1vcpu-2gb` => 1vCPU, 2GB RAM)"
  type        = string
  default     = "db-s-1vcpu-1gb"
}

variable "do_db_engine" {
  description = "Digital Ocean Database default engine (e.g. `pg` => Postgres)"
  type        = string
  default     = "pg"
}

variable "do_db_user_sufix" {
  description = "Digital Ocean Database default user"
  type        = string
  default     = "admin"
}

variable "do_db_version" {
  description = "Digital Ocean Database default version (e.g. `13` => Postgres 13)"
  type        = string
  default     = "12"
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
  env          = lookup(var.workspace_to_environment_map, terraform.workspace, "develop")
  cluster_name = "${var.project_name}-${var.do_k8s_name}-${local.env}"
}