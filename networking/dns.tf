


# Global DNS
resource "cloudflare_record" "teleport_live_public" {
  zone_id = var.cloudflare_zone_id
  name    = "teleport"
  value   = data.tfe_outputs.live.values.teleport_internal_dns_name
  type    = "CNAME"
  ttl     = 30
}

resource "cloudflare_record" "teleport_live_public_wildcard" {
  zone_id = var.cloudflare_zone_id
  name    = "*.teleport"
  value   = data.tfe_outputs.live.values.teleport_internal_dns_name
  type    = "CNAME"
  ttl     = 30
}
