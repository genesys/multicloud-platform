# Terraform k8s setup Module

This module supports creating:

- A storage class

## Usage

Basic usage of this module is as follows:

```hcl
module "k8s-setup" {
    source        = "github.com/genesys/multicloud-platform.git//gcp-gke/tfm/3-k8s-setup?ref=master"
    project_id    = "<PROJECT ID eg.gcpe0002>"
    network_name  = "<Same as environment>"
    ipv4          = "<Reserved ipv4 for storage class>" #1024 IP addresses. Example CIDR block 10.198.12.0/22
}


provider "google" {
  project = <PROJECT ID>
}

data "google_container_cluster" "gke1" {
  name = "<cluster name>"
  location = "<cluster region>"
  project = "<project id>"
}

provider "kubernetes" {
  host = "https://${data.google_container_cluster.gke1.endpoint}"
  token = data.google_client_config.provider.access_token
  cluster_ca_certificate = base64decode(
    data.google_container_cluster.gke1.master_auth[0].cluster_ca_certificate,
  ) 
}

#Helm
data "google_client_config" "provider" {}


variable "helm_version" {
default = "v2.9.1"
}

provider "helm" {
  kubernetes {
    host = "https://${data.google_container_cluster.gke1.endpoint}"
    token = data.google_client_config.provider.access_token
    cluster_ca_certificate = base64decode(
    data.google_container_cluster.gke1.master_auth[0].cluster_ca_certificate,
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
    bucket = "<your_globally_unique_bucket_name>" #Replace with the name of the bucket created in Module 0
    prefix = "k8s-setup-state" #creates a new folder within the bucket
  }
}
```

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| project\_id or project | The ID of the project where these resources will be created | `string` | n/a | yes |
| network\_name | The name of the network being created | `string` | n/a | yes |
| ipv4 | The ipv4 address reserved for the storage class | `string` | n/a | yes |
| name | Cluster name where resources will be created | `string` | n/a | yes |
| location | Region of the cluster | `string` | n/a | yes |
| bucket | Name of the bucket created in module 0 | `string` | n/a | yes |
| prefix | Name of folder to be created within bucket | `string` | n/a | yes |


<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
