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

resource "google_compute_network_peering" "live_dev_peering" {
  count = local.live_dev_exists ? 1 : 0

  name         = "live-dev-peering"
  network      = data.google_compute_network.live_network.self_link
  peer_network = data.google_compute_network.dev_network.self_link
}

resource "google_compute_network_peering" "dev_live_peering" {
  count = local.live_dev_exists ? 1 : 0

  name         = "dev-live-peering"
  network      = data.google_compute_network.dev_network.self_link
  peer_network = data.google_compute_network.live_network.self_link
}

resource "google_compute_network_peering" "live_stage_peering" {
  count = local.live_stage_exists ? 1 : 0

  name         = "live-stage-peering"
  network      = data.google_compute_network.live_network.self_link
  peer_network = data.google_compute_network.stage_network.self_link
}

resource "google_compute_network_peering" "stage_live_peering" {
  count = local.live_stage_exists ? 1 : 0

  name         = "stage-live-peering"
  network      = data.google_compute_network.stage_network.self_link
  peer_network = data.google_compute_network.live_network.self_link
}
