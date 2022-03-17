module "jumphost_instance" {
    source          = "../../../tfm/6-jumphost/" #github.com/genesys/multicloud-platform.git//gcp-gke/tfm/6-jumphost?ref=master
    project         = "project01"
    name            = "cluster02-jumphost"
    machine_type    = "e2-micro"
    zone            = "us-west1-a" 
    image           = "ubuntu-os-cloud/ubuntu-1804-lts"    
    network         = "network01"
    subnetwork      = "enviroment01-us-east1-vm-subnet"
    provision_ssh_firewall = false
    provision_iap_firewall = false
    
    
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
    bucket = "tf-statefiles" #Replace with the name of the bucket created above
    prefix = "jumphost-uswest1-state" #creates a new folder
  }
}