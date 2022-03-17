# Terraform Network Module

This module supports creating:

- A VPC Network
- A base DNS Zone
- Subnets
- Router
- NAT Gateway


## Usage

Basic usage of this module is as follows:

```hcl
module "network" {

    source          = "github.com/genesys/multicloud-platform.git//gcp-gke/tfm/1-network?ref=master"
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
    bucket = "<your_globally_unique_bucket_name>" #Replace with the name of the bucket created in Module 0
    prefix = "network-state" #creates a new folder within the bucket
  }
}
```
Note: Check the [example file](../../terraform/global/1-network/main.tf) for sample subnets name and IPs. The subnet names are required to be in the below format.

| Required Subnet Name | Description | Required IPs | Sample CIDR Block | Required |
|------|-------------|------|---------|:--------:|
| `<environment>-<subnet-region>-subnet` | Subnet for Kubernetes cluster | 1024 | 10.198.0.0/22 | yes |
| `<environment>-<subnet-region>-vm-subnet` | Subnet for Virtual Machines | 1024 | 10.198.8.0/22 | yes |
| `<environment>-<subnet-region>-privateep-subnet` | Subnet for Private Endpoints | 1024 | 10.198.4.0/22 | yes |


<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| provision\_vpc | Flag to create VPC network | `bool` | true | yes |
| project\_id or project | The ID of the project where these resources will be created | `string` | n/a | yes |
| network\_name | The name of the network being created; set to "defaul" if not creating VPC | `string` | n/a | yes |
| description| Optional description | `string` | n/a | no |
| environment | The environment where these resources will be created | `string` | n/a | yes |
| region | The region where this these resources will be created | `string` | n/a | yes |
| fqdn | FQDN to be used by DNS | `string` | n/a | yes |
| subnet | The subnets name, CIDR and regions | `map` | n/a | yes |
| bucket | Name of the bucket created in module 0 | `string` | n/a | yes |
| prefix | Name of folder to be created within bucket | `string` | n/a | yes |



## Outputs

| Name | Description |
|------|-------------|
| network | The VPC resource being created |
| network\_id | The ID of the VPC being created |
| network\_name | The name of the VPC being created |
| network\_self\_link | The URI of the VPC being created |
| domain | The DNS zone domain. |
| name | The DNS zone name. |
| name\_servers | The DNS zone name servers. |
| type | The DNS zone type. |
| router | The created router |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
