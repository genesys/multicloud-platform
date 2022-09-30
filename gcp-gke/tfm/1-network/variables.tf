variable "project_id" {
  type = string
  description = "The ID of the project where this VPC will be created"
}

variable "description" {
  type = string
  description = "VPC description"
  default     = ""
}

variable "network_name" {
  type = string
  description = "VPC network name"
}

variable "provision_vpc" {
  type = bool
  description = "Flag for creating a VPC network"
  default     = true
}

variable "subnets" {
  type        = list(map(string))
  description = "The list of subnets being created"
}

variable "region" {
  type        = list
  description = "Region where the router resides"
}

variable "fqdn" {
  type        = string
  description = "FQDN for the VPC"
}


