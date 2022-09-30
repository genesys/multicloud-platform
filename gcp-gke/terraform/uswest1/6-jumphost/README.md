This example file can be used as follows. Additional details and list of required inputs can be found in the [module documentation](../../../tfm/6-jumphost/README.md)

```hcl
module "jumphost_instance" {
    source          = "../../../tfm/6-jumphost/" #"github.com/genesys/multicloud-platform.git//gcp-gke/tfm/6-jumphost?ref=master"
    project         = "<project ID>" #eg. project01
    description     = "<optional description>"
    name            = "<your machine name>" #eg. cluster02-jumphost
    machine_type    = "<machine type>" #eg. e2-micro
    zone            = "<zone>" #eg. us-central1-a   
    image           = "<OS image name>" #eg. ubuntu-os-cloud/ubuntu-1804-lts
    network         = "<VPC network name>" #eg. network01
    subnetwork      = "<subnet of network>"
    provision_ssh_firewall = true
    provision_iap_firewall = true
    create_iap_iam_role    = true
    members         = ["user:jane@example.com","user:john@example.com"]
    
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
    bucket = "<your globally unique bucket name>"  #Replace with the name of the bucket created in module 0
    prefix = "jumphost-state" #Creates a new folder within bucket
  }
}
```
