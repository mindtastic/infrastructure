module "teleport" {
  source = "./modules/teleport"

  cluster_name                  = var.cluster_name
  teleport_acme_email           = var.teleport_acme_email
  teleport_github_client_id     = var.teleport_github_client_id
  teleport_github_client_secret = var.teleport_github_client_secret
  teleport_domain               = var.teleport_domain
  teleport_github_org           = var.teleport_github_org

  depends_on = [
    google_container_cluster.primary,
    google_container_node_pool.primary_preemptible_nodes
  ]
}

module "sealed_secrets" {
  source = "./modules/sealed-secrets"

  depends_on = [
    google_container_cluster.primary,
    google_container_node_pool.primary_preemptible_nodes
  ]
}

module "argo" {
  source = "./modules/argo"

  argocd_github_client_id     = var.argocd_github_client_id
  argocd_github_client_secret = var.argocd_github_client_secret

  depends_on = [
    google_container_cluster.primary,
    google_container_node_pool.primary_preemptible_nodes
  ]
}
