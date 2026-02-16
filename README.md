# GCP-VPC-TERRAFORM-MODULE

Reusable Terraform module for provisioning a production-ready Google Cloud VPC network.

This module creates a custom-mode VPC, regional subnets, optional secondary IP ranges (for GKE), and optional Cloud Router + Cloud NAT for private egress. It is designed for multi-region deployments and can be reused across dev, staging, and production environments.

---

## Features

- Creates a custom VPC network (auto subnet creation disabled)
- Supports multiple regional subnets
- Optional secondary IP ranges for GKE (pods/services)
- Optional Cloud Router and Cloud NAT
- Configurable routing mode (REGIONAL or GLOBAL)
- Designed for reusable, environment-based deployments

---

## Architecture Overview

The module provisions:

- One global VPC network
- One or more regional subnets
- Optional secondary CIDR ranges per subnet
- Optional Cloud Router (required for NAT)
- Optional Cloud NAT for private workloads without external IPs

---

## Usage

```hcl
module "vpc" {
  source     = "./modules/gcp-vpc"
  name       = "cloud-projects-vpc"

  subnets = {
    "us-central1-app" = {
      name          = "cloud-uscentral1-app"
      region        = "us-central1"
      ip_cidr_range = "10.10.0.0/20"
      secondary_ip_ranges = [
        { range_name = "pods",     ip_cidr_range = "10.20.0.0/16" },
        { range_name = "services", ip_cidr_range = "10.30.0.0/20" }
      ]
    }

    "us-east1-app" = {
      name          = "cloud-useast1-app"
      region        = "us-east1"
      ip_cidr_range = "10.11.0.0/20"
    }
  }

  enable_nat       = true
  nat_region       = "us-central1"
  nat_subnet_names = ["us-central1-app"]
  nat_logging      = true
}
