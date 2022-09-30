This example file can be used as follows. Additional details and list of required inputs can be found in the [module documentation](../../../tfm/4-ingress-certs/README.md)

```hcl
module "ingress_certs" {
  source            = "../../../tfm/4-ingress-certs/" #"github.com/genesys/multicloud-platform.git//gcp-gke/tfm/4-ingress-certs?ref=master"
  project_id        = "<project ID>" #eg. project01
  network_name      = "<name of the VPC network>" #eg. network01
  domain_name_nginx = "<domain name>" #eg. lb02-useast1.domain.example.com (domain.example.com should be same as FQDN in module 1)
  email             = "<email for certificate issuers>" #eg. jane.doe@email.com
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
  project = "<project ID>"
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
    bucket =  "<your globally unique bucket name>"  #Replace with the name of the bucket created in module 0
    prefix = "ingress-state" #Creates a new folder within the bucket
  }
}


```




