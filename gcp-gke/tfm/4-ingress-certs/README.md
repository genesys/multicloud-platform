# Terraform Ingress Certs Module

This module handles the creation of ingress, cert manager and let's encrypt cert issuer.

## Usage

Basic usage of this module is as follows:

```hcl
module "ingress_certs" {
  source                = "github.com/genesys/multicloud-platform.git//gcp-gke/tfm/4-ingress-certs?ref=master"
  project_id            = "<project id>" eg.gcpe0003
  environment           = "<The environment where these resources will get created>" eg.gcpe003
  domain_name_nginx     = "<domain name>" 
  cert_manager_version  = "1.5.4"
  email                 = "<john@example.com>"
}

#Kubernetes

data "google_client_config" "provider" {}

data "google_container_cluster" "gke1" {
  name = "<cluster name>"
  location = "<cluster region>"
  project = "<project ID>"
}

provider "kubernetes" {
  host = "https://${data.google_container_cluster.gke1.endpoint}"
  token = data.google_client_config.provider.access_token
  cluster_ca_certificate = base64decode(
    data.google_container_cluster.gke1.master_auth[0].cluster_ca_certificate,
  ) 
}

#Helm

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


provider "google" {
  project = <PROJECT ID>
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
    bucket =  "<your_globally_unique_bucket_name>"  #Replace with the name of the bucket created in Module 0
    prefix = "ingress-certs-state" #creates a new folder within the bucket
  }
}


```

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| project_id or project | The project ID to deploy to | `string` | n/a | yes |
| environment | The environment where these resources will be created, used for naming conventions | `string` | n/a | yes |
| domain_name_nginx | Load balancer domain name | `string` | n/a | yes |
| email | Email address for certificate issuers | `string` | n/a | yes |
| cert_manager_version | Certificate manager version | `string` | 1.5.4 | no |
| name | Cluster name where resources will be created | `string` | n/a | yes |
| location | Region of the cluster | `string` | n/a | yes |
| bucket | Name of the bucket created in module 0 | `string` | n/a | yes |
| prefix | Name of folder to be created within bucket | `string` | n/a | yes |



