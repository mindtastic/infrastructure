resource "google_artifact_registry_repository" "container_registry" {
  provider = google-beta

  location      = var.region
  repository_id = "mindtastic"
  description   = "The Container registry for mindtastic Docker images."
  format        = "DOCKER"
}
