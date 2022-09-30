variable "network_name" {
  description = "Name of the VPC network for firewall rule"
}

variable "ip_name" {
  description = "Name for the reserved IP address"
}

variable "subnetwork" {
  description = "Subnetwork for reserving internal IP"
}

variable "region"{
  description = "Subnet region for internal IP"
}

variable "provision_firewall_ingress" {
  type        = bool
  description = "Flag for creating a firewall rule"
  default     = true
}

variable "ip_source_ranges" {
  description = "Source IP address ranges for ingress traffic (CIDR format)"
  default = "0.0.0.0/0"
}

variable "tcp_ingress_ports" {
  description = "Ports to allow ingress TCP traffic on"
  default     = ["22", "3389", "5080"]
}

variable "udp_ingress_ports" {
  description = "Ports to allow ingress UDP traffic on"
  default     = ["53", "5080"]
}