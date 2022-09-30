

This example file can be used as follows. Additional details and list of required inputs can be found in the [module documentation](../../../tfm/2-gke-cluster/README.md)

We have tested this cluster with GKE version 1.23.10-gke.1000 which was in the RAPID release channel at the time, for the updated release channels and versions please check the official [Release Notes](https://cloud.google.com/kubernetes-engine/docs/release-notes). Basic usage of this module is as follows:


```hcl
module "gke" {
    source                  = "../../../tfm/2-gke-cluster/" #"github.com/genesys/multicloud-platform.git//gcp-gke/tfm/2-gke-cluster?ref=master"
    project_id              = "<project ID>" #eg. project01
    network_name            = "<network>" #eg. network01
    region                  = "<cluster region>" #eg. us-west1
    cluster                 = "<cluster name>" #eg. cluster02
    gke_version             = "<version of the cluster>" #minumum version supported: 1.23
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

