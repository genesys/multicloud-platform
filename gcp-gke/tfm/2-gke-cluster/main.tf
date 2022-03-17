data "google_compute_network" "vpc1" {
  name     = var.environment
  project  = var.project_id
}

# GKE cluster
resource "google_container_cluster" "primary" {
  provider                    = google-beta
  project                     = var.project_id 
  name                        = var.cluster
  location                    = var.region 
  network                     = data.google_compute_network.vpc1.name
  subnetwork                  = "${var.environment}-${var.region}-subnet"
  remove_default_node_pool    = true
  initial_node_count          = 1
  default_max_pods_per_node   = 110
  enable_shielded_nodes       = true
  min_master_version          = var.gke_version #"1.21.3-gke.2003"

  ip_allocation_policy {
    cluster_ipv4_cidr_block   = var.secondary_pod_range
    services_ipv4_cidr_block  = var.secondary_service_range
  }
  networking_mode             = "VPC_NATIVE"

  #cluster_autoscaling {
    #enabled             = true
    #autoscaling_profile = "OPTIMIZE_UTILIZATION"
  #}

  release_channel {
    channel                   =  var.release_channel
  }


  addons_config {
    dns_cache_config {
      enabled = true
    }

    gce_persistent_disk_csi_driver_config {
      enabled = true
    }
  }
}

# Separately Managed Node Pool
resource "google_container_node_pool" "primary_nodes" {
  count = var.windows_node_pool? 0 : 1
  name       = "${google_container_cluster.primary.name}-node-pool"
  location   = var.region
  cluster    = google_container_cluster.primary.name
  node_count = var.gke_num_nodes
  project    = var.project_id

  node_config {
    oauth_scopes = [
      "https://www.googleapis.com/auth/logging.write",
      "https://www.googleapis.com/auth/monitoring",
    ]

    labels  = {
        env = var.project_id
    }

    # preemptible  = true
    machine_type = "e2-standard-16"
    tags         = ["gke-node", "${var.project_id}-gke"]
    metadata = {
      disable-legacy-endpoints = "true"
    }
    disk_size_gb  = 100
    disk_type     = "pd-standard" 
  }
}

#To run Windows Server containers, your cluster must have at least one Windows and one Linux node pool. 
#You cannot create a cluster using only a Windows Server node pool. 
#The Linux node pool is required to run critical cluster add- ons.
resource "google_container_node_pool" "linux_pool_for_windows" {
  count = var.windows_node_pool? 1 : 0
  name       = "${google_container_cluster.primary.name}-linux-node-pool-for-windows"
  project    = var.project_id
  cluster    = google_container_cluster.primary.name
  location   = var.region
  node_count = 1 #Setting it to 1 as we only need it to bring the windows node pool up

  node_config {
    image_type = "COS_CONTAINERD"
  }
}

# Node pool of Windows Server machines.
resource "google_container_node_pool" "windows_pool" {
  count = var.windows_node_pool ? 1 : 0
  name       = "${google_container_cluster.primary.name}-windows-node-pool"
  project    = var.project_id
  cluster    = google_container_cluster.primary.name
  location   = var.region
  node_count = var.gke_num_nodes

  node_config {
    image_type   = "WINDOWS_LTSC_CONTAINERD"
    machine_type = "n1-standard-2"
  }

  # The Linux node pool must be created before the Windows Server node pool.
  depends_on = [google_container_node_pool.linux_pool_for_windows]
}
