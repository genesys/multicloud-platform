This example file can be used as follows. Additional details and list of required inputs can be found in the [module documentation](../../../tfm/0-remotestate/README.md)

*Note: Make sure to [authenticate gcloud](https://github.com/genesys/multicloud-platform/tree/master/gcp-gke#authenticate-gcloud) before execution.

1. Execute with the terraform block commented out to create a bucket.
2. Uncomment the terraform block and move the state file to the bucket by executing code again and following terraform prompts.

```hcl
module "remote_state" {
  source      = "../../../tfm/0-remotestate/" #"github.com/genesys/multicloud-platform.git//gcp-gke/tfm/0-remotestate?ref=master"
  name        = "<your globally unique bucket name>" #(Refer to: https://cloud.google.com/storage/docs/naming-buckets)
  location    = "<bucket location>" #(Refer to: https://cloud.google.com/storage/docs/locations#location-r)
}

#Comment out the below block
terraform {
  backend "gcs" {
    bucket = "<your globally unique bucket name>" #Replace with the name of the bucket created above
    prefix = "base-state" #Creates a new folder within bucket
  }
}
#Commenting ends

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
```

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| name | Name of the bucket | `string` | n/a | yes |
| location | Region where the bucket needs to be created | `string` | n/a | yes |
| project ID | Name of the project in provider block where the resources will be created | `string` | n/a | yes |


