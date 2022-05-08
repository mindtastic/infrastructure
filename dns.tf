resource "google_dns_managed_zone" "live" {
  name        = "mindtastic-live-zone"
  dns_name    = "live.mindtastic.lol."
  description = "The base DNS zone for live environment"
}

resource "cloudflare_record" "live_mindtastic_lol" {
  # Google cloud returns four nameservers for each dns managed zone
  count = 4

  zone_id = var.cloudflare_zone_id
  name    = "live"
  value   = google_dns_managed_zone.live.name_servers[count.index]
  type    = "NS"
  ttl     = 3600
}
