locals {
  tfc_runner_ip = "${chomp(data.http.tfc_runner_ip.body)}/32"
  cluster_name  = "${var.environment}-gke-${var.region}"
}

resource "google_service_account" "default" {
  account_id   = "service-account-id-${var.environment}"
  display_name = "Service Account Mindtastic ${var.environment}"
}

resource "google_container_cluster" "primary" {
  name     = local.cluster_name
  location = var.region

  # We can't create a cluster with no node pool defined, but we want to only use
  # separately managed node pools. So we create the smallest possible default
  # node pool and immediately delete it.
  remove_default_node_pool = true
  initial_node_count       = 1

  # Settings for making the cluster private and vpc-native
  network         = google_compute_network.vpc_network.self_link
  subnetwork      = google_compute_subnetwork.vpc_subnet.self_link
  networking_mode = "VPC_NATIVE"

  ip_allocation_policy {
    cluster_secondary_range_name  = local.k8s_pod_subnet_name
    services_secondary_range_name = local.k8s_service_subnet_name
  }

  private_cluster_config {
    enable_private_nodes    = true
    enable_private_endpoint = false
    master_ipv4_cidr_block  = var.k8s_control_plane_subnet
  }

  master_auth {
    client_certificate_config {
      issue_client_certificate = true
    }
  }

  master_authorized_networks_config {
    cidr_blocks {
      cidr_block   = "0.0.0.0/0" # local.tfc_runner_ip
      display_name = "Terraform Cloud Runner"
    }
  }

  depends_on = [
    google_compute_subnetwork.vpc_subnet
  ]
}

resource "google_container_node_pool" "primary_preemptible_nodes" {
  name       = "${var.environment}-gke-${var.region}-nodes"
  location   = var.region
  cluster    = google_container_cluster.primary.name
  node_count = var.cluster_node_count

  node_config {
    preemptible = true
    labels = {
      environment = var.environment
    }
    machine_type = var.cluster_node_type

    # Google recommends custom service accounts that have cloud-platform scope and permissions granted via IAM Roles.
    service_account = google_service_account.default.email
    oauth_scopes = [
      "https://www.googleapis.com/auth/cloud-platform"
    ]
  }
}

