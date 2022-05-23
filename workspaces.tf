locals {
  tfe_organization   = "mindtastic"
  tfe_oauth_token_id = "ot-wwv4yMLk5usRLHzQ" # https://app.terraform.io/app/mindtastic/settings/version-control
  github_repo        = "mindtastic/infrastructure"
}

module "cluster_dev" {
  source = "./modules/workspace"

  organization          = local.tfe_organization
  name                  = "gke-cluster-dev"
  auto_apply            = false
  repository            = local.github_repo
  workspace_path        = "clusters/dev"
  github_oauth_token_id = local.tfe_oauth_token_id
  variables = {
    project_name             = "opentelemetry-benchmark"
    environment              = "dev"
    region                   = "europe-north1"
    k8s_node_subnet          = "10.10.0.0/28"
    k8s_pod_subnet           = "10.11.0.0/16"
    k8s_service_subnet       = "10.12.0.0/16"
    k8s_control_plane_subnet = "172.16.0.0/28"
    cluster_node_type        = "e2-medium"
    cluster_node_count       = 3
  }
  sensitive_variables = {
    google_credential_file = var.google_credential_file
  }
}

module "cluster_stage" {
  source = "./modules/workspace"

  organization          = local.tfe_organization
  name                  = "gke-cluster-stage"
  auto_apply            = false
  repository            = local.github_repo
  workspace_path        = "clusters/dev"
  github_oauth_token_id = local.tfe_oauth_token_id
  variables             = {}
  sensitive_variables = {
    google_credential_file = var.google_credential_file
  }
}

module "cluster_live" {
  source = "./modules/workspace"

  organization          = local.tfe_organization
  name                  = "gke-cluster-live"
  auto_apply            = false
  repository            = local.github_repo
  workspace_path        = "clusters/dev"
  github_oauth_token_id = local.tfe_oauth_token_id
  variables             = {}
  sensitive_variables = {
    google_credential_file = var.google_credential_file
  }
}
