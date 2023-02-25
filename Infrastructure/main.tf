# Read clientID and clientSecret from Azure keyvault
data "azurerm_resource_group" "rgkv" {
  name     = var.resource_group_name
}

data "azurerm_key_vault" "cpkeyvault" {
  name                = "cloudprojectkeyvault"
  resource_group_name = var.resource_group_name
}

data "azurerm_key_vault_secret" "clientId" {
  name         = "cpclientid"
  key_vault_id = data.azurerm_key_vault.cpkeyvault.id
}

data "azurerm_key_vault_secret" "objectId" {
  name         = "cpobjectid"
  key_vault_id = data.azurerm_key_vault.cpkeyvault.id
}

data "azurerm_key_vault_secret" "clientSecret" {
  name         = "cpclientsecret"
  key_vault_id = data.azurerm_key_vault.cpkeyvault.id
}

data "azurerm_key_vault_secret" "idrsa" {
  name         = "idrsa"
  key_vault_id = data.azurerm_key_vault.cpkeyvault.id
}

data "azurerm_resource_group" "rg" {
  name     = var.rg_name
}

resource "random_id" "log_analytics_workspace_name_suffix" {
  byte_length = 8
}

resource "azurerm_log_analytics_workspace" "cpworkspace" {
  location            = var.log_analytics_workspace_location
  name                = "${var.log_analytics_workspace_name}-${random_id.log_analytics_workspace_name_suffix.dec}"
  resource_group_name = data.azurerm_resource_group.rg.name
  sku                 = var.log_analytics_workspace_sku
}

resource "azurerm_log_analytics_solution" "cpsolution" {
  location              = azurerm_log_analytics_workspace.cpworkspace.location
  resource_group_name   = data.azurerm_resource_group.rg.name
  solution_name         = "ContainerInsights"
  workspace_name        = azurerm_log_analytics_workspace.cpworkspace.name
  workspace_resource_id = azurerm_log_analytics_workspace.cpworkspace.id

  plan {
    product   = "OMSGallery/ContainerInsights"
    publisher = "Microsoft"
  }
}

resource "azurerm_role_assignment" "role_acrpull" {
  scope                            = azurerm_container_registry.acr.id
  role_definition_name             = "AcrPull"
  principal_id                     = "${data.azurerm_key_vault_secret.objectId.value}"
  skip_service_principal_aad_check = true
}

resource "azurerm_container_registry" "acr" {
  name                = var.acr_name
  resource_group_name = data.azurerm_resource_group.rg.name
  location            = data.azurerm_resource_group.rg.location
  sku                 = "Standard"
  admin_enabled       = false
}

resource "azurerm_kubernetes_cluster" "k8s" {
  location            = data.azurerm_resource_group.rg.location
  name                = var.cluster_name
  resource_group_name = data.azurerm_resource_group.rg.name
  dns_prefix          = var.dns_prefix
  tags                = {
    Environment = "Development"
  }

  default_node_pool {
    name       = "agentpool"
    vm_size    = "Standard_D2_v2"
    node_count = var.agent_count
  }
  linux_profile {
    admin_username = "ubuntu"

    ssh_key {
      key_data = "${data.azurerm_key_vault_secret.idrsa.value}"
    }
  }
  network_profile {
    network_plugin    = "kubenet"
    load_balancer_sku = "standard"
  }
  service_principal {
    client_id     = "${data.azurerm_key_vault_secret.clientId.value}"
    client_secret = "${data.azurerm_key_vault_secret.clientSecret.value}"
  }
}