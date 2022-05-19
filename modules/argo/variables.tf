variable "argocd_github_client_id" {
  type        = string
  description = "Client ID of GitHub OAuth app for ArgoCD login."
}

variable "argocd_github_client_secret" {
  type        = string
  description = "Client Secret of GitHub OAuth app for ArgoCD login."
}

variable "argocd_github_private_key" {
  type        = string
  description = "Private Key that can be used to Access GitHub Repositories in the Organisation."
  sensitive   = true
}