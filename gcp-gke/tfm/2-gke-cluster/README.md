# Terraform GKE Cluster Module

This module supports creating:

- A Kubernetes Cluster

## Usage

We have tested this cluster with gke version 1.21.9-gke.1002 which was in Regular release channel at the time, for the updated release channels and versions please check the official [Release Notes](https://cloud.google.com/kubernetes-engine/docs/release-notes). We are only supporting  Basic usage of this module is as follows:


```hcl
module "gke" {
    source                  = "github.com/genesys/multicloud-platform.git//gcp-gke/tfm/2-gke-cluster?ref=master"
    project_id              = "<project ID> eg.gcpe0003"
    environment             = "<environment> eg.gcpe003"
    network_name            = "<network> eg.gcpe003"
    region                  = "<cluster region> eg.us-west1"
    cluster                 = "<cluster name> eg.gke1"
    gke_version             = "<version of the cluster>" #Minumum version supported: 1.21
    release_channel         = "<release channel> eg.RAPID/REGULAR/STABLE" #must be all caps
    secondary_pod_range     = "<CIDR block for pods> eg.10.198.64.0/18"
    secondary_service_range = "<CIDR block for services> 10.198.16.0/20"
    gke_num_nodes           = "2"
    windows_node_pool       = false #Optional parameter.Needs to be specified if node pool needs to be windows.By default it is false and will create a GKE cluster with linux node pool.
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
        prefix = "gke-cluster-state" #creates a new folder within the bucket
    }
}
```

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
|project\_id | The ID of the project where these resources will be created | `string` | n/a | yes |
|environment | The environment where these resources will be created, used for naming conventions | `string` | n/a | yes |
|network\_name | The name of the network being created; set to "default" if not creating VPC | `string` | n/a | yes |
|region | The region where this these resources will be created | `string` | n/a | yes |
|cluster | The name of the GKE cluster | `string` | n/a | yes |
|gke_version | The version of the GKE cluster; should be equal to or above 1.22 | `string` | n/a | yes |
|release_channel | Release channel for the selected gke cluster version | `string` | n/a | yes |
|secondary_pod_range | The reserved CIDR block for pods | `string` | n/a | yes |
|secondary_service_range | The reserved CIDR block for services | `string` | n/a | yes |
|gke_num_nodes | The number of nodes in the k8s cluster in each zone  | `string` | n/a | yes |
|windows_node_pool | Flag to provision windows node pool  | `bool` | false| no |
|bucket | Name of the bucket created in module 0 | `string` | n/a | yes |
|prefix | Name of folder to be created within bucket | `string` | n/a | yes |


Reserved IP range details:

| Pod Ranges | Description | Required IPs | Sample CIDR Block | Required |
|------|-------------|------|---------|:--------:|
| `secondary_pod_range` | Reserved IP range for pods | 16384 | 10.198.64.0/18 | yes |
| `secondary_service_range` |  Reserved IP range for services | 4096 | 10.198.16.0/20 | yes |


## Outputs

| Name | Description |
|------|-------------|
|kubernetes_cluster_name| the name of the kubernetes cluster|
|kubernetes_cluster_host| the endpoint for the k8s cluster host|


<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
