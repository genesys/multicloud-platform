
resource "kubernetes_storage_class" "class" {
  metadata {
    name = "csi-standard-rwx"
  }
  storage_provisioner = "filestore.csi.storage.gke.io"
  reclaim_policy      = "Delete"
  allow_volume_expansion = "true"
  volume_binding_mode = "WaitForFirstConsumer"
  parameters = {
    tier = "standard"
    reserved-ipv4-cidr = var.ipv4
    network = var.network_name
  }

  mount_options = ["file_mode=0777", "dir_mode=0777", "mfsymlinks", "uid=500", "gid=500", "cache=strict"]
}









