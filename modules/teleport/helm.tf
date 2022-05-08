locals {
  teleport_namespace = "teleport"
}

resource "helm_release" "teleport" {
  name             = "teleport-cluster"
  repository       = "https://charts.releases.teleport.dev"
  chart            = "teleport/teleport-cluster"
  version          = "6.0.1"
  create_namespace = true
  namespace        = local.teleport_namespace
  max_history      = 3

  values = [
    "${file("${path.module}/teleport.yaml")}"
  ]

  set {
    name  = "clusterName"
    value = var.teleport_domain
  }

  set {
    name  = "kubeClusterName"
    value = var.cluster_name
  }

  set {
    name  = "acmeEmail"
    value = var.teleport_acme_email
  }

  depends_on = [
    kubernetes_config_map.github
  ]
}

resource "kubernetes_config_map" "github" {
  metadata {
    name      = "teleport-github-config"
    namespace = local.teleport_namespace
  }

  data = {
    "github.yaml" = "${templatefile("${path.module}/github.yaml", {
      teleport_github_client_id     = var.teleport_github_client_id
      teleport_github_client_secret = var.teleport_github_client_secret
      teleport_domain               = var.teleport_domain
      teleport_github_org           = var.teleport_github_org
    })}"
  }
}
