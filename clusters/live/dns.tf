# Teleport
resource "google_dns_record_set" "teleport_internal" {
  name         = "teleport.net.${data.google_dns_managed_zone.cluster_root.dns_name}"
  type         = "A"
  ttl          = 300
  managed_zone = data.google_dns_managed_zone.cluster_root.name
  rrdatas      = [module.teleport.teleport_public_ip]
}
