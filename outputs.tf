output "network_id" {
  value = google_compute_network.this.id
}

output "network_name" {
  value = google_compute_network.this.name
}

output "subnet_ids" {
  value = { for k, s in google_compute_subnetwork.subnets : k => s.id }
}

output "subnet_self_links" {
  value = { for k, s in google_compute_subnetwork.subnets : k => s.self_link }
}
