
# Creating a VPC Network
resource "google_compute_network" "vpc" {
  count                           = var.provision_vpc == true ? 1 : 0
  name                            = var.network_name
  auto_create_subnetworks         = "false"
  routing_mode                    = "GLOBAL"
  project                         = var.project_id
  description                     = var.description
  delete_default_routes_on_create = "false"
}

# DNS zone creation
resource "google_dns_managed_zone" "dns-zone" {
  project     = var.project_id
  name        = "base-dns-global-${var.network_name}"
  dns_name    = var.fqdn
  description = "base-dns-global-${var.network_name}"
  visibility  = "public"

  dnssec_config {
      state = "off"
  }

  depends_on = [
    google_compute_network.vpc[0]
  ]
}

#NAT, Router creation

resource "google_compute_router" "router" {
  for_each    = toset(var.region)
  name        = "natrouter-${each.value}-${var.network_name}"
  network     = var.network_name
  region      = each.value
  project     = var.project_id
  #description = var.description
  depends_on = [
    google_compute_network.vpc[0]
  ]
}


resource "google_compute_router_nat" "nats" {
  for_each                           = toset(var.region)
  name                               = "natgw-${each.value}-${var.network_name}"
  project                            = var.project_id
  router                             = "natrouter-${each.value}-${var.network_name}"
  region                             = each.value
  nat_ip_allocate_option             = "AUTO_ONLY"
  source_subnetwork_ip_ranges_to_nat = "ALL_SUBNETWORKS_ALL_IP_RANGES"
  depends_on = [
    google_compute_network.vpc[0], google_compute_router.router
  ]
}


#subnets creation
locals {
  subnets = {
    for x in var.subnets :
    "${x.subnet_region}/${x.subnet_name}" => x
  }
}

/******************************************
	Subnet configuration
 *****************************************/
resource "google_compute_subnetwork" "subnetwork" {
  for_each                 = local.subnets
  name                     = each.value.subnet_name
  ip_cidr_range            = each.value.subnet_ip
  region                   = each.value.subnet_region
  network                  = var.network_name
  project                  = var.project_id
  description              = lookup(each.value, "description", null)
  
  depends_on = [
    google_compute_network.vpc[0]
  ]
}



