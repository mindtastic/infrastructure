# We query the Terraform Cloud Runner's public IP address to grant network access 
# to the Kubernetes Control Plane only to this IP.
data "http" "tfc_runner_ip" {
  url = "http://ipv4.icanhazip.com"
}

data "google_dns_managed_zone" "cluster_root" {
  name = var.cluster_dns_zone_name
}