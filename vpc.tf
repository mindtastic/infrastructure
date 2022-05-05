locals {
    k8s_node_subnet = "10.10.0.0/16"
    k8s_pod_subnet = "10.11.0.0/16"
    k8s_service_subnet = "10.12.0.0/16"
}

resource "google_compute_network" "vpc_network" {
  project                 = var.project_name
  name                    = "kubernetes-vpc"
  auto_create_subnetworks = false
  delete_default_routes_on_create = true
}

resource "google_compute_subnetwork" "vpc_subnet" {
  name = "kubernetes-vpc-subnet"
  ip_cidr_range = local.k8s_node_subnet
  region = var.region
  network = google_compute_network.vpc_network.id
  secondary_ip_range {
      range_name = "vpc-pod-range"
      ip_cidr_range = local.k8s_pod_subnet
  }
  secondary_ip_range {
      range_name = "vpc-service-range"
      ip_cidr_range = local.k8s_service_subnet
  }
}