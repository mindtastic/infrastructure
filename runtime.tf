module "teleport" {
  source = "./modules/teleport"

  cluster_name                  = var.cluster_name
  teleport_github_client_id     = var.teleport_github_client_id
  teleport_github_client_secret = var.teleport_github_client_secret
  teleport_domain               = var.teleport_domain
  teleport_github_org           = var.teleport_github_org

  depends_on = [
    google_container_cluster.primary
  ]
}
