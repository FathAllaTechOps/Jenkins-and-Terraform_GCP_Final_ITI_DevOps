###################################################
################# VPC and Subnet ##################
###################################################
resource "google_compute_network" "terraform_vpc" {
  name                            = "terraform-vpc"
  project                         = "first-project-2030"
  routing_mode                    = "REGIONAL"
  auto_create_subnetworks         = false
  delete_default_routes_on_create = false
}


resource "google_compute_subnetwork" "management_subnet" {
  name                     = "management-subnet"
  ip_cidr_range            = "10.1.1.0/24"
  region                   = "us-central1"
  network                  = google_compute_network.terraform_vpc.id
  private_ip_google_access = true

}

resource "google_compute_subnetwork" "restricted_subnet" {
  name                     = "restricted-subnet"
  ip_cidr_range            = "10.1.2.0/24"
  region                   = "us-central1"
  network                  = google_compute_network.terraform_vpc.id
  private_ip_google_access = true

  secondary_ip_range {
    range_name    = "k8s-pod-range-1"
    ip_cidr_range = "10.1.12.0/24"
  }
  secondary_ip_range {
    range_name    = "k8s-service-range-1"
    ip_cidr_range = "20.1.22.0/24"
  }
}

###################################################
################# Router and NAT  #################
###################################################

resource "google_compute_router" "Router_gke" {
  name    = "router"
  region  = "us-central1"
  network = google_compute_network.terraform_vpc.id
}

resource "google_compute_router_nat" "NAT" {
  name   = "nat"
  router = google_compute_router.Router_gke.name
  region = "us-central1"

  source_subnetwork_ip_ranges_to_nat = "ALL_SUBNETWORKS_ALL_IP_RANGES"
  nat_ip_allocate_option             = "AUTO_ONLY"

  


}

###################################################
################### Firewalls #####################
###################################################

resource "google_compute_firewall" "terraform_firewall" {
  name      = "terraform-firewall"
  network   = google_compute_network.terraform_vpc.id
  direction = "INGRESS"

  allow {
    protocol = "tcp"
    ports    = ["22","80"]
  }

  source_ranges = ["0.0.0.0/0"]
}
