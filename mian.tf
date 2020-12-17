resource "google_container_cluster" "primary" {
  name        = var.name
  project     = var.project
  description = "DevOps course GKE Cluster"
  location    = var.location

  remove_default_node_pool = true
  initial_node_count       = var.initial_node_count

  master_auth {
    client_certificate_config {
      issue_client_certificate = false
    }
  }
}

resource "google_container_node_pool" "primary-node-pool" {
  name       = "${var.name}-node-pool"
  project    = var.project
  location   = var.location
  cluster    = google_container_cluster.primary.name
  node_count = var.initial_node_count

  node_config {
    preemptible  = true
    machine_type = var.machine_type

    metadata = {
      disable-legacy-endpoints = "true"
    }

    oauth_scopes = [
      "https://www.googleapis.com/auth/cloud-platform",
      "https://www.googleapis.com/auth/logging.write",
      "https://www.googleapis.com/auth/monitoring",
    ]
  }
}

module "release-prometheus-operator" {
  source  = "OpenQAI/release-prometheus-operator/helm"
  version = "0.0.1"

  helm_chart_namespace  = "monitoring"
  skip_crds             = false
  grafana_adminPassword = "pa$$w0rd"
}
