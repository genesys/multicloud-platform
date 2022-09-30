variable "project_id" {
  type = string
  description = "Project ID"
}

variable "region" {
  type = string
  description = "Region"
}


variable "cluster" {
  type = string
  description = "Cluster name"
}

variable "gke_version" {
  type = string
  description = "GKE cluster version"
}

variable "release_channel" {
  type = string
  description = "Release channel for the selected GKE cluster version"
}

variable "secondary_pod_range" {
  type = string
  description = "CIDR block for pod IPs"
}

variable "secondary_service_range" {
  type = string
  description = "CIDR block for service IPs"
}

variable "network_name" {
  type = string
  description = "The network name of the GKE cluster"
}

variable "gke_num_nodes" {
  type = string
  description = "The number of nodes in each availability zone"
}
variable "windows_node_pool" {
  type        = bool
  default     = false
  description = "Flag to provision windows node pool"
}
