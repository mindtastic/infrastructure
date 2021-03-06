locals {
  k8s_pod_subnet_name     = "vpc-pod-range-${var.environment}"
  k8s_service_subnet_name = "vpc-service-range-${var.environment}"
}

resource "google_compute_network" "vpc_network" {
  project                         = var.project_name
  name                            = "kubernetes-vpc-${var.environment}"
  auto_create_subnetworks         = false
  delete_default_routes_on_create = true
}

resource "google_compute_subnetwork" "vpc_subnet" {
  name                     = "kubernetes-vpc-subnet-${var.environment}"
  ip_cidr_range            = var.k8s_node_subnet
  region                   = var.region
  network                  = google_compute_network.vpc_network.id
  private_ip_google_access = true
  secondary_ip_range {
    range_name    = local.k8s_pod_subnet_name
    ip_cidr_range = var.k8s_pod_subnet
  }
  secondary_ip_range {
    range_name    = local.k8s_service_subnet_name
    ip_cidr_range = var.k8s_service_subnet
  }
}

resource "google_compute_route" "egress_internet" {
  name             = "vpc-egress-internet-${var.environment}"
  dest_range       = "0.0.0.0/0"
  network          = google_compute_network.vpc_network.name
  next_hop_gateway = "default-internet-gateway"
}

resource "google_compute_router" "vpc_router" {
  name    = "kubernetes-vpc-router-${var.environment}"
  region  = var.region
  project = var.project_name
  network = google_compute_network.vpc_network.name
}

resource "google_compute_router_nat" "vpc_nat" {
  name    = "kubernetes-vpc-nat-${var.environment}"
  project = var.project_name
  router  = google_compute_router.vpc_router.name
  region  = var.region

  nat_ip_allocate_option             = "AUTO_ONLY"
  source_subnetwork_ip_ranges_to_nat = "LIST_OF_SUBNETWORKS"

  subnetwork {
    name                    = google_compute_subnetwork.vpc_subnet.name
    source_ip_ranges_to_nat = ["ALL_IP_RANGES"]
  }

  log_config {
    enable = true
    filter = "ERRORS_ONLY"
  }
}
