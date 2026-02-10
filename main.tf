resource "google_compute_network" "this" {
  name                    = var.name
  project                 = var.project_id
  auto_create_subnetworks = false
  routing_mode            = var.routing_mode # "REGIONAL" or "GLOBAL"
  description             = var.description
}

resource "google_compute_subnetwork" "subnets" {
  for_each               = var.subnets
  name                   = each.value.name
  project                = var.project_id
  region                 = each.value.region
  network                = google_compute_network.this.id
  ip_cidr_range          = each.value.ip_cidr_range
  private_ip_google_access = try(each.value.private_ip_google_access, true)

  dynamic "secondary_ip_range" {
    for_each = try(each.value.secondary_ip_ranges, [])
    content {
      range_name    = secondary_ip_range.value.range_name
      ip_cidr_range = secondary_ip_range.value.ip_cidr_range
    }
  }
}

# Optional Cloud Router (needed for Cloud NAT)
resource "google_compute_router" "this" {
  count   = var.enable_nat ? 1 : 0
  name    = "${var.name}-router"
  project = var.project_id
  region  = var.nat_region
  network = google_compute_network.this.id
}

resource "google_compute_router_nat" "this" {
  count   = var.enable_nat ? 1 : 0
  name    = "${var.name}-nat"
  project = var.project_id
  region  = var.nat_region
  router  = google_compute_router.this[0].name

  nat_ip_allocate_option             = "AUTO_ONLY"
  source_subnetwork_ip_ranges_to_nat = "LIST_OF_SUBNETWORKS"

  dynamic "subnetwork" {
    for_each = var.nat_subnet_names
    content {
      name                    = google_compute_subnetwork.subnets[subnetwork.value].id
      source_ip_ranges_to_nat  = ["ALL_IP_RANGES"]
    }
  }

  log_config {
    enable = var.nat_logging
    filter = "ERRORS_ONLY"
  }
}
