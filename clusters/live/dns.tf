resource "google_dns_managed_zone" "root" {
  name        = "mindtastic-zone-${var.environment}"
  dns_name    = var.cluster_dns_zone_name
  description = "The base DNS zone for ${var.environment} environment"
}

# Teleport
resource "google_dns_record_set" "teleport_internal" {
  name         = "teleport.net.${google_dns_managed_zone.root.dns_name}"
  type         = "A"
  ttl          = 300
  managed_zone = google_dns_managed_zone.root.name
  rrdatas      = [module.teleport.teleport_public_ip]
}
