resource "google_dns_record_set" "kubernetes_internal" {
  name         = "cluster.net.${data.google_dns_managed_zone.cluster_root.dns_name}"
  type         = "A"
  ttl          = 300
  managed_zone = data.google_dns_managed_zone.cluster_root.name
  rrdatas      = [google_container_cluster.primary.endpoint]
}
