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
  live_stage_exists = try(data.google_compute_network.live_network, false) && try(data.google_compute_network.stage_network, false)
  live_dev_exists   = try(data.google_compute_network.live_network, false) && try(data.google_compute_network.dev_network, false)
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
