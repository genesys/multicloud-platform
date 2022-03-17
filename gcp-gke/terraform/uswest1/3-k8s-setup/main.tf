module "k8s-setup" {
    source        = "../../../tfm/3-k8s-setup/" #github.com/genesys/multicloud-platform.git//gcp-gke/tfm/3-k8s-setup?ref=master"
    project_id   = "project01"
    network_name = "network01"
    ipv4         = "10.198.12.0/22"
}

data "google_client_config" "provider" {}

data "google_container_cluster" "cluster02" {
  name = "cluster02"
  location = "us-west1"
  project = "gcpe0003"
}

provider "google" {
  project = "gcpe0003"
}

provider "kubernetes" {
  host = "https://${data.google_container_cluster.cluster02.endpoint}"
  token = data.google_client_config.provider.access_token
  cluster_ca_certificate = base64decode(
    data.google_container_cluster.cluster02.master_auth[0].cluster_ca_certificate,
  ) 
}

variable "helm_version" {
default = "v2.9.1"
}

provider "helm" {
  kubernetes {
    host = "https://${data.google_container_cluster.cluster02.endpoint}"
    token = data.google_client_config.provider.access_token
    cluster_ca_certificate = base64decode(
    data.google_container_cluster.cluster02.master_auth[0].cluster_ca_certificate,
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
    bucket = "tf-statefiles" 
    prefix = "k8s-setup-cluster02-uswest1-state" #creates a new folder
  }
}