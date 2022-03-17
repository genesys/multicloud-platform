#VPC outputs

output "network" {
  value       = google_compute_network.vpc[0]
  description = "The VPC resource being created"
}

output "network_name" {
  value       = google_compute_network.vpc[0].name
  description = "The name of the VPC being created"
}

output "network_id" {
  value       = google_compute_network.vpc[0].id
  description = "The ID of the VPC being created"
}

output "network_self_link" {
  value       = google_compute_network.vpc[0].self_link
  description = "The URI of the VPC being created"
}

#DNS Zone outputs

output "name" {
  description = "The DNS zone name."
  value       = google_dns_managed_zone.dns-zone.name
}

output "type" {
  description = "The DNS zone type."
  value       = google_dns_managed_zone.dns-zone.visibility
}

output "domain" {
  description = "The DNS zone domain."
  value       = google_dns_managed_zone.dns-zone.dns_name
}

output "name_servers" {
  description = "The DNS zone name servers."
  value       = google_dns_managed_zone.dns-zone.name_servers
}

#subnet outputs

output "subnets" {
  value       = google_compute_subnetwork.subnetwork
  description = "The created subnet resources"
}

#router output
output "router" {
  value       = google_compute_router.router
  description = "The created router"
}
