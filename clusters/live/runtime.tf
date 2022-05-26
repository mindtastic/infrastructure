module "teleport" {
  source = "../../modules/teleport-cluster"

  cluster_name                  = local.cluster_name
  teleport_acme_email           = var.runtime_teleport_acme_email
  teleport_github_client_id     = var.runtime_teleport_github_client_id
  teleport_github_client_secret = var.runtime_teleport_github_client_secret
  teleport_domain               = var.runtime_teleport_domain
  teleport_github_org           = var.runtime_teleport_github_org

  depends_on = [
    google_container_cluster.primary,
    google_container_node_pool.primary_nodes
  ]
}

module "sealed_secrets" {
  source = "../../modules/sealed-secrets"

  depends_on = [
    google_container_cluster.primary,
    google_container_node_pool.primary_nodes
  ]
}

module "argo" {
  source = "../../modules/argo"

  argocd_github_client_id     = var.runtime_argocd_github_client_id
  argocd_github_client_secret = var.runtime_argocd_github_client_secret
  argocd_github_private_key   = var.runtime_argocd_github_private_key

  depends_on = [
    google_container_cluster.primary,
    google_container_node_pool.primary_nodes
  ]
}
