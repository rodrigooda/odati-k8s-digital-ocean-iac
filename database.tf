resource "digitalocean_database_user" "dbuser" {
  cluster_id = digitalocean_database_cluster.postgres.id
  name       = "${var.project_name}_${var.do_db_user_sufix}"
}


resource "digitalocean_database_cluster" "postgres" {
  name       = "${var.project_name}-${var.do_db_name}-${local.env}"
  engine     = var.do_db_engine
  version    = var.do_db_version
  size       = var.do_db_size
  region     = var.do_region
  node_count = 1

  # network
  private_network_uuid = digitalocean_vpc.this.id

  tags = [
    digitalocean_tag.project.id
  ]
  depends_on = [digitalocean_tag.project, digitalocean_vpc.this]
}

resource "digitalocean_database_db" "this" {
  cluster_id = digitalocean_database_cluster.postgres.id
  name       = "${var.project_name}_db"
}

# resource "digitalocean_database_firewall" "db-fw" {
#   count   = var.enable_digitalocean ? 1 : 0
#   cluster_id = digitalocean_database_cluster.postgres.id

#   rule {
#     type  = "k8s"
#     value = digitalocean_kubernetes_cluster.this[count.index].id
#   }
#   depends_on = [digitalocean_kubernetes_cluster.this]
# }