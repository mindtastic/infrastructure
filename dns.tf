resource "cloudflare_record" "mindtastic_lol" {
  for_each = toset(google_dns_managed_zone.mindtastic_lol.*.dns_name)

  zone_id = var.cloudflare_zone_id
  name    = "@"
  value   = each.key
  type    = "NS"
  ttl     = 3600
}


resource "google_dns_managed_zone" "mindtastic_lol" {
  name        = "mindtastic-root-zone"
  dns_name    = "mindtastic.com."
  description = "The base DNS zone, delegated from Cloudflare"
}
