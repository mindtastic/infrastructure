locals {
  tfe_organization = "mindtastic"
  github_repo = "mindtastic/infrastructure"
}

resource "tfe_ssh_key" "mindtastic" {
  name         = "mindtastic-ssh"
  organization = local.tfe_organization
  key          = "private-ssh-key"
}

module "cluster_dev" {
  source = "./modules/workspace"

  organization          = local.tfe_organization
  name                  = "gke-cluster-dev"
  auto_apply            = true
  repository            = local.github_repo
  workspace_path        = "clusters/dev"
  github_oauth_token_id = ""
  ssh_key_id            = ""
  variables             = {}
  sensitive_variables   = {}
}

module "cluster_stage" {
  source = "./modules/workspace"

  organization          = local.tfe_organization
  name                  = "gke-cluster-dev"
  auto_apply            = true
  repository            = local.github_repo
  workspace_path        = "clusters/dev"
  github_oauth_token_id = ""
  ssh_key_id            = ""
  variables             = {}
  sensitive_variables   = {}
}

module "cluster_live" {
  source = "./modules/workspace"

  organization          = local.tfe_organization
  name                  = "gke-cluster-dev"
  auto_apply            = true
  repository            = local.github_repo
  workspace_path        = "clusters/dev"
  github_oauth_token_id = ""
  ssh_key_id            = ""
  variables             = {}
  sensitive_variables   = {}
}
