This example file can be used as follows. Additional details and list of required inputs can be found in the [module documentation](../../../tfm/3-k8s-setup/README.md)

```hcl
module "network" {
    source        = "../../../tfm/3-k8s-setup/" #github.com/genesys/multicloud-platform.git//gcp-gke/tfm/3-k8s-setup?ref=master"
    project_id    = "<PROJECT ID eg.gcpe0002>"
    network_name  = "<Same as environment>"
    ipv4          = "<Reserved ipv4 CIDR for storage class>" #1024 IP addresses
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
    bucket = <Bucket Name> #Replace with the name of the bucket created in Module 0
    prefix = "gke1-k8s-state" #creates a new folder within the bucket
  }
}
```

