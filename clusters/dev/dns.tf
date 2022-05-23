resource "google_dns_managed_zone" "root" {
  name        = "mindtastic-zone-${var.environment}"
  dns_name    = "${var.environment}.mindtastic.lol."
  description = "The base DNS zone for ${var.environment} environment"
}