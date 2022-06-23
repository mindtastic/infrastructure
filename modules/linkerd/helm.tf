locals {
  release_name = "linkerd"
}

resource "helm_release" "sealed_secrets" {
  name             = local.release_name
  repository       = "https://helm.linkerd.io/stable"
  chart            = "linkerd2"
  version          = "2.11.2"
  create_namespace = true
  namespace        = "linkerd"
  max_history      = 3

  set {
    name  = "identityTrustAnchorsPEM"
    value = var.teleport_domain
  }
}
