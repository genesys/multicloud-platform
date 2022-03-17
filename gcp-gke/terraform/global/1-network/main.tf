module "network" {
    source          = "../../../tfm/1-network/" #github.com/genesys/multicloud-platform.git//gcp-gke/tfm/1-network?ref=master
    provision_vpc   = true
    project_id      = "project01"
    network_name    = "network01"
    environment     = "enviroment01" #For naming conventions; can be the same as project name.
    region          = ["us-west1","us-east1"]
    fqdn            = "domain.example.com."

    subnets = [
        {
            subnet_name           = "enviroment01-us-west1-subnet"
            subnet_ip             = "10.198.0.0/22"
            subnet_region         = "us-west1"
        },
        {
            subnet_name           = "enviroment01-us-west1-vm-subnet"
            subnet_ip             = "10.198.8.0/22"
            subnet_region         = "us-west1"
        },
        {
            subnet_name           = "enviroment01-us-west1-privateep-subnet"
            subnet_ip             = "10.198.4.0/22"
            subnet_region         = "us-west1"
        },
         {
            subnet_name           = "enviroment01-us-east1-subnet"
            subnet_ip             = "10.200.0.0/22"
            subnet_region         = "us-east1"
        },
        {
            subnet_name           = "enviroment01-us-east1-vm-subnet"
            subnet_ip             = "10.200.8.0/22"
            subnet_region         = "us-east1"
        },
        {
            subnet_name           = "enviroment01-us-east1-privateep-subnet"
            subnet_ip             = "10.200.4.0/22"
            subnet_region         = "us-east1"
        }
    ]
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
    prefix = "network-state" #creates a new folder
  }
}