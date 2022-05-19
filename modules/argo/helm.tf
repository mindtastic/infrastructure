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
    "${templatefile("${path.module}/values.yaml", {
      github_client_id     = var.argocd_github_client_id,
      github_client_secret = var.argocd_github_client_secret
    })}"
  ]

  set_sensitive {
    name  = "configs.credentialTemplates.ssh-creds.sshPrivateKey"
    value = var.argocd_github_private_key
  }
}
