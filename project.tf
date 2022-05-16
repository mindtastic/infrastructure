locals {
  services = [
    "container.googleapis.com",
    "dns.googleapis.com",
    "iam.googleapis.com",
    "artifactregistry.googleapis.com"
  ]
}

resource "google_project_service" "project" {
  for_each = toset(local.services)

  project = var.project_name
  service = each.value

  timeouts {
    create = "30m"
    update = "40m"
  }

  disable_on_destroy         = true
  disable_dependent_services = true
}
