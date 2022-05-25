output "dns_zone_names" {
  description = "Name Servers for the root DNS zone in this environment"
  value       = google_dns_managed_zone.root.name_servers

  depends_on = [
    google_dns_managed_zone.root
  ]
}

output "vpc_self_link" {
  description = "Self Link of VPC for this Cluster"
  value       = google_compute_network.vpc_network.self_link

  depends_on = [
    google_compute_network.vpc_network
  ]
}
