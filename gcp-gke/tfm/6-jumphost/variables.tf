variable "project" {
    type = string
    description = "Project name"
}
variable "description" {
    default = ""
    type = string
    description = "Optional description for jumphost"
}
variable "machine_type" {
  type = string
  description = "Type of machine to be used for jumphost"
}

variable "name" {
  type = string
  description = "Bastion host name"
  
}

variable "zone" {
    type =  string
    description = "Zone where machine is to be deployed"
}

variable "image" {
  type = string
  description = "OS image"
}


variable "network" {
  type = string
  description = "Network where VM will be launched"

}

variable "subnetwork" {
  type = string
  description = "Part of network"
}


variable "provision_ssh_firewall" {
  type = bool
  description = "flag for creating a firewall rule"
  default     = true
}

variable "provision_iap_firewall" {
  type = bool
  description = "flag for creating a firewall rule"
  default     = true
}

variable "create_iap_iam_role" {
  type = bool
  description = "Flag for creating an IAP IAM role"
  default     = true
}

variable "members" {
  type = list(string)
  description = "Members who need IAP access"
  default     = []
}