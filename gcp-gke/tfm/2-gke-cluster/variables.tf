variable "project_id" {
  type = string
  description = "project id"
}

variable "environment" {
  type = string
  description = "environment"
}

variable "region" {
  type = string
  description = "region"
}


variable "cluster" {
  type = string
  description = "cluster name"
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
  description = "CIDR block for Pod IPs"
}

variable "secondary_service_range" {
  type = string
  description = "CIDR block for Pod IPs"
}

variable "network_name" {
  type = string
  description = "the network name of the gke cluster"
}

variable "gke_num_nodes" {
  type = string
  description = "the number of nodes in each az"
}
variable "windows_node_pool" {
  type = bool
  default     = false
  description = "Flag to provision windows node pool"
}
