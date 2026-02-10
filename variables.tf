variable "project_id" {
  type        = string
  description = "GCP project ID"
}

variable "name" {
  type        = string
  description = "VPC network name"
}

variable "description" {
  type        = string
  default     = null
}

variable "routing_mode" {
  type        = string
  default     = "REGIONAL"
  validation {
    condition     = contains(["REGIONAL", "GLOBAL"], var.routing_mode)
    error_message = "routing_mode must be REGIONAL or GLOBAL."
  }
}

# Subnets keyed by a stable key you choose (e.g., "us-central1-app")
variable "subnets" {
  description = "Map of subnets to create"
  type = map(object({
    name                    = string
    region                  = string
    ip_cidr_range           = string
    private_ip_google_access = optional(bool, true)

    # Optional: for GKE or other alias ranges
    secondary_ip_ranges = optional(list(object({
      range_name    = string
      ip_cidr_range = string
    })), [])
  }))
}

variable "enable_nat" {
  type        = bool
  default     = false
  description = "Create Cloud Router + Cloud NAT for private egress"
}

variable "nat_region" {
  type        = string
  default     = null
  description = "Region where Cloud Router/NAT will live (must match subnets you want NAT for)"
}

variable "nat_subnet_names" {
  type        = list(string)
  default     = []
  description = "Keys from var.subnets to NAT (ex: [\"us-central1-app\"])"
}

variable "nat_logging" {
  type        = bool
  default     = true
  description = "Enable NAT logging (ERRORS_ONLY)"
}
