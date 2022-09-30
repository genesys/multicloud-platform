module "third-party" {
    source  = "../../../tfm/5-third-party/" #github.com/genesys/multicloud-platform.git//gcp-gke/tfm/5-third-party?ref=master
    consul_helm_version = "0.41.0"
    consul_image        = "hashicorp/consul:1.11.3"
    consul_imageK8S     = "hashicorp/consul-k8s-control-plane:0.41.0"
    consul_datacenter   = "useast1"
}


data "google_client_config" "provider" {}
data "google_container_cluster" "cluster01" {
  name     = "cluster01"
  location = "us-east1"
  project  = "project01"
}

provider "kubernetes" {
  host  = "https://${data.google_container_cluster.cluster01.endpoint}"
  token = data.google_client_config.provider.access_token
  cluster_ca_certificate = base64decode(
    data.google_container_cluster.cluster01.master_auth[0].cluster_ca_certificate,
  )
}

#Helm

variable "helm_version" {
  default = "v2.9.1"
}
provider "helm" {

  kubernetes {
    host  = "https://${data.google_container_cluster.cluster01.endpoint}"
    token = data.google_client_config.provider.access_token
    cluster_ca_certificate = base64decode(
      data.google_container_cluster.cluster01.master_auth[0].cluster_ca_certificate,
    )
    config_path = "~/.kube/config"
  }
}

provider "google" {
  project = "project01"
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
        bucket = "tf-statefiles" #Replace with the name of the bucket created in module 0-remote-state
        prefix = "third-party-cluster01-useast1-state" #creates a new folder
    }
}