resource "helm_release" "teleport" {
  name             = "teleport-cluster"
  repository       = "https://charts.releases.teleport.dev"
  chart            = "teleport/teleport-cluster"
  version          = "6.0.1"
  create_namespace = true
  namespace        = "teleport"
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
}
