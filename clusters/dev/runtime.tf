# https://github.com/cilium/cilium/issues/19816#issuecomment-1144551910
# With Dataplane V2 enabled (via `datapath_provider = "ADVANCED_DATAPATH"`), Cilium is installed.
resource "kubernetes_cluster_role_binding_v1" "cilium_daplane_fix" {
  metadata {
    name = "cilium-node-patcher-gke-fix"
  }
  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = "system:node"
  }
  subject {
    kind      = "ServiceAccount"
    namespace = "kube-system"
    name      = "cilium"
    api_group = ""
  }
}

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
