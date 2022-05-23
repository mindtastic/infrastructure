resource "tfe_workspace" "workspace" {
  name              = var.name
  organization      = var.organization
  auto_apply        = var.auto_apply
  execution_mode    = "remote"
  terraform_version = "1.2.0"

  vcs_repo {
    identifier     = var.repository
    oauth_token_id = var.github_oauth_token_id
    branch         = "leo/restructure"
  }
  working_directory = var.workspace_path
}

resource "tfe_variable" "terraform_cloud_variables" {
  for_each = var.variables

  key          = each.key
  value        = each.value
  category     = "terraform"
  sensitive    = false
  workspace_id = tfe_workspace.workspace.id
}

resource "tfe_variable" "sensitive_terraform_cloud_variables" {
  for_each = var.sensitive_variables

  key          = each.key
  value        = each.value
  category     = "terraform"
  sensitive    = true
  workspace_id = tfe_workspace.workspace.id
}