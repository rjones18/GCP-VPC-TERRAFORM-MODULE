module "vpc" {
  source     = "../"
  project_id ="alert-flames-286515"
  name       = "cloud-projects-vpc"

  subnets = {
    "us-central1-app" = {
      name          = "prod-uscentral1-app"
      region        = "us-central1"
      ip_cidr_range = "10.10.0.0/20"
      secondary_ip_ranges = [
        { range_name = "pods",     ip_cidr_range = "10.20.0.0/16" },
        { range_name = "services", ip_cidr_range = "10.30.0.0/20" }
      ]
    }

    "us-east1-app" = {
      name          = "prod-useast1-app"
      region        = "us-east1"
      ip_cidr_range = "10.11.0.0/20"
    }
  }

  enable_nat        = true
  nat_region        = "us-central1"
  nat_subnet_names  = ["us-central1-app"]
  nat_logging       = true
}
