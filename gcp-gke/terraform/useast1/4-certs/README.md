This example file can be used as follows. Additional details and list of required inputs can be found in the [module documentation](../../../tfm/4-ingress-certs/README.md)

```hcl
module "ingress_certs" {
  source            = "../../../tfm/4-ingress-certs/" #github.com/genesys/multicloud-platform.git//gcp-gke/tfm/4-ingress-certs?ref=master
  project_id        = "<project id>" eg.gcpe0003
  environment       = "<The environment where these resources will get created>" eg.gcpe003
  domain_name_nginx = "<domain name>" 
  email             = "<john@example.com>"
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
    bucket =  <Bucket Name>  #Replace with the name of the bucket created in Module 0
    prefix = "ingress-state" #creates a new folder within the bucket
  }
}


```




