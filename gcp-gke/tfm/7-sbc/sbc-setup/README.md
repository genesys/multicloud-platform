# SBC Setup

This module handles:
- reserving an IP for load balancer
- creating ingress firewall rule
- creating an internal load balancer

## Usage

Basic usage of this module is as follows:

```hcl
module "sbc-setup" {
  source               = "../../../tfm/7-sbc/sbc-setup/" #"github.com/genesys/multicloud-platform.git//gcp-gke/tfm/7-sbc/sbc-setup?ref=master"
  network_name         = "<name of VPC network for firewall rule>" #eg. network01
  ip_name              = "<name for the reserved IP address>" #eg. sip-address-useast1
  subnetwork           = "<name of subnetwork for reserving internal IP>" #eg. network01-us-east1-subnet
  region               = "<subnet region for internal IP>" #eg. us-east1
  provision_firewall_ingress   = true/false
  ip_source_ranges     = "<source IP address ranges for ingress traffic (CIDR format)>" #Optional. Default set to allow all (0.0.0.0/0)
  tcp_ingress_ports    = [<ports to allow ingress TCP traffic on>] #Optional. Default set to ["22", "3389", "5080"]
  udp_ingress_ports    = [<ports to allow ingress UDP traffic on>] #Optional. Default set to ["53", "5080"]
}

#Kubernetes

data "google_client_config" "provider" {}

data "google_container_cluster" "<cluster name>" {
  name = "<cluster name>"
  location = "<cluster region>"
  project = "<project ID>"
}

provider "kubernetes" {
  host = "https://${data.google_container_cluster.<cluster name>.endpoint}"
  token = data.google_client_config.provider.access_token
  cluster_ca_certificate = base64decode(
    data.google_container_cluster.<cluster name>.master_auth[0].cluster_ca_certificate,
  ) 
}

#Helm

variable "helm_version" {
default = "v2.9.1"
}

provider "helm" {
  kubernetes {
    host = "https://${data.google_container_cluster.<cluster name>.endpoint}"
    token = data.google_client_config.provider.access_token
    cluster_ca_certificate = base64decode(
    data.google_container_cluster.<cluster name>.master_auth[0].cluster_ca_certificate,
    )
    config_path = "~/.kube/config"
  } 
}


provider "google" {
  project = <project ID>
}

terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "3.52.0"
    }
  }

  required_version = "= 1.0.11"
}

terraform {
  backend "gcs" {
    bucket =  "<your globally unique bucket name>"  #replace with the name of the bucket created in module 0
    prefix = "sbc-setup-state" #creates a new folder within the bucket
  }
}


```

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| network_name | Network for firewall rule | `string` | n/a | yes |
| ip_name | Name for reserved IP address | `string` | n/a | yes |
| subnetwork | Subnetwork for reserving internal IP | `string` | n/a | yes |
| region | Subnet region for internal IP | `string` | n/a | yes |
| provision_firewall_ingress | Flag for creating a firewall rule | `bool` | true | no |
| ip_source_ranges | Source IP address ranges for ingress traffic (CIDR format) | `string` | "0.0.0.0/0" | no |
| tcp_ingress_ports | Ports to allow ingress TCP traffic on | `list` | ["22", "3389", "5080"] | no |
| udp_ingress_ports | Ports to allow ingress UDP traffic on | `list` | ["53", "5080"] | no|