output "instance_ip_addr" {
  value = google_compute_instance.default.network_interface[0].network_ip
  description = "The private IP address of the Google Compute Engine instance."
}
