resource "google_compute_address" "lb-ip" {
  name          = var.ip_name
  address_type = "INTERNAL"
  subnetwork   = var.subnetwork
  region       = var.region


}

resource "google_compute_firewall" "firewall-ingress" {
  count         = var.provision_firewall_ingress == true ? 1 : 0
  name          = "firewall-rule-ingress"
  network       = var.network_name
  # source_ranges = var.ip_source_ranges

  allow {
    protocol = "icmp"
  }

  allow {
    protocol = "tcp"
    ports = var.tcp_ingress_ports
  }

  allow {
    protocol = "udp"
    ports = var.udp_ingress_ports
  }
}

resource "kubernetes_service" "kubeDNSLB" {
  metadata {
    name      = "kube-dns-lb"
    namespace = "kube-system"
    annotations = {
      "networking.gke.io/load-balancer-type" : "Internal"
      "networking.gke.io/internal-load-balancer-allow-global-access" : "true"
    }
  }
  spec {
    type             = "LoadBalancer"
    session_affinity = "None"
    load_balancer_ip = google_compute_address.lb-ip.address
    port {
      name        = "dns"
      port        = "53"
      protocol    = "UDP"
      target_port = "dns"
    }
    selector = {
      k8s-app = "kube-dns"
    }
  }
}
