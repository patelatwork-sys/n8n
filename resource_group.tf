locals {
  n8n_rgp_name = "rgp-${var.taxonomy.application_acronym}-${var.taxonomy.deployment_environment_acronym}-${var.taxonomy.location_acronym}"
}
resource "azurerm_resource_group" "rg_n8n" {
  name     = local.n8n_rgp_name
  location = var.taxonomy.location
  tags     = var.tags
}