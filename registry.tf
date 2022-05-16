resource "google_artifact_registry_repository" "container_registry" {
  location = var.location
  repository_id = "mindtastic"
  description = "The Container registry for mindtastic Docker images."
  format = "DOCKER"
}