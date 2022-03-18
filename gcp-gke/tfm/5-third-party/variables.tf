
#variable chartValues    { default = "" }

variable tls {
  default = false
}

variable connectInject {
  default = true
}

variable controller {
  default = true
}

variable openshift {
  default = false
}

variable syncCatalog {
  default = true
}

variable ui {
  default = true
}

variable client {
  default = true
}

variable manageSystemACLs {
  default = true
}

variable consul_helm_version {
  type = string
  default = "v0.34.1"
}