locals {
  release_name = "argo-cd"
}

resource "helm_release" "argo_cd" {
  name             = local.release_name
  repository       = "https://argoproj.github.io/argo-helm"
  chart            = "argo-cd"
  version          = "4.6.0"
  create_namespace = true
  namespace        = "argocd"
  max_history      = 3

  values = [
    "${file("${path.module}/values.yaml")}"
  ]
}
