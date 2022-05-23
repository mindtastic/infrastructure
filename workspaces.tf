locals {
  tfe_organization = "mindtastic"
  tfe_oauth_token_id = "ot-wwv4yMLk5usRLHzQ" # https://app.terraform.io/app/mindtastic/settings/version-control
  github_repo = "mindtastic/infrastructure"
}

module "cluster_dev" {
  source = "./modules/workspace"

  organization          = local.tfe_organization
  name                  = "gke-cluster-dev"
  auto_apply            = true
  repository            = local.github_repo
  workspace_path        = "clusters/dev"
  github_oauth_token_id = local.oauth_token_id
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
  github_oauth_token_id = local.oauth_token_id
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
  github_oauth_token_id = local.oauth_token_id
  variables             = {}
  sensitive_variables   = {}
}
