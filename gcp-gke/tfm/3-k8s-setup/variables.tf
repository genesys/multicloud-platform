variable "project_id" {
  type = string
  description = "The ID of the project this setup will be done"
}

variable "network_name" {
  type = string
  description = "VPC Name"
}


variable "ipv4" {
  type        = string
  description = "Resrved CIDR block for storage class"
}

#"10.198.12.0/22"

