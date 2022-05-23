resource "tfe_workspace" "workspace" {
  name              = var.name
  organization      = var.organization
  auto_apply        = var.auto_apply
  execution_mode    = "remote"
  terraform_version = "1.2.0"

  vcs_repo {
    identifier     = var.repository
    oauth_token_id = var.github_oauth_token_id
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
  # Small hack because Terraform does not allow referring to map keys that are marked as sensitive.
  for_each = toset([for k, v in var.sensitive_variables : k])

  key          = each.key
  value        = var.sensitive_variables[each.key]
  category     = "terraform"
  sensitive    = true
  workspace_id = tfe_workspace.workspace.id
}
