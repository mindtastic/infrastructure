locals {
  release_name = "sealed-secrets"
}

resource "helm_release" "sealed_secrets" {
  name             = local.release_name
  repository       = "https://bitnami-labs.github.io/sealed-secrets"
  chart            = "sealed-secrets"
  version          = "2.1.8"
  create_namespace = false
  namespace        = "kube-system"
  max_history      = 3

  values = [
    "${templatefile("${path.module}/values.yaml", {
      github_client_id     = var.argocd_github_client_id,
      github_client_secret = var.argocd_github_client_secret
    })}"
  ]
}
