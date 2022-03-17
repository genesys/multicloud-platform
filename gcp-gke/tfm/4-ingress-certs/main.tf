resource "kubernetes_namespace" "ingress-nginx" {
  metadata {
    name = "ingress-nginx" 
  }
}
resource "helm_release" "ingress-nginx" {
  name        = "nginx-ingress"
  repository   = "https://kubernetes.github.io/ingress-nginx"
  chart       = "ingress-nginx"
  namespace   = "ingress-nginx"
  version     = "4.0.6"
}

#Nginx wildcard configurations
data "kubernetes_service" "ingress-nginx_controller" {
  depends_on = [helm_release.ingress-nginx]
  metadata {
    name        = "nginx-ingress-ingress-nginx-controller"
    namespace = helm_release.ingress-nginx.metadata[0].namespace
  }
}

# DNS zone managed by Google Cloud DNS.
data "google_dns_managed_zone" "default" {
  name = "base-dns-global-${var.environment}"
  project     = var.project_id
}


# Root A record.
resource "google_dns_record_set" "a_root" {
  project     = var.project_id
  
  name         = "${var.domain_name_nginx}."
  managed_zone = data.google_dns_managed_zone.default.name
  type         = "A"
  ttl          = 300

  rrdatas = [data.kubernetes_service.ingress-nginx_controller.status[0].load_balancer[0].ingress[0].ip]
}

# Wildcard A record.
resource "google_dns_record_set" "a_wildcard" {
  project     = var.project_id
  name         = "*.${var.domain_name_nginx}."
  managed_zone = data.google_dns_managed_zone.default.name
  type         = "A"
  ttl          = 300

  rrdatas = [data.kubernetes_service.ingress-nginx_controller.status[0].load_balancer[0].ingress[0].ip]
}




resource "kubernetes_namespace" "cert-manager" {
  metadata {
    name = "cert-manager" 
  }
}

resource "helm_release" "cert_manager" {
  name             = "cert-manager"
  repository       = "https://charts.jetstack.io"
  chart            = "cert-manager"
  namespace        = "cert-manager"
  version          = var.cert_manager_version

  set {
    name  = "installCRDs"
    value = "true"
  }

  values = [
    templatefile("${path.module}/charts/cert-manager-values.yaml.tpl", {
      replica_count = 1
    })
  ]

  depends_on = [ 
    kubernetes_namespace.cert-manager
   ]
}


resource helm_release clusterIssuers {
  depends_on          = [helm_release.cert_manager]
  name                = "cluster-issuers"
  namespace           = "cert-manager"
  chart               = "${path.module}/charts/cluster-issuers"
  version             = "0.15.0"
  set {
    name  = "email"
    value = var.email
  }
}



