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


# Workload Identity Pool configuration
resource "google_iam_workload_identity_pool" "github_pool" {
  workload_identity_pool_id = "github-actions-terraform-pool"
  project                   = var.project-id
  display_name             = "GitHub Actions Pool"
}

# Workload Identity Pool Provider configuration
resource "google_iam_workload_identity_pool_provider" "github_provider" {
  workload_identity_pool_id          = google_iam_workload_identity_pool.github_pool.workload_identity_pool_id
  workload_identity_pool_provider_id = "github-actions-provider-01"
  project                           = var.project-id
  
  attribute_mapping = {
    "google.subject"             = "assertion.sub"
    "attribute.actor"            = "assertion.actor"
    "attribute.repository"       = "assertion.repository"
    "attribute.repository_owner" = "assertion.repository_owner"
  }

  oidc {
    issuer_uri = "https://token.actions.githubusercontent.com"
  }
}

# IAM binding for the service account
resource "google_service_account_iam_binding" "workload_identity_binding" {
  service_account_id = "projects/${var.project-id}/serviceAccounts/github-pipline-terraform@${var.project-id}.iam.gserviceaccount.com"
  role               = "roles/iam.workloadIdentityUser"
  members            = [
    "principalSet://iam.googleapis.com/projects/${var.project-id}/locations/global/workloadIdentityPools/github-actions-terraform-pool/attribute.repository/${var.github_repo}"
  ]
}

resource "google_storage_bucket" "example_bucket" {
  name          = "terraform-app-123"                          # Unique name
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





