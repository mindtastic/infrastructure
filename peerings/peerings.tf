data "tfe_outputs" "dev" {
  organization = var.tfc_organization
  workspace    = var.dev_workspace_name
}

data "tfe_outputs" "stage" {
  organization = var.tfc_organization
  workspace    = var.stage_workspace_name
}

data "tfe_outputs" "live" {
  organization = var.tfc_organization
  workspace    = var.live_workspace_name
}

# DEV <-> LIVE

resource "google_compute_network_peering" "peering1" {
  name         = "dev-live"
  network      = data.tfe_outputs.dev.vpc_self_link
  peer_network = data.tfe_outputs.live.vpc_self_link
}

resource "google_compute_network_peering" "peering1" {
  name         = "live-dev"
  network      = data.tfe_outputs.live.vpc_self_link
  peer_network = data.tfe_outputs.dev.vpc_self_link
}

# STAGE <-> LIVE

resource "google_compute_network_peering" "peering1" {
  name         = "stage-live"
  network      = data.tfe_outputs.stage.vpc_self_link
  peer_network = data.tfe_outputs.live.vpc_self_link
}

resource "google_compute_network_peering" "peering1" {
  name         = "live-stage"
  network      = data.tfe_outputs.live.vpc_self_link
  peer_network = data.tfe_outputs.stage.vpc_self_link
}
