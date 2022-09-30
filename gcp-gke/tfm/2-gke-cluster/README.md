# Terraform GKE Cluster Module

This module supports creating:

- a Kubernetes cluster

## Usage

We have tested this cluster with GKE version 1.23.10-gke.1000 which was in the RAPID release channel at the time. Use the UNSPECIFIED release channel to prevent cluster auto upgrade. For the updated release channels and versions please check the official [Release Notes](https://cloud.google.com/kubernetes-engine/docs/release-notes). Basic usage of this module is as follows:


Note: set the `release_channel` variable to UNSPECIFIED to prevent cluster autoupgrade.

```hcl
module "gke" {
    source                  = "../../../tfm/2-gke-cluster/" #"github.com/genesys/multicloud-platform.git//gcp-gke/tfm/2-gke-cluster?ref=master"
    project_id              = "<project ID>" #eg. project01
    network_name            = "<network>" #eg. network01
    region                  = "<cluster region>" #eg. us-west1
    cluster                 = "<cluster name>" #eg. cluster01
    gke_version             = "<version of the cluster>" #minumum version supported: 1.22
    release_channel         = "<release channel>" #eg. RAPID/REGULAR/STABLE/UNSPECIFIED (must be all caps)
    secondary_pod_range     = "<CIDR block for pods>" #eg. 10.198.64.0/18
    secondary_service_range = "<CIDR block for services>" #eg. 10.198.16.0/20
    gke_num_nodes           = "2"
    windows_node_pool       = false #Optional parameter. Needs to be specified if node pool needs to be windows. By default it is false and will create a GKE cluster with Linux node pool.
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
        prefix = "cluster-state" #Creates a new folder within the bucket
    }
}
```

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
|project\_id | The ID of the project where these resources will be created | `string` | n/a | yes |
|network\_name | The name of the network being created; set to "default" if not creating VPC | `string` | n/a | yes |
|region | The region where this these resources will be created | `string` | n/a | yes |
|cluster | The name of the GKE cluster | `string` | n/a | yes |
|gke_version | The version of the GKE cluster; should be equal to or above 1.23 | `string` | n/a | yes |
|release_channel | Release channel for the selected gke cluster version | `string` | n/a | yes |
|secondary_pod_range | The reserved CIDR block for pods | `string` | n/a | yes |
|secondary_service_range | The reserved CIDR block for services | `string` | n/a | yes |
|gke_num_nodes | The number of nodes in the Kubernetes cluster in each zone  | `string` | n/a | yes |
|windows_node_pool | Flag to provision windows node pool  | `bool` | false| no |
|bucket | Name of the bucket created in module 0 | `string` | n/a | yes |
|prefix | Name of folder to be created within bucket | `string` | n/a | yes |


Reserved IP range details:

| Pod Ranges | Description | Required IPs | Sample CIDR Block | Required |
|------|-------------|------|---------|:--------:|
| `secondary_pod_range` | Reserved IP range for pods | 16384 | 10.198.64.0/18 | yes |
| `secondary_service_range` | Reserved IP range for services | 4096 | 10.198.16.0/20 | yes |


## Outputs

| Name | Description |
|------|-------------|
|kubernetes_cluster_name| The name of the Kubernetes cluster|
|kubernetes_cluster_host| The endpoint for the Kubernetes cluster host|


<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
