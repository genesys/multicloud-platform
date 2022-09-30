variable "primary_project" {
  description = "Primary project to create a peering connection from"
}

variable "primary_vpc" {
  description = "Primary VPC to create a peering connection from"
}

variable "peer_project" {
  description = "Peer project to create a peering connection to"
}

variable "peer_vpc" {
  description = "Peer VPC to create a peering connection to"
}

variable "peering_connection_name" {
  description = "Name of network"
}

variable "provision_firewall_ingress" {
  type = bool
  description = "Flag for creating a firewall rule"
  default     = true
}
