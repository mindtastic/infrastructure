resource "google_dns_managed_zone" "live" {
  name        = "mindtastic-zone-${var.environment}"
  dns_name    = "${var.environment}.mindtastic.lol."
  description = "The base DNS zone for live environment"
}