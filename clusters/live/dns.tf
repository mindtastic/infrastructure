resource "google_dns_managed_zone" "root" {
  name        = "mindtastic-zone-${var.environment}"
  dns_name    = "${var.environment}.mindtastic.lol."
  description = "The base DNS zone for ${var.environment} environment"
}

# Teleport
resource "google_dns_record_set" "teleport_internal" {
  name         = "teleport.net.${google_dns_managed_zone.live.dns_name}"
  type         = "A"
  ttl          = 300
  managed_zone = google_dns_managed_zone.live.name
  rrdatas      = [module.teleport.teleport_public_ip]
}

resource "cloudflare_record" "teleport_live_public" {
  zone_id = var.cloudflare_zone_id
  name    = "teleport"
  value   = google_dns_record_set.teleport_internal.name
  type    = "CNAME"
  ttl     = 1
}

resource "cloudflare_record" "teleport_live_public_wildcard" {
  zone_id = var.cloudflare_zone_id
  name    = "*.teleport"
  value   = google_dns_record_set.teleport_internal.name
  type    = "CNAME"
  ttl     = 1
}
