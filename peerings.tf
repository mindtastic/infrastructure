# DEV <-> LIVE

resource "google_compute_network_peering" "dev-live" {
  name         = "dev-live"
  network      = data.tfe_outputs.dev.vpc_self_link
  peer_network = data.tfe_outputs.live.vpc_self_link
}

resource "google_compute_network_peering" "live-dev" {
  name         = "live-dev"
  network      = data.tfe_outputs.live.vpc_self_link
  peer_network = data.tfe_outputs.dev.vpc_self_link
}

# STAGE <-> LIVE

resource "google_compute_network_peering" "stage-live" {
  name         = "stage-live"
  network      = data.tfe_outputs.stage.vpc_self_link
  peer_network = data.tfe_outputs.live.vpc_self_link
}

resource "google_compute_network_peering" "live-stage" {
  name         = "live-stage"
  network      = data.tfe_outputs.live.vpc_self_link
  peer_network = data.tfe_outputs.stage.vpc_self_link
}
