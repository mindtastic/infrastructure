resource "cloudflare_record" "mindtastic_lol" {
  for_each = toset(google_dns_managed_zone.mindtastic_lol.name_servers)

  zone_id = var.cloudflare_zone_id
  name    = "@"
  value   = each.key
  type    = "NS"
  ttl     = 3600
}

resource "google_dns_managed_zone" "mindtastic_lol" {
  name        = "mindtastic-root-zone"
  dns_name    = "mindtastic.lol."
  description = "The base DNS zone, delegated from Cloudflare"
}

resource "google_dns_managed_zone" "live" {
  name        = "mindtastic-live-zone"
  dns_name    = "live.mindtastic.lol."
  description = "The base DNS zone for live environment"
}

resource "google_dns_record_set" "live" {
  name = "live.${google_dns_managed_zone.mindtastic_lol.dns_name}"
  type = "NS"
  ttl  = 300

  managed_zone = google_dns_managed_zone.mindtastic_lol.name

  rrdatas = toset(google_dns_managed_zone.live.name_servers)
}
