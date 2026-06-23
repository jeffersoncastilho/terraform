module "resource_group" {
  source          = "../../terraform-resource-group-modules"
  resource_type   = "rg"
  project_name    = "kafka-blog-castilho"
  environment     = ""
  location_suffix = "eus"
  location        = "eastus"
  tags            = var.tags
}
