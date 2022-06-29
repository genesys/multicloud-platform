module "gke" {
    source                  = "../../../tfm/2-gke-cluster/" #github.com/genesys/multicloud-platform.git//gcp-gke/tfm/2-gke-cluster?ref=master
    project_id              = "project01"
    environment             = "environment01"
    network_name            = "network01"
    region                  = "us-west1"
    cluster                 = "cluster02"
    gke_version             = "1.22.10-gke.600"  #Minumum version supported: 1.21.*
    release_channel         = "UNSPECIFIED"
    secondary_pod_range     = "10.198.64.0/18"
    secondary_service_range = "10.198.16.0/20"
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
        bucket = "tf-statefiles" 
        prefix = "gke-cluster-cluster02-uswest1-state" #creates a new folder
    }
}