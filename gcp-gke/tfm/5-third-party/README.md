# Terraform third party Module

This module supports creating:

All third party software that we want to install on the k8s cluster:
- Kafka - v2.7.0
- Keda  -  v2.6.1
- Consul - v1.9.15

## Usage

Basic usage of this module is as follows:

```hcl
module "third-party" {
    source  = "../../../tfm/5-third-party/" #"github.com/genesys/multicloud-platform.git//gcp-gke/tfm/5-third-party?ref=master"
    consul_helm_version = "0.41.0"
    consul_image        = "hashicorp/consul:1.11.3"
    consul_imageK8S     = "hashicorp/consul-k8s-control-plane:0.41.0"
    consul_datacenter   = "useast1"
}

#Kubernetes
data "google_client_config" "provider" {}
data "google_container_cluster" "<cluster name>" {
  name     = <cluster name>
  location = <cluster location>
  project  = <project ID>
}

provider "kubernetes" {
  host  = "https://${data.google_container_cluster.<cluster name>.endpoint}"
  token = data.google_client_config.provider.access_token
  cluster_ca_certificate = base64decode(
    data.google_container_cluster.<cluster name>.master_auth[0].cluster_ca_certificate,
    #google_container_cluster.primary.master_auth.0.cluster_ca_certificate
  )
}

#Helm

variable "helm_version" {
  default = "v2.9.1"
}
provider "helm" {

  kubernetes {
    host  = "https://${data.google_container_cluster.<cluster name>.endpoint}"
    token = data.google_client_config.provider.access_token
    cluster_ca_certificate = base64decode(
      data.google_container_cluster.<cluster name>.master_auth[0].cluster_ca_certificate,
      #google_container_cluster.primary.master_auth.0.cluster_ca_certificate
    )
    config_path = "~/.kube/config"
  }
}

provider "google" {
  project = <project ID>
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
        bucket = "<your globally unique bucket name>" #Replace with the name of the bucket created in module 0
        prefix = "third-party-state" #Creates a new folder within bucket
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
| consul_imageK8s | Consul Kubernetes image  to be installed  | `string` | "hashicorp/consul-k8s-control-plane:0.34.1"| no |
| consul_datacenter | Consul datacenter name (equivalent to cluster region)  | `string` | n/a | yes |
| tls | Enable TLS in Consul  | `string` | true | no |
| location | The region of the cluster  | `string` | n/a | yes |
| project | The name of the project  | `string` | n/a | yes |
| bucket | Name of the bucket created in module 0 | `string` | n/a | yes |
| prefix | Name of folder to be created within bucket | `string` | n/a | yes |



## Consul Compatability Matrix and Variable Values
| GKE Verson | Consul Version |
|------------|----------------|
| v1.21 | v1.9.15 |
| >= v1.22 | v1.11.3 |

| Consul Variables | v1.9.15 Values | v1.11.3 Values |
|------------------|----------------|----------------|
| consul_helm_version | "v0.34.1" | "0.41.0" |
| consul_image | "hashicorp/consul:1.9.15" | "hashicorp/consul:1.11.3" |
| consul_imageK8s | "hashicorp/consul-k8s-control-plane:0.34.1" | "hashicorp/consul-k8s-control-plane:0.41.0" |
| tls | true | true |







<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
