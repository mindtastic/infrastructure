module "teleport" {
  source = "../../modules/teleport-agent"

  cluster_name                 = local.cluster_name
  teleport_proxy_address       = var.runtime_teleport_proxy_address
  teleport_auth_token          = var.runtime_teleport_auth_token
  kubernetes_environment_label = var.environment

  depends_on = [
    google_container_cluster.primary,
    google_container_node_pool.primary_preemptible_nodes
  ]
}

locals {
  argocd_sa_name      = "argocd-manager"
  argocd_sa_namespace = "kube-system"
}

# Create a kubernetes service account for remote cluster management via ArgoCD
resource "kubernetes_service_account" "argocd_manager" {
  metadata {
    name      = local.argocd_sa_name
    namespace = local.argocd_sa_namespace
  }
}

resource "kubernetes_cluster_role_binding" "argocd_manager" {
  metadata {
    name = "argocd"
  }
  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = "cluster-admin"
  }
  subject {
    kind      = "ServiceAccount"
    name      = local.argocd_sa_name
    namespace = local.argocd_sa_namespace
  }
}

module "linkerd" {
  source = "../../modules/linkerd"

  cluster_networks = [var.k8s_service_subnet, var.k8s_pod_subnet]

  depends_on = [
    google_container_cluster.primary,
    google_container_node_pool.primary_preemptible_nodes,
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
    ports    = ["443", "8443"]
  }

  source_ranges = [var.k8s_control_plane_subnet]
  priority      = 0
}
