# We query the Terraform Cloud Runner's public IP address to grant network access 
# to the Kubernetes Control Plane only to this IP.
data "http" "tfc_runner_ip" {
  url = "http://ipv4.icanhazip.com"
}
