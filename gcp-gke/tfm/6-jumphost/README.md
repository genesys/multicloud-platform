
# Terraform Jumphost Module

This module supports creating:

- A Jumphost Instance
- Firewall Rules required for Jumphost and IAP Tunneling
- Creating a custom IAM role for IAP access
- Assigning the custom role to members

## Usage


Basic usage of this module is as follows. Firewall rules and custom IAM role need to be provisioned only once per VPC. If they have been enabled previously then set the values to false.


```hcl
module "jumphost_instance" {
    source          = "../../../tfm/6-jumphost/" #"github.com/genesys/multicloud-platform.git//gcp-gke/tfm/6-jumphost?ref=master"
    project         = "<project ID>" #eg. project01
    description     = "<optional description>"
    name            = "<your machine name>" #eg. cluster01-jumphost
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
    bucket = "<your globally unique bucket name>"  #Replace with the name of the bucket created in Module 0
    prefix = "jumphost-state" #Creates a new folder within bucket
  }
}
```


<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| project | The ID of the project where these resources will be created | `string` | n/a | yes |
| description| Optional description | `string` | n/a | no |
| name| Instance name | `string` | n/a | yes |
| machine_type| Compute capacity of instance | `string` | n/a | yes |
| zone   | The zone that the machine should be created in | `string` | n/a | yes |
| image| OS image like Ubuntu/RHEL/Windows | `string` | n/a | yes |
| network | The name of the network where instance is to be deployed; set to "default" if not specific VPC | `string` | n/a | yes |
| subnetwork | The name of the subnetwork where Instance to deployed in network; set to "default" if not specific subnetwork | `string` | n/a | yes |
| provision_ssh_firewall  | Flag variable for creating an SSH allowing firewall rule | `bool` | true | no |
| provision_iap_firewall  | Flag variable for creating an IAP allowing firewall rule | `bool` | true | no |
| create_iap_iam_role  | Flag variable for creating an custom IAM role for IAP access| `bool` | true | no |
| members  | List of members who need IAP access | `list` | n/a | no |
| bucket | Name of the bucket created in module 0 | `string` | n/a | yes |
| prefix | Name of folder to be created within bucket | `string` | n/a | yes |


## How to login into Jumphost
```
gcloud compute ssh <username>@<Machine-name>

```