# Global DNS
resource "cloudflare_record" "teleport_live_public" {
  zone_id = var.cloudflare_zone_id
  name    = "teleport"
  value   = "teleport.net.live.mindtastic.lol"
  type    = "CNAME"
}

resource "cloudflare_record" "teleport_live_public_wildcard" {
  zone_id = var.cloudflare_zone_id
  name    = "*.teleport"
  value   = "teleport.net.live.mindtastic.lol"
  type    = "CNAME"
}
