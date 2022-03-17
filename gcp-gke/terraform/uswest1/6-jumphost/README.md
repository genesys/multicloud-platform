This example file can be used as follows. Additional details and list of required inputs can be found in the [module documentation](../../../tfm/6-jumphost/README.md)

```hcl
module "jumphost_instance" {
    source          = "../../../tfm/6-jumphost/" #github.com/genesys/multicloud-platform.git//gcp-gke/tfm/6-jumphost?ref=master
    project         = "<PROJECT ID>" eg.gcpe0003
    description     = "<Optional Description>"
    name            = "<your_machine_name>"
    machine_type    = "<Machine_tyep>" eg.e2-micro
    zone            = "<zone>" eg.us-central1-a   
    image           = "<OS_image_name>" eg.ubuntu-os-cloud/ubuntu-1804-lts
    network         = "<VPC Network ID>"
    subnetwork      = "<Subnet of Network>"
    provision_ssh_firewall = true
    provision_iap_firewall = true
    create_iap_iam_role    = true
    members         = ["user:jane@example.com","user:john@example.com"]
    
}

provider "google" {
  project = "<PROJECT ID>"
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
    bucket = <Bucket Name>  #Replace with the name of the bucket created in Module 0
    prefix = "jumphost-state" #creates a new folder within bucket
  }
}
```
