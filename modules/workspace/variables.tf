variable "organization" {
  type        = string
  description = "Terraform Cloud Organization"
}

variable "name" {
  type        = string
  description = "Workspace Name"
}

variable "auto_apply" {
  type        = bool
  description = "Auto Apply this workspace"
}

variable "repository" {
  type        = string
  description = "GitHub Repository with GitHub Organization name"
}

variable "workspace_path" {
  type        = string
  description = "Directory for to watch for changes"
}

variable "github_oauth_token_id" {
  type        = string
  description = "ID of VCS Oauth Token"
}

variable "variables" {
  type        = map(string)
  description = "Non-sensitive Variables to store in the workspace"
}

variable "sensitive_variables" {
  type        = map(string)
  description = "Sensitive Variables to store in the workspace"
}

variable "TFC_CONFIGURATION_VERSION_GIT_BRANCH" {
  type        = string
  description = "Do not set this variable. Value will be injected by Terraform Cloud."
  default     = ""
}
