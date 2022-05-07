resource "google_dns_managed_zone" "live" {
  name        = "mindtastic-live-zone"
  dns_name    = "live.mindtastic.lol."
  description = "The base DNS zone for live environment"
}

resource "cloudflare_record" "live_mindtastic_lol" {
  for_each = toset(google_dns_managed_zone.live.name_servers)

  zone_id = var.cloudflare_zone_id
  name    = "live"
  value   = each.key
  type    = "NS"
  ttl     = 3600
}
