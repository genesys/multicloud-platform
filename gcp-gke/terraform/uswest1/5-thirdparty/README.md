This example file can be used as follows. Additional details and list of required inputs can be found in the [module documentation](../../../tfm/5-third-party/README.md)

```hcl
module "third-party" {
    source  = "../../../tfm/5-third-party/" #"github.com/genesys/multicloud-platform.git//gcp-gke/tfm/5-third-party?ref=master"
    consul_helm_version = "0.41.0"
    consul_image        = "hashicorp/consul:1.11.3"
    consul_imageK8S     = "hashicorp/consul-k8s-control-plane:0.41.0"
    consul_datacenter   = "uswest1"
}

#Kubernetes
data "google_client_config" "provider" {}
data "google_container_cluster" "<cluster name>" {
  name     = <cluster name>
  location = <cluster location>
  project  = <project ID>
}

provider "kubernetes" {
  host  = "https://${data.google_container_cluster.<cluster name>.endpoint}"
  token = data.google_client_config.provider.access_token
  cluster_ca_certificate = base64decode(
    data.google_container_cluster.<cluster name>.master_auth[0].cluster_ca_certificate,
    #google_container_cluster.primary.master_auth.0.cluster_ca_certificate
  )
}

#Helm

variable "helm_version" {
  default = "v2.9.1"
}
provider "helm" {

  kubernetes {
    host  = "https://${data.google_container_cluster.<cluster name>.endpoint}"
    token = data.google_client_config.provider.access_token
    cluster_ca_certificate = base64decode(
      data.google_container_cluster.<cluster name>.master_auth[0].cluster_ca_certificate,
      #google_container_cluster.primary.master_auth.0.cluster_ca_certificate
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
        bucket = "<your globally unique bucket name>" #Replace with the name of the bucket created in module 0
        prefix = "third-party-state" #Creates a new folder within bucket
    }
}
```