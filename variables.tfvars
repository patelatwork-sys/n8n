# Tagging
tags = {
  XX  = "XX"  
}

# Environment Instance Info # Fill as as you see fit, but limit to 2 characters, as this defines the resource names
taxonomy = {
  deployment_environment         = ""
  deployment_environment_acronym = ""
  environment_acronym            = ""
  location                       = "eastus"
  location_acronym               = "eus"
  application_acronym            = "dv"
}

# Virtual Network Configuration
vnet_address_space                     = "10.0.0.0/16"
app_subnet_address_prefix              = "10.0.0.0/22"
private_endpoint_subnet_address_prefix = "10.0.4.0/24"
postgresql_subnet_address_prefix       = "10.0.5.0/24"

# PostgreSQL Configuration
flexibleServers_myn8npgsql_name = ""
postgresql_admin_username       = ""
postgresql_admin_password       = ""
tenant_id                       = ""
admin_user_object_id            = ""  # Object ID in Tenant for an Administrator
admin_user_principal_name       = ""  # Principal Name in Tenant for an Administrator

# PostgreSQL Firewall Rules (customize as needed)
postgresql_firewall_rules = {
  "AllowAzureCloudIPs" = {
    start_ip_address = ""   # Your Public IP Address
    end_ip_address   = ""
  }
  "AllowYourOffice" = {
    start_ip_address = ""  # Your Public IP Address
    end_ip_address   = ""
  }
}

# n8n Container Image Configuration
# Specify the n8n Docker image tag to deploy
#   - Use specific version (e.g., "1.114.0") for production stability
#   - Latest available: 1.114.0 (as of 2025-09-29)
# Use the scripts/check-n8n-versions.ps1 to figure out the latest stable version
# perform terraform taint for null_resource.import_n8n_image, for reimport the image to the container registry
latest_tag = "1.114.0"