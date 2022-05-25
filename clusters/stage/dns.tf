resource "google_dns_managed_zone" "root" {
  name        = "mindtastic-zone-${var.environment}"
  dns_name    = "${var.environment}.mindtastic.lol."
  description = "The base DNS zone for ${var.environment} environment"
}

resource "cloudflare_record" "cloudflare_federation" {
  # This is a workaround to a problem rooted deeply within Terraform itself:
  # https://github.com/hashicorp/terraform/issues/30937
  # Since Terraform does not know the length of
  # `google_dns_managed_zone.live.name_servers` at plan time, we hardcode the number of servers here.
  # Google always returns four nameserver to set as DNS records.
  # This works until it won't. If Google returns fewer servers, apply will fail. If Google returns more, we ignore them.
  count = 4

  zone_id = var.cloudflare_zone_id
  name    = var.environment
  type    = "NS"
  ttl     = 3600

  # Google Cloud API returns name servers strings with a trailing dot
  # Cloudflare API drops those dots on applying the request.
  # We remove the trailing dot to prevent terraform from
  # updating the DNS records on every run.
  # See: https://github.com/mindtastic/infrastructure/pull/51
  value = trimsuffix(google_dns_managed_zone.root.name_servers[count.index], ".")
}
