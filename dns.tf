resource "google_dns_managed_zone" "live" {
  name        = "mindtastic-live-zone"
  dns_name    = "live.mindtastic.lol."
  description = "The base DNS zone for live environment"
}

resource "cloudflare_record" "live_mindtastic_lol" {
  # This is a workaround to a problem rooted deeply within Terraform itself:
  # https://github.com/hashicorp/terraform/issues/30937
  # Since Terraform does not know the length of
  # `google_dns_managed_zone.live.name_servers` at plan time, we hardcode the number of servers here.
  # This works until it won't. If Google returns fewer servers, apply will fail. If Google returns more, we ignore them.
  count = 4

  zone_id = var.cloudflare_zone_id
  name    = "live"
  value   = google_dns_managed_zone.live.name_servers[count.index]
  type    = "NS"
  ttl     = 3600
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
