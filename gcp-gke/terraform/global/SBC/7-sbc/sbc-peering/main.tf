module "network-peering" {
  source                = "../../../../../tfm/7-sbc/sbc-peering/" #"github.com/genesys/multicloud-platform.git//gcp-gke/tfm/7-sbc/sbc-peering?ref=master"
  peering_connection_name  = "gcpe002-to-sbc-peer"
  primary_project       = "project01"
  primary_vpc           = "network01"
  peer_project          = "sbc-project"
  peer_vpc              = "sbc-network"
  provision_firewall    = true
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
    bucket = "tf-statefiles" #Replace with the name of the bucket created in Module 0 or a bucket in the corresponding project
    prefix = "peering-state-network01"    #creates a new folder
  }
}

provider "google" {
  project = "project01"
}
