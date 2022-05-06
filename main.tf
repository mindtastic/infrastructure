resource "google_service_account" "default" {
  account_id   = "service-account-id"
  display_name = "Service Account"
}

resource "google_container_cluster" "primary" {
  name     = "k8s-gke-cluster"
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
    # TODO: Don't hardcode names here
    cluster_secondary_range_name  = "vpc-pod-range"
    services_secondary_range_name = "vpc-service-range"
  }

  private_cluster_config {
    enable_private_nodes    = true
    enable_private_endpoint = false
    master_ipv4_cidr_block  = "172.16.0.0/28"
  }

  depends_on = [
    google_compute_subnetwork.vpc_subnet
  ]
}

resource "google_container_node_pool" "primary_preemptible_nodes" {
  name       = "k8s-node-pool"
  location   = var.region
  cluster    = google_container_cluster.primary.name
  node_count = 1

  node_config {
    preemptible  = true
    machine_type = "e2-medium"

    # Google recommends custom service accounts that have cloud-platform scope and permissions granted via IAM Roles.
    service_account = google_service_account.default.email
    oauth_scopes = [
      "https://www.googleapis.com/auth/cloud-platform"
    ]
  }
}
