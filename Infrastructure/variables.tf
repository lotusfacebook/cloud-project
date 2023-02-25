variable "agent_count" {
  default = 3
}

variable "aks_service_principal_app_id" {
  default = ""
}

variable "aks_service_principal_client_secret" {
  default = ""
}

variable "cluster_name" {
  default = "cloudproject"
}

variable "dns_prefix" {
  default = "cloudproject"
}

variable "log_analytics_workspace_location" {
  default = "eastus"
}

variable "log_analytics_workspace_name" {
  default = "cpLogAnalyticsWorkspaceName"
}


variable "log_analytics_workspace_sku" {
  default = "PerGB2018"
}

variable "resource_group_location" {
  default     = "eastus"
  description = "Location of the resource group."
}

variable "resource_group_name_prefix" {
  default     = "rg"
  description = "Prefix of the resource group name that's combined with a random ID so name is unique in your Azure subscription."
}

variable "acr_name" {
  default = "cloudprojectacr"
}

variable "resource_group_name" {
  default     = "uchechi"
  description = "name of the resource group for keyvault."
}

variable "rg_name" {
  default     = "cloudproject"
  description = "name of the resource group for k8s cluster."
}