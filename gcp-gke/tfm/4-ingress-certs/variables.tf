variable "project_id" {
  type = string
  description = "The ID of the project where  these resources will get created"
}

variable "environment" {
  type = string
  description = "The environment where these resources will get created"
}


variable "domain_name_nginx" {
  type        = string
  description = "Root domain name for the stack"
}

variable "cert_manager_version" {
  type        = string
  description = "cert manager version"
  default    = "1.5.4"
}

variable "email" {
  type        = string
  description = "email address to be used for certificate issuers"
}