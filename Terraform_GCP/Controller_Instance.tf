data "google_compute_image" "my_image" {
  name    = "ubuntu-2004-focal-v20221018"
  project = "ubuntu-os-cloud"
}

resource "google_compute_instance" "gke_controller" {
  name         = "gke-control"
  machine_type = "e2-small"
  zone         = "us-central1-a"

  boot_disk {
    initialize_params {
      image = data.google_compute_image.my_image.self_link
    }
  }

  network_interface {
    network    = google_compute_network.terraform_vpc.name
    subnetwork = google_compute_subnetwork.management_subnet.id
  }
  metadata = {
    startup-script-url = "gs://my-first-bucket-2030/script.sh"
  }
}



