# This module manages network peering, both networks must create a peering with
# each other for the peering to be functional.


data "google_compute_network" "primary_network" {
  name    = var.primary_vpc
  project = var.primary_project
}

data "google_compute_network" "peer_network" {
  name    = var.peer_vpc
  project = var.peer_project
}

resource "google_compute_network_peering" "peering1" {
  name         = var.peering_connection_name
  network      = data.google_compute_network.primary_network.self_link
  peer_network = data.google_compute_network.peer_network.self_link
}

resource "google_compute_firewall" "firewall" {
  count = var.provision_firewall == true ? 1 : 0
  name    = "peering-firewall-rule"
  network = data.google_compute_network.primary_network.self_link

  allow {
    protocol = "icmp"
  }

  allow {
    protocol = "tcp"
    ports    = ["22", "3389", "5080"]
  }

  allow {
    protocol = "udp"
    ports    = ["5080"]
  }
}