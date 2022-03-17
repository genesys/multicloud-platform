
#Kafka
resource "kubernetes_namespace" "kafka" {
  metadata {
    name = "kafka"
  }
}

data "local_file" "helmvalues-kafka" {
  filename = "${path.module}/kafka-values.yaml"
}

resource "helm_release" "kafka-install" {
  name       = "kafka-helm"
  repository = "https://confluentinc.github.io/cp-helm-charts/"
  chart = "cp-helm-charts"
  namespace  = "kafka"
  version     = "0.6.1"
  values        = [
    data.local_file.helmvalues-kafka.content
  ]
}


#Keda 
resource "kubernetes_namespace" "keda" {
  metadata {
    name = "keda"
  }
}

resource "helm_release" "keda" {
  name        = "keda"
  repository   = "https://kedacore.github.io/charts"
  chart       = "keda"
  namespace   = "keda"
  version     = "2.0.1"
}



# consul namespace creation
resource "kubernetes_namespace" consul {
  metadata {
    name = "consul"
  }
}

# Helm Value for Consul
data "local_file" "helmvalues-consul" {
  filename = "${path.module}/consul-values.yaml"
}

resource "helm_release" "consul" {
  name          = "consul"
  repository    = "https://helm.releases.hashicorp.com"
  chart         = "consul"
  namespace     = "consul"
  timeout       = 1000
  atomic        = true
  max_history   = 10
  wait          = true
  recreate_pods = true
  version  = "v0.37.0"
  values        = [
    data.local_file.helmvalues-consul.content
  ]

  set {
    name  = "global.tls.enabled"
    value = var.tls
  }

  set {
    name  = "global.acls.manageSystemACLs"
    value = true
  }

  set {
    name  = "global.gossipEncryption.autoGenerate"
    value = true
  }
  
  set {
    name  = "connectInject.enabled"
    value = var.connectInject
  }
  set {
    name  = "controller.enabled"
    value = var.controller
  }
  set {
    name  = "openshift.enabled"
    value = var.controller
  }
  set {
    name  = "syncCatalog.enabled"
    value = var.controller
  }
  set {
    name  = "ui.enabled"
    value = var.controller
  }
  set {
    name  = "client.enabled"
    value = var.controller
  }
  depends_on = [
    kubernetes_namespace.consul,
  ]
}
