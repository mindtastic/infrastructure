resource "google_dns_managed_zone" "root" {
  name        = "mindtastic-zone-${var.environment}"
  dns_name    = var.cluster_dns_zone_name
  description = "The base DNS zone for ${var.environment} environment"
}
