terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 4.0"
    }
  }
  required_version = ">= 1.3.0"
}

provider "google" {
  project     = var.project-id
  region      = var.region                            # Region
  zone        = var.zone                              # zone
}

resource "google_storage_bucket" "example_bucket" {
  name          = "terroaform-app-123"                          # Unique name
  location      = "EU"                                          # Placement of bucket
  storage_class = "STANDARD"                                    # Storage class
}

resource "google_compute_instance" "default" {
    name                 ="my-updated-instance-google"                  # Name of instance
    machine_type         ="e2-micro"                            # General 

    boot_disk {
        auto_delete = true
        initialize_params {
            image   = "debian-cloud/debian-11"
            type    = "pd-standard"  
        }
        device_name = "disk-one"
        mode = "READ_WRITE"                                     # Allow read and writes to the disk
    }

    network_interface {
        network = "default"
        }
}





