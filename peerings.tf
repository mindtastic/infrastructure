data "google_compute_network" "live_network" {
  name = "kubernetes-vpc-live" # Matches clusters/live/vpc.tf
}

data "google_compute_network" "dev_network" {
  name = "kubernetes-vpc-dev"
}

data "google_compute_network" "stage_network" {
  name = "kubernetes-vpc-stage"
}

locals {
  # GCP data provider returns an object where google_compute_networks where all
  # string attributes are set to tostring(null) if empty or networks not exist.
  live_vpc_exists  = data.google_compute_network.live_network.self_link != tostring(null)
  dev_vpc_exists   = data.google_compute_network.dev_network.self_link != tostring(null)
  stage_vpc_exists = data.google_compute_network.stage_network.self_link != tostring(null)

  live_stage_exists = local.live_vpc_exists && local.stage_vpc_exists
  live_dev_exists   = local.live_vpc_exists && local.dev_vpc_exists
}

# LIVE <-> DEV


# LIVE <-> STAGE
