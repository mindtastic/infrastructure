output "dns_zone_names" {
  description = "Name Servers for the root DNS zone in this environment"
  value       = google_dns_managed_zone.root.name_servers
}
