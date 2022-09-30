# Terraform k8s setup Module

This module supports creating:

- A storage class

## Usage

Basic usage of this module is as follows:

```hcl
module "network" {
    source        = "../../../tfm/3-k8s-setup/" #"github.com/genesys/multicloud-platform.git//gcp-gke/tfm/3-k8s-setup?ref=master"
    project_id    = "<project ID>" #eg. project01
    network_name  = "<name of your VPC network>" #eg. network01
    ipv4          = "<reserved IPv4 CIDR for storage class>" #1024 IP addresses
}


provider "google" {
  project = "<project ID>"
}

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
data "google_client_config" "provider" {}


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
    bucket = "<your globally unique bucket name>" #Replace with the name of the bucket created in module 0
    prefix = "<cluster name>-k8s-state" #Creates a new folder within the bucket
  }
}
```

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| project\_id or project | The ID of the project where these resources will be created | `string` | n/a | yes |
| network\_name | The name of the network being created | `string` | n/a | yes |
| ipv4 | The IPv4 address reserved for the storage class | `string` | n/a | yes |
| name | Cluster name where resources will be created | `string` | n/a | yes |
| location | Region of the cluster | `string` | n/a | yes |
| bucket | Name of the bucket created in module 0 | `string` | n/a | yes |
| prefix | Name of folder to be created within bucket | `string` | n/a | yes |


<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
