# Network VPC
resource "digitalocean_vpc" "this" {
  name        = "${var.project_name}-vpc-${local.env}"
  region      = var.do_region
  description = "Network for ${var.project_name}-${var.do_k8s_name}-${local.env} cluster"
}

resource "digitalocean_firewall" "rules" {
  name = "${var.project_name}-firewall-rules-${local.env}"

  tags = [
    digitalocean_tag.project.id
  ]

  inbound_rule {
    protocol    = "icmp"
    source_tags = [digitalocean_tag.project.id]
  }

  # allow ssh, internal flannel, internal node-exporter, internal kubelet
  inbound_rule {
    protocol         = "tcp"
    port_range       = "22"
    source_addresses = ["0.0.0.0/0", "::/0"]
  }

  # Cilium health
  inbound_rule {
    protocol    = "tcp"
    port_range  = "4240"
    source_tags = [digitalocean_tag.project.id]
  }

  # IANA vxlan (flannel, calico)
  inbound_rule {
    protocol    = "udp"
    port_range  = "4789"
    source_tags = [digitalocean_tag.project.id]
  }

  # Linux vxlan (Cilium)
  inbound_rule {
    protocol    = "udp"
    port_range  = "8472"
    source_tags = [digitalocean_tag.project.id]
  }

  # Allow Prometheus to scrape node-exporter
  inbound_rule {
    protocol    = "tcp"
    port_range  = "9100"
    source_tags = [digitalocean_tag.project.id]
  }

  # Allow Prometheus to scrape kube-proxy
  inbound_rule {
    protocol    = "tcp"
    port_range  = "10249"
    source_tags = [digitalocean_tag.project.id]
  }

  # Kubelet
  inbound_rule {
    protocol    = "tcp"
    port_range  = "10250"
    source_tags = [digitalocean_tag.project.id]
  }

  # allow all outbound traffic
  outbound_rule {
    protocol              = "tcp"
    port_range            = "1-65535"
    destination_addresses = ["0.0.0.0/0", "::/0"]
  }

  outbound_rule {
    protocol              = "udp"
    port_range            = "1-65535"
    destination_addresses = ["0.0.0.0/0", "::/0"]
  }

  outbound_rule {
    protocol              = "icmp"
    port_range            = "1-65535"
    destination_addresses = ["0.0.0.0/0", "::/0"]
  }
}

resource "digitalocean_firewall" "controllers" {
  name = "${var.project_name}-firewall-controllers-${local.env}"

  tags = [digitalocean_tag.project.id]

  # etcd
  inbound_rule {
    protocol    = "tcp"
    port_range  = "2379-2380"
    source_tags = [digitalocean_tag.project.id]
  }

  # etcd metrics
  inbound_rule {
    protocol    = "tcp"
    port_range  = "2381"
    source_tags = [digitalocean_tag.project.id]
  }

  # kube-apiserver
  inbound_rule {
    protocol         = "tcp"
    port_range       = "6443"
    source_addresses = ["0.0.0.0/0", "::/0"]
  }

  # kube-scheduler metrics, kube-controller-manager metrics
  inbound_rule {
    protocol    = "tcp"
    port_range  = "10251-10252"
    source_tags = [digitalocean_tag.project.id]
  }
}

resource "digitalocean_firewall" "cluster" {
  name = "${var.project_name}-firewall-${local.env}"

  tags = [digitalocean_tag.project.id]

  # allow HTTP/HTTPS ingress
  inbound_rule {
    protocol         = "tcp"
    port_range       = "80"
    source_addresses = ["0.0.0.0/0", "::/0"]
  }

  inbound_rule {
    protocol         = "tcp"
    port_range       = "443"
    source_addresses = ["0.0.0.0/0", "::/0"]
  }

  inbound_rule {
    protocol         = "tcp"
    port_range       = "10254"
    source_addresses = ["0.0.0.0/0"]
  }
}

