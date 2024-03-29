locals {
  tfe_organization   = "mindtastic"
  tfe_oauth_token_id = var.tfc_oauth_token # https://app.terraform.io/app/mindtastic/settings/version-control
  github_repo        = "mindtastic/infrastructure"
  dns_root_zone_name = "${var.root_domain_name}."

  dev_workspace_name        = "gke-cluster-dev"
  stage_workspace_name      = "gke-cluster-stage"
  live_workspace_name       = "gke-cluster-live"
  networking_workspace_name = "cluster-internetworking"
}

module "cluster_dev" {
  source = "./modules/workspace"

  organization          = local.tfe_organization
  name                  = local.dev_workspace_name
  auto_apply            = false
  parent_workspace_name = var.TFC_WORKSPACE_NAME
  repository            = local.github_repo
  workspace_path        = "clusters/dev"
  github_oauth_token_id = local.tfe_oauth_token_id
  variables = {
    project_name             = var.project_name
    environment              = "dev"
    cluster_dns_zone_name    = google_dns_managed_zone.dev_root.name
    region                   = "europe-north1"
    k8s_node_subnet          = "10.10.0.0/28"
    k8s_pod_subnet           = "10.11.0.0/16"
    k8s_service_subnet       = "10.12.0.0/16"
    k8s_control_plane_subnet = "172.16.0.0/28"
    cluster_node_type        = "e2-standard-2"
    cluster_node_count       = 1

    runtime_teleport_proxy_address = var.live_runtime_teleport_domain
  }
  sensitive_variables = {
    google_credential_file = var.google_credential_file

    runtime_teleport_auth_token = random_uuid.teleport_node_join_token.result
  }
}

module "cluster_stage" {
  source = "./modules/workspace"

  organization          = local.tfe_organization
  name                  = local.stage_workspace_name
  auto_apply            = false
  parent_workspace_name = var.TFC_WORKSPACE_NAME
  repository            = local.github_repo
  workspace_path        = "clusters/stage"
  github_oauth_token_id = local.tfe_oauth_token_id
  variables = {
    project_name             = var.project_name
    environment              = "stage"
    cluster_dns_zone_name    = google_dns_managed_zone.stage_root.name
    region                   = "europe-north1"
    k8s_node_subnet          = "10.20.0.0/28"
    k8s_pod_subnet           = "10.21.0.0/16"
    k8s_service_subnet       = "10.22.0.0/16"
    k8s_control_plane_subnet = "172.16.1.0/28"
    cluster_node_type        = "e2-medium"
    cluster_node_count       = 1

    runtime_teleport_proxy_address = var.live_runtime_teleport_domain
  }
  sensitive_variables = {
    google_credential_file = var.google_credential_file

    runtime_teleport_auth_token = random_uuid.teleport_node_join_token.result
  }
}

module "cluster_live" {
  source = "./modules/workspace"

  organization          = local.tfe_organization
  name                  = local.live_workspace_name
  auto_apply            = false
  parent_workspace_name = var.TFC_WORKSPACE_NAME
  repository            = local.github_repo
  workspace_path        = "clusters/live"
  github_oauth_token_id = local.tfe_oauth_token_id
  variables = {
    project_name             = var.project_name
    environment              = "live"
    cluster_dns_zone_name    = google_dns_managed_zone.live_root.name
    region                   = "europe-north1"
    k8s_node_subnet          = "10.30.0.0/28"
    k8s_pod_subnet           = "10.31.0.0/16"
    k8s_service_subnet       = "10.32.0.0/16"
    k8s_control_plane_subnet = "172.16.2.0/28"
    cluster_node_type        = "e2-standard-4"
    cluster_node_count       = 2

    runtime_teleport_github_client_id = var.live_runtime_teleport_github_client_id
    runtime_argocd_github_client_id   = var.live_runtime_argocd_github_client_id
    runtime_teleport_domain           = var.live_runtime_teleport_domain
    runtime_teleport_github_org       = var.live_runtime_teleport_github_org

  }
  sensitive_variables = {
    google_credential_file = var.google_credential_file

    runtime_teleport_auth_token           = random_uuid.teleport_node_join_token.result
    runtime_teleport_acme_email           = var.live_runtime_teleport_acme_email
    runtime_teleport_github_client_secret = var.live_runtime_teleport_github_client_secret
    runtime_argocd_github_client_secret   = var.live_runtime_argocd_github_client_secret
    runtime_argocd_github_private_key     = var.live_runtime_argocd_github_private_key
  }
}
