variable "project-id" {
  description = "Compute zone"
  type        = string
  default     = "terraform-447812"
}

variable "region" {
    description = "Region of"
    type = string
    default = "europe-north1"
}

variable "zone" {
    description = "zone of"
    type = string
    default = "europe-north1-a"
}
variable "github_repo" {
  description = "GitHub repository in format OWNER/REPO"
  type        = string
  default     = "oscarthroedson/terraform"
}