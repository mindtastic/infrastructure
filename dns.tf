# This only works after the other workspaces exist!

resource "cloudflare_record" "dev_mindtastic_lol" {
  # This is a workaround to a problem rooted deeply within Terraform itself:
  # https://github.com/hashicorp/terraform/issues/30937
  # Since Terraform does not know the length of
  # `google_dns_managed_zone.live.name_servers` at plan time, we hardcode the number of servers here.
  # Google always returns four nameserver to set as DNS records.
  # This works until it won't. If Google returns fewer servers, apply will fail. If Google returns more, we ignore them.
  count = 4

  zone_id = var.cloudflare_zone_id
  name    = "dev"
  value   = data.tfe_outputs.dev.dns_zone_names[count.index]
  type    = "NS"
  ttl     = 3600

  depends_on = [
    module.cluster_dev
  ]
}

resource "cloudflare_record" "stage_mindtastic_lol" {
  # This is a workaround to a problem rooted deeply within Terraform itself:
  # https://github.com/hashicorp/terraform/issues/30937
  # Since Terraform does not know the length of
  # `google_dns_managed_zone.live.name_servers` at plan time, we hardcode the number of servers here.
  # Google always returns four nameserver to set as DNS records.
  # This works until it won't. If Google returns fewer servers, apply will fail. If Google returns more, we ignore them.
  count = 4

  zone_id = var.cloudflare_zone_id
  name    = "stage"
  value   = data.tfe_outputs.stage.dns_zone_names[count.index]
  type    = "NS"
  ttl     = 3600

  depends_on = [
    module.cluster_stage
  ]
}

resource "cloudflare_record" "live_mindtastic_lol" {
  # This is a workaround to a problem rooted deeply within Terraform itself:
  # https://github.com/hashicorp/terraform/issues/30937
  # Since Terraform does not know the length of
  # `google_dns_managed_zone.live.name_servers` at plan time, we hardcode the number of servers here.
  # Google always returns four nameserver to set as DNS records.
  # This works until it won't. If Google returns fewer servers, apply will fail. If Google returns more, we ignore them.
  count = 4

  zone_id = var.cloudflare_zone_id
  name    = "live"
  value   = data.tfe_outputs.live.dns_zone_names[count.index]
  type    = "NS"
  ttl     = 3600

  depends_on = [
    module.cluster_live
  ]
}

