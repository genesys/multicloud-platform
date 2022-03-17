variable "project" {
    type = string
    description = "project name"
}
variable "description" {
    default = ""
    type = string
    description = "Optional description for Jumphost"
}
variable "machine_type" {
  type = string
  description = "Type of machine to be used for Jumphost"
}

variable "name" {
  type = string
  description = "This is bastion host name"
  
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
  description = "select network vm to be launched"

}

variable "subnetwork" {
  type = string
  description = "part of network"
}


variable "provision_ssh_firewall" {
  type = bool
  description = "Flag for creating a firewall rule"
  default     = true
}

variable "provision_iap_firewall" {
  type = bool
  description = "Flag for creating a firewall rule"
  default     = true
}

variable "create_iap_iam_role" {
  type = bool
  description = "Flag for creating a firewall rule"
  default     = true
}

variable "members" {
  type = list(string)
  description = "Members who need IAP access"
  default     = []
}