data "tfe_outputs" "dev" {
  organization = local.tfe_organization
  workspace    = local.dev_workspace_name

  depends_on = [
    module.cluster_dev
  ]
}

data "tfe_outputs" "stage" {
  organization = local.tfe_organization
  workspace    = local.stage_workspace_name

  depends_on = [
    module.cluster_stage
  ]
}

data "tfe_outputs" "live" {
  organization = local.tfe_organization
  workspace    = local.live_workspace_name

  depends_on = [
    module.cluster_live
  ]
}
