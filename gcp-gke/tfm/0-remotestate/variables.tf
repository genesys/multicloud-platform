variable "name" {
  type = string
  description = "Name of the bucket"
}

# https://cloud.google.com/storage/docs/locations#location-r
variable "location" {
  type = string
  description = "location of the bucket"
  #default     = "US"
}


