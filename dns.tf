# This only works after the other workspaces exist!

# # Public DNS

# resource "cloudflare_record" "teleport_live_public" {
#   zone_id = var.cloudflare_zone_id
#   name    = "teleport"
#   value   = google_dns_record_set.teleport_internal.name
#   type    = "CNAME"
#   ttl     = 1
# }

# resource "cloudflare_record" "teleport_live_public_wildcard" {
#   zone_id = var.cloudflare_zone_id
#   name    = "*.teleport"
#   value   = google_dns_record_set.teleport_internal.name
#   type    = "CNAME"
#   ttl     = 1
# }
