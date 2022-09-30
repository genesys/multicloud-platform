

This example file can be used as follows. Additional details and list of required inputs can be found in the [module documentation](../../../tfm/1-network/README.md)


```hcl
module "network" {
    source          = "../../../tfm/1-network/" #"github.com/genesys/multicloud-platform.git//gcp-gke/tfm/1-network?ref=master"
    provision_vpc   = true/false
    project_id      = "<project ID>" #eg. project01
    network_name    = "<name of your VPC network>" #eg. network01
    description     = "<optional description>"
    region          = [<list of regions>] #eg. ["us-west1","us-east1"]
    fqdn            = "<FQDN for your project>" #eg. domain.example.com. (FQDN should have a "." at the end)

    subnets = [
        {
            subnet_name           = "<VPC network name>-<region>-subnet"
            subnet_ip             = "10.198.0.0/22"
            subnet_region         = "us-west1"
        },
        {
            subnet_name           = "<VPC network name>-<region>-vm-subnet"
            subnet_ip             = "10.198.8.0/22"
            subnet_region         = "us-west1"
        },
        {
            subnet_name           = "<VPC network name>-<region>-privateep-subnet"
            subnet_ip             = "10.198.4.0/22"
            subnet_region         = "us-west1"
        }
    ]
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
    bucket = "<your globally unique bucket name>" #replace with the name of the bucket created in module 0
    prefix = "network-state" #creates a new folder within the bucket
  }
}
```
Note: Check the [example file](./main.tf) for sample subnets name and IPs. The subnet names are required to be in the below format.

| Required Subnet Name | Description | Required IPs | Sample CIDR Block | Required |
|------|-------------|------|---------|:--------:|
| `<network_name>-<subnet-region>-subnet` | Subnet for Kubernetes cluster | 1024 | 10.198.0.0/22 | yes |
| `<network_name>-<subnet-region>-vm-subnet` | Subnet for virtual machines | 1024 | 10.198.8.0/22 | yes |
| `<network_name>-<subnet-region>-privateep-subnet` | Subnet for private endpoints | 1024 | 10.198.4.0/22 | yes |

