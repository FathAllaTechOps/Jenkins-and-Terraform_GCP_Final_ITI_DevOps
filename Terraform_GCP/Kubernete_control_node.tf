resource "google_container_cluster" "primary" {
  name                     = "primary"
  location                 = "us-central1-a"
  remove_default_node_pool = true
  initial_node_count       = 1
  network                  = google_compute_network.terraform_vpc.id
  subnetwork               = google_compute_subnetwork.restricted_subnet.id
  networking_mode          = "VPC_NATIVE"
  
  # node_locations = [ "us-central1-b" ]
  addons_config {
    http_load_balancing {
      disabled = true
    }
    horizontal_pod_autoscaling {
      disabled = false
    }
    
  }

  release_channel {
    channel = "REGULAR"
  }

  workload_identity_config {
    workload_pool = "first-project-2030.svc.id.goog"
  }
  ip_allocation_policy {
    cluster_secondary_range_name  = "k8s-pod-range-1"
    services_secondary_range_name = "k8s-service-range-1"
  }

  private_cluster_config {
    enable_private_nodes    = true
    enable_private_endpoint = true
    master_ipv4_cidr_block  = "172.16.0.0/28"
    
  }
  master_authorized_networks_config {
  cidr_blocks {
    cidr_block = google_compute_subnetwork.management_subnet.ip_cidr_range
    display_name = "my-cidr"
  }
}
}