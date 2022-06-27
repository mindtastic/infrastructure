module "teleport" {
  source = "../../modules/teleport-cluster"

  cluster_name                  = local.cluster_name
  teleport_acme_email           = var.runtime_teleport_acme_email
  teleport_github_client_id     = var.runtime_teleport_github_client_id
  teleport_github_client_secret = var.runtime_teleport_github_client_secret
  teleport_domain               = var.runtime_teleport_domain
  teleport_github_org           = var.runtime_teleport_github_org
  teleport_auth_token           = var.runtime_teleport_auth_token

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

module "linkerd" {
  source = "../../modules/linkerd"

  cluster_networks = [var.k8s_service_subnet, var.k8s_pod_subnet]

  depends_on = [
    google_container_cluster.primary,
    google_container_node_pool.primary_nodes,
    google_compute_firewall.linkerd
  ]
}

# Needed to make Linkerd work on a private GKE cluster.
# https://github.com/linkerd/linkerd2/issues/8707
resource "google_compute_firewall" "linkerd" {
  project     = var.project_name
  name        = "linkerd-${local.cluster_name}"
  network     = google_compute_network.vpc_network.self_link
  description = "Creates firewall rule for linkerd to Kubernetes nodes"

  allow {
    protocol = "tcp"
    ports    = ["443", "8443", "8089"] # 8443 for proxy injector, 8089 for `tap`.
  }

  source_ranges = [var.k8s_control_plane_subnet]
  priority      = 0
}
