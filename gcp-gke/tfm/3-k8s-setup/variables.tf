variable "project_id" {
  type = string
  description = "The ID of the project this setup will be done"
}

variable "network_name" {
  type = string
  description = "VPC network name"
}


variable "ipv4" {
  type        = string
  description = "Reserved CIDR block for storage class"
}

