

This example file can be used as follows. Additional details and list of required inputs can be found in the [module documentation]("../../../../../tfm/7-sbc/sbc-peering/README.md)

This module needs to be executed twice. First in project1 to create a peering connection from VPC1 and VPC2 followed by execution in project2 to create a reverse peering connection from VPC2 to VPC1.

*Note: When executing this module in the second project, change the name of the peering connection and switch the primary and peer VPC/project variable values.

```hcl
module "network-peering" {
  source                   = "../../../tfm/7-sbc/sbc-peering/" #"github.com/genesys/multicloud-platform.git//gcp-gke/tfm/7-sbc/sbc-peering?ref=master"
  peering_connection_name  = <name of the peering connection> #eg. "project01-to-sbc-peer"
  primary_project          = <name of the primary project> #eg. "project01"
  primary_vpc              = <name of the primary VPC in primary_project> #eg. "network01"
  peer_project             = <name of the peer project> #eg. "sbc-project"
  peer_vpc                 = <name of the peer VPC in peer_project>" #eg. "sbc-network"
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
    bucket = "<your globally unique bucket name>" #Replace with the name of the bucket created in module 0 or a bucket in the corresponding project
    prefix = "peering-state-sbc"    #Creates a new folder
  }
}

provider "google" {
  project = "<project ID>"
}
```

