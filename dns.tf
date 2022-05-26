resource "google_dns_managed_zone" "dev_root" {
  name        = "mindtastic-zone-dev"
  dns_name    = "dev.${local.dns_root_zone_name}"
  description = "The base DNS zone for dev environment"
}

resource "google_dns_managed_zone" "stage_root" {
  name        = "mindtastic-zone-stage"
  dns_name    = "stage.${local.dns_root_zone_name}"
  description = "The base DNS zone for stage environment"
}

resource "google_dns_managed_zone" "live_root" {
  name        = "mindtastic-zone-live"
  dns_name    = "live.${local.dns_root_zone_name}"
  description = "The base DNS zone for live environment"
}

resource "cloudflare_record" "cloudflare_dev" {
  # This is a workaround to a problem rooted deeply within Terraform itself:
  # https://github.com/hashicorp/terraform/issues/30937
  # Since Terraform does not know the length of
  # `google_dns_managed_zone.live.name_servers` at plan time, we hardcode the number of servers here.
  # Google always returns four nameserver to set as DNS records.
  # This works until it won't. If Google returns fewer servers, apply will fail. If Google returns more, we ignore them.
  count = 4

  zone_id = var.cloudflare_zone_id
  name    = "dev"
  type    = "NS"
  ttl     = 3600

  # Google Cloud API returns name servers strings with a trailing dot
  # Cloudflare API drops those dots on applying the request.
  # We remove the trailing dot to prevent terraform from
  # updating the DNS records on every run.
  # See: https://github.com/mindtastic/infrastructure/pull/51
  value = trimsuffix(google_dns_managed_zone.dev_root.name_servers[count.index], ".")
}

resource "cloudflare_record" "cloudflare_stage" {
  count = 4

  zone_id = var.cloudflare_zone_id
  name    = "stage"
  type    = "NS"
  ttl     = 3600

  value = trimsuffix(google_dns_managed_zone.stage_root.name_servers[count.index], ".")
}

resource "cloudflare_record" "cloudflare_live" {
  count = 4

  zone_id = var.cloudflare_zone_id
  name    = "live"
  type    = "NS"
  ttl     = 3600

  value = trimsuffix(google_dns_managed_zone.live_root.name_servers[count.index], ".")
}
