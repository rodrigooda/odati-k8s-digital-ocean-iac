terraform {
  required_providers {
    digitalocean = {
      source  = "digitalocean/digitalocean"
      version = ">= 2.8.0"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = ">= 2.1.0"
    }
  }
}

# Tags
resource "digitalocean_tag" "project" {
  name = "${var.project_name}-${local.env}"
}

resource "digitalocean_project" "this" {
  name        = var.project_name
  description = var.project_description
  purpose     = var.project_purpose
  environment = local.env
}

# resource "digitalocean_project_resources" "this" {
#   count   = var.enable_digitalocean ? 1 : 0
#   project = digitalocean_project.this.id
#   resources = [
#     "do:kubernetes:${digitalocean_kubernetes_cluster.this[count.index].id}",
#     "do:firewall:${digitalocean_firewall.cluster.id}",
#     "do:firewall:${digitalocean_firewall.controllers.id}",
#     digitalocean_database_cluster.postgres.urn
#   ]
#   depends_on = [digitalocean_project.this,digitalocean_kubernetes_cluster.this,digitalocean_database_cluster.postgres, digitalocean_firewall.cluster, digitalocean_firewall.controllers]
# }

resource "digitalocean_kubernetes_cluster" "this" {
  count   = var.enable_digitalocean ? 1 : 0
  name    = "${var.project_name}-${var.do_k8s_name}-${local.env}"
  region  = var.do_region
  version = var.do_k8s_version

  node_pool {
    name       = "${var.project_name}-${var.do_k8s_pool_name}-${local.env}"
    size       = var.do_k8s_node_type
    node_count = var.do_k8s_nodes
  }

  tags = [
    digitalocean_tag.project.id
  ]

  # network
  vpc_uuid = digitalocean_vpc.this.id

  lifecycle {
    create_before_destroy = true
  }

  depends_on = [digitalocean_vpc.this]

}


resource "digitalocean_kubernetes_node_pool" "this" {
  count      = var.enable_digitalocean ? 1 : 0
  cluster_id = digitalocean_kubernetes_cluster.this[count.index].id

  name       = "${var.project_name}-${var.do_k8s_nodepool_name}-${local.env}"
  size       = var.do_k8s_nodepool_type
  node_count = var.do_k8s_nodepool_size

  tags = [
    digitalocean_tag.project.id
  ]

  depends_on = [digitalocean_kubernetes_cluster.this]
}

resource "digitalocean_container_registry" "this" {
  name = "${var.project_name}-${local.env}"
  subscription_tier_slug = "starter"
}
