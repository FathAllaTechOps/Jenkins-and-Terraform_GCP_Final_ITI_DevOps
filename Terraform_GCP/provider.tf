provider "google" {
  project     = "first-project-2030"
  region      = "us-central1"
  # credentials = file("first-project-2030-a3ccca088670.json")
}

# terraform {
#   backend "gcs" {
#     bucket = "tf-state-2030"
#     prefix = "terraform/state"
#   }
# }