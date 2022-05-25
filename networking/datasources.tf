data "tfe_outputs" "dev" {
  organization = var.tfe_organization
  workspace    = var.dev_workspace_name
}

data "tfe_outputs" "stage" {
  organization = var.tfe_organization
  workspace    = var.stage_workspace_name
}

data "tfe_outputs" "live" {
  organization = var.tfe_organization
  workspace    = var.live_workspace_name
}

data "google_client_config" "default" {}
