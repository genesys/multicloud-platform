

This example file can be used as follows. Additional details and list of required inputs can be found in the [module documentation](../../../tfm/1-network/README.md)


```hcl
module "network" {
    source          = "../../../tfm/1-network/" #github.com/genesys/multicloud-platform.git//gcp-gke/tfm/1-network?ref=master
    provision_vpc   = true/false
    project_id      = "<PROJECT ID>" eg.gcpe0002
    network_name    = "<Same as environment>"
    description     = "<Optional Description>"
    environment     = "<Environment Name>" eg.gcpe002
    region          = \[<list of regions>\] eg. \["us-west1","us-east1"\]
    fqdn            = "<fqdn for your project>" eg. domain.example.com.

    subnets = \[
        {
            subnet_name           = "subnet-01"
            subnet_ip             = "10.10.10.0/24"
            subnet_region         = "us-west1"
        },
        {
            subnet_name           = "subnet-01"
            subnet_ip             = "10.10.10.0/24"
            subnet_region         = "us-west1"
            description           = "This subnet has a description"
        }
    \]
}

provider "google" {
  project = <PROJECT ID>
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
    bucket = "<Bucket Name>" #Replace with the name of the bucket created in Module 0
    prefix = "network-state" #creates a new folder within the bucket
  }
}
```
Note: Check the [example file](./main.tf) for sample subnets name and IPs. The subnet names are required to be in the below format.

| Required Subnet Name | Description | Required IPs | Sample CIDR Block | Required |
|------|-------------|------|---------|:--------:|
| `<environment>-<subnet-region>-subnet` | Subnet for Kubernetes cluster | 1024 | 10.198.0.0/22 | yes |
| `<environment>-<subnet-region>-vm-subnet` | Subnet for Virtual Machines | 1024 | 10.198.8.0/22 | yes |
| `<environment>-<subnet-region>-privateep-subnet` | Subnet for Private Endpoints | 1024 | 10.198.4.0/22 | yes |

