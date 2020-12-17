terraform {
  required_version = ">= 0.12"
}

provider "google" {
  version = "3.48.0"
  project = var.project
  region  = var.location
}

provider "kubernetes" {
  load_config_file = false
  host             = google_container_cluster.primary.endpoint
  token            = data.google_client_config.default.access_token

  client_certificate     = base64decode(google_container_cluster.primary.master_auth[0].client_certificate)
  client_key             = base64decode(google_container_cluster.primary.master_auth[0].client_key)
  cluster_ca_certificate = base64decode(google_container_cluster.primary.master_auth[0].cluster_ca_certificate)
}

provider "helm" {
  kubernetes {}
}
