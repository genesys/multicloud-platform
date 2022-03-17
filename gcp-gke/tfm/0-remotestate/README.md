# Terraform Step Zero Module

This module handles the inital setup for terraform backend and enabling GKE API's

## Usage

This module needs to be executed twice. First time for creating the initial bucket. Second time for moving the state file to the newly created bucket.
Basic usage of this module is as follows:

1. Execute with the terraform block commented out to create a bucket.
2. Uncomment the terraform block and move the statefile to the bucket using terraform prompts.

```hcl
module "remote_state" {
  source      = "github.com/genesys/multicloud-platform.git//gcp-gke/tfm/0-remotestate?ref=master"
  name        = "<your_globally_unique_bucket_name>" (Bucket naming guidlines: https://cloud.google.com/storage/docs/naming-buckets)
  location    = "<Bucket Location>" (Regions list: https://cloud.google.com/storage/docs/locations#location-r)
}

#Comment out the below block
terraform {
  backend "gcs" {
    bucket = "<your_globally_unique_bucket_name>" #Replace with the name of the bucket created above
    prefix = "remotestate-state" #creates a new folder within bucket
  }
}
#Commenting ends

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
```

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| name | Globally unique name of the bucket | `string` | n/a | yes |
| location | Region where the bucket needs to be created | `string` | n/a | yes |
| project | Name of the project in provider block where the resources will be created | `string` | n/a | yes |
| bucket | Same as globally unique bucket name | `string` | n/a | yes |
| prefix | Name of folder to be created within bucket | `string` | n/a | yes |



