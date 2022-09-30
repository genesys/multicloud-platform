module "sbc-setup" {
  source               = "../../../../../tfm/7-sbc/sbc-setup/" #"github.com/genesys/multicloud-platform.git//gcp-gke/tfm/7-sbc/sbc-setup?ref=master"
  network_name         = "network01"
  subnetwork           = "network01-us-east1-subnet"
  region               = "us-east1"
  ip_name              = "sip-address-useast1"
  provision_firewall_ingress   = true
}

#Kubernetes

data "google_client_config" "provider" {}

data "google_container_cluster" "cluster01" {
  name = "cluster01"
  location = "us-east1"
  project = "project01"
}

provider "kubernetes" {
  host = "https://${data.google_container_cluster.cluster01.endpoint}"
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
    host = "https://${data.google_container_cluster.cluster01.endpoint}"
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
    bucket = "tf-statefiles" #Replace with the name of the bucket created in Module 0
    prefix = "sbc-setup-useast1-state" #creates a new folder within the bucket
  }
}