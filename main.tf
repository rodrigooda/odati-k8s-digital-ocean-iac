terraform {
  required_providers {
    digitalocean = {
      source  = "digitalocean/digitalocean"
      version = ">= 2.4.0"
    }
    kubernetes = {
      source = "hashicorp/kubernetes"
      version = ">= 2.0.0"
    }
    helm = {
      source  = "hashicorp/helm"
      version = ">= 2.0.1"
    }
  }
}

# Tags
resource "digitalocean_tag" "project" {
  name = "${var.project_name}-${local.env}"
}


resource "digitalocean_kubernetes_cluster" "k8s" {
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
  vpc_uuid = digitalocean_vpc.network.id

  lifecycle {
    create_before_destroy = true
  }

}

resource "digitalocean_kubernetes_node_pool" "k8s_nodes" {
  count      = var.enable_digitalocean ? 1 : 0
  cluster_id = digitalocean_kubernetes_cluster.k8s[count.index].id

  name       = "${var.project_name}-${var.do_k8s_nodepool_name}-${local.env}"
  size       = var.do_k8s_nodepool_type
  node_count = var.do_k8s_nodepool_size

  tags = [
    digitalocean_tag.project.id
  ]
}

resource "local_file" "kubeconfigdo" {
  count    = var.enable_digitalocean ? 1 : 0
  content  = digitalocean_kubernetes_cluster.k8s[count.index].kube_config[0].raw_config
  filename = "kubeconfig_${var.project_name}_${local.env}.yaml"
}
