module "gke" {
    source                  = "../../../tfm/2-gke-cluster/" #github.com/genesys/multicloud-platform.git//gcp-gke/tfm/2-gke-cluster?ref=master
    project_id              = "project01"
    environment             = "environment01" #can be same as project name
    network_name            = "network01"
    region                  = "us-east1"
    cluster                 = "cluster01"
    gke_version             = "1.22.10-gke.600" #Minumum version supported: 1.21.*
    release_channel         = "UNSPECIFIED"
    secondary_pod_range     = "10.200.64.0/18"
    secondary_service_range = "10.200.16.0/20"
    gke_num_nodes           = "2"
    windows_node_pool       = false
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
        bucket = "tf-statefiles" #Replace with the name of the bucket created above
        prefix = "gke-cluster-cluster01-useast1-state" #creates a new folder
    }
}