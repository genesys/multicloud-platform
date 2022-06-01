
# Create an instance with OS Login configured to use as a bastion host.

resource "google_compute_instance" "bastion_host" {
  project      = var.project
  name         = var.name
  machine_type = var.machine_type
  zone         = var.zone
  description  = var.description
  #tags = [var.tag]

  boot_disk {
    initialize_params {
      image = var.image
    }
  }

  network_interface {
      network = var.network
      subnetwork = var.subnetwork

    // If var.static_ip is set use that IP, otherwise this will generate an ephemeral IP
    access_config {
        // Ephemeral public I
        //nat_ip = var.static_ip
    }
  }

  #metadata_startup_script = var.startup_script

  metadata = {
      enable-oslogin = "FALSE"

  }
}


resource "google_compute_firewall" "allow-ssh" {

    count = var.provision_ssh_firewall == true ? 1 : 0
    name = "allow-ssh"
    project = var.project
    network = var.network
    direction = "INGRESS"    
    source_ranges = [ "0.0.0.0/0"]

    allow {
      protocol = "tcp"
      ports = ["22"]
    }
}


resource "google_compute_firewall" "allow-IAP" {

    count = var.provision_iap_firewall == true ? 1 : 0
    name = "allow-ingress-from-iap"
    project = var.project
    network = var.network
    direction = "INGRESS"    
    source_ranges = [ "35.235.240.0/20"]

    allow {
      protocol = "tcp"
      ports = ["22"]
    }
}


resource "google_iap_tunnel_instance_iam_binding" "enable_iap" {
  project   = var.project
  zone      = var.zone
  instance  = var.name
  role     = "roles/iap.tunnelResourceAccessor"
  members  = var.members

  depends_on  = [google_compute_instance.bastion_host]
}

resource "google_project_iam_custom_role" "IAP_tunnel_users" {
  count       = var.create_iap_iam_role == true ? 1 : 0
  role_id     = "IAPusers"
  title       = "IAP Users"
  description = "A custom IAP access role to be used in addition to the predefined roles/iap.tunnelResourceAccessor"
  permissions = ["compute.instances.get", "compute.instances.list","compute.projects.get", "compute.instances.setMetadata", "compute.projects.setCommonInstanceMetadata", "compute.globalOperations.get"]
}

resource "google_project_iam_binding" "project" {
  count       = var.create_iap_iam_role == true ? 1 : 0
  project     = var.project
  role        = "projects/${var.project}/roles/IAPusers"
  members     = var.members
  depends_on  = [
    google_project_iam_custom_role.IAP_tunnel_users
  ]
}