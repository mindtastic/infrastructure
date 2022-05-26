output "workspace_id" {
  description = "ID of the TFC Workspace"
  value       = tfe_workspace.workspace.id
}

output "workspace_name" {
  description = "Name of TFC Workspace"
  value       = tfe_workspace.workspace.name
}
