# Azure Container Registry
resource "azurerm_container_registry" "acr_n8n" {
  name                = "creg-${var.taxonomy.application_acronym}-${var.taxonomy.deployment_environment_acronym}-${var.taxonomy.location_acronym}"
  resource_group_name = azurerm_resource_group.rg_n8n.name
  location            = azurerm_resource_group.rg_n8n.location
  sku                 = "Premium" # Premium required for private endpoints
  admin_enabled       = false

  # Enable network access restrictions
  public_network_access_enabled = true
  network_rule_bypass_option    = "AzureServices"

  # Network rule set to allow specific IP ranges
  network_rule_set {
    default_action = "Deny"

    ip_rule {
      action   = "Allow"
      ip_range = "20.15.23.80/28"
    }

    ip_rule {
      action   = "Allow"
      ip_range = "52.252.181.144/28"
    }

    ip_rule {
      action   = "Allow"
      ip_range = "52.238.28.176/28"
    }

    ip_rule {
      action   = "Allow"
      ip_range = "20.83.69.80/28"
    }

    ip_rule {
      action   = "Allow"
      ip_range = "199.207.253.101/32"
    }
    ip_rule {
      action   = "Allow"
      ip_range = "136.226.102.126/32"
    }
    ip_rule {
      action   = "Allow"
      ip_range = "199.206.0.31/32"
    }
  }

  tags = var.tags
}

# Private Endpoint for Container Registry
resource "azurerm_private_endpoint" "acr_private_endpoint" {
  name                = "pe-${module.resource_name.n8n.container_registry}"
  location            = azurerm_resource_group.rg_n8n.location
  resource_group_name = azurerm_resource_group.rg_n8n.name
  subnet_id           = azurerm_subnet.subnet_n8n_private_endpoints.id

  private_service_connection {
    name                           = "psc-${module.resource_name.n8n.container_registry}"
    private_connection_resource_id = azurerm_container_registry.acr_n8n.id
    subresource_names              = ["registry"]
    is_manual_connection           = false
  }

  private_dns_zone_group {
    name                 = "pdz-group-${module.resource_name.n8n.container_registry}"
    private_dns_zone_ids = [azurerm_private_dns_zone.container_registry.id]
  }

  tags = var.tags
}

# Role assignment for Container Registry (if needed for container apps)
resource "azurerm_role_assignment" "acr_pull" {
  scope                = azurerm_container_registry.acr_n8n.id
  role_definition_name = "AcrPull"
  principal_id         = azurerm_user_assigned_identity.container_app_identity.principal_id

  depends_on = [azurerm_user_assigned_identity.container_app_identity]
}

# User Assigned Identity for Container Apps (to pull from ACR)
resource "azurerm_user_assigned_identity" "container_app_identity" {
  name                = "id-${module.resource_name.n8n.name}-containerapp"
  location            = azurerm_resource_group.rg_n8n.location
  resource_group_name = azurerm_resource_group.rg_n8n.name

  tags = var.tags
}

# Null resource to import n8n image from Docker Hub to ACR
resource "null_resource" "import_n8n_image" {
  depends_on = [azurerm_container_registry.acr_n8n]

  provisioner "local-exec" {
    command = <<-EOT
      az acr import --name ${azurerm_container_registry.acr_n8n.name} --source docker.io/n8nio/n8n:${var.latest_tag} --image n8n:${var.latest_tag} --resource-group ${azurerm_resource_group.rg_n8n.name}
    EOT
  }

  # Trigger re-import when ACR changes
  triggers = {
    acr_id = azurerm_container_registry.acr_n8n.id
  }
}