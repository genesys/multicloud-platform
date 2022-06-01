# Terraform third party Module

This module supports creating:

All third party software that we want to install on the k8s cluster:

- Kafka - v1.0
- Keda  -  v2.6.1
- Consul (GKE 1.21 - Consul 1.9.x (currently 1.9.15), GKE 1.22 - Consul 1.11.x (currently 1.11.3))

## Usage

Basic usage of this module is as follows:

```hcl
module "third-party" {
    source  = "github.com/genesys/multicloud-platform.git//gcp-gke/tfm/5-third-party?ref=master"
}

#Kubernetes
data "google_client_config" "provider" {}
data "google_container_cluster" "gke1" {
  name     = <cluster name>
  location = <cluster location>
  project  = <project name>
}

provider "kubernetes" {
  host  = "https://${data.google_container_cluster.gke1.endpoint}"
  token = data.google_client_config.provider.access_token
  cluster_ca_certificate = base64decode(
    data.google_container_cluster.gke1.master_auth[0].cluster_ca_certificate,
    #google_container_cluster.primary.master_auth.0.cluster_ca_certificate
  )
}

#Helm

variable "helm_version" {
  default = "v2.9.1"
}
provider "helm" {

  kubernetes {
    host  = "https://${data.google_container_cluster.gke1.endpoint}"
    token = data.google_client_config.provider.access_token
    cluster_ca_certificate = base64decode(
      data.google_container_cluster.gke1.master_auth[0].cluster_ca_certificate,
      #google_container_cluster.primary.master_auth.0.cluster_ca_certificate
    )
    config_path = "~/.kube/config"
  }
}

provider "google" {
  project = <project name>
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
        prefix = "third-party-state" #creates a new folder within bucket
    }
}
```

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Inputs

Below inputs are required in the data and provider blocks and not in the module block.

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| name | The name of the cluster  | `string` | n/a | yes |
| consul_helm_version | Consul version to be installed  | `string` | "v0.34.1"| no |
| consul_image | Consul image to be used in helm  | `string` | "hashicorp/consul:1.9.15"| no |
| consul_imageK8s | Consul K8Simage  to be installed  | `string` | "hashicorp/consul-k8s-control-plane:0.34.1"| no |
| tls | Enable tls in consul  | `string` | false | no |
| location | The region of the cluster  | `string` | n/a | yes |
| project | The name of the project  | `string` | n/a | yes |
| bucket | Name of the bucket created in module 0 | `string` | n/a | yes |
| prefix | Name of folder to be created within bucket | `string` | n/a | yes |



<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
