variable "global_settings" {
  description = "Global settings object (see module README.md)"
}
variable "client_config" {
  description = "Client configuration object (see module README.md)."
}
variable "settings" {
  description = "Configuration settings for the MSSQL Server"
  type        = any

  validation {
    condition = can(var.settings.public_network_access_enabled) ? var.settings.public_network_access_enabled == false : true
    error_message = "MSSQL Server public network access should be disabled for security. Use private endpoints or VNet integration instead."
  }

  validation {
    condition = can(var.settings.minimum_tls_version) ? contains(["1.0", "1.1", "1.2"], var.settings.minimum_tls_version) && var.settings.minimum_tls_version == "1.2" : true
    error_message = "MSSQL Server minimum TLS version should be 1.2 for security compliance."
  }

  validation {
    condition = can(var.settings.administrator_login_password) ? length(var.settings.administrator_login_password) == 0 : true
    error_message = "Do not hardcode administrator_login_password in configuration. Use Key Vault integration or let the module auto-generate and store passwords securely."
  }
}
variable "resource_group_name" {
  description = "(Required) The name of the resource group where to create the resource."
  type        = string
}
variable "location" {
  description = "(Required) Specifies the supported Azure location where to create the resource. Changing this forces a new resource to be created."
  type        = string
}
variable "storage_accounts" {}
variable "azuread_groups" {}
variable "vnets" {}
variable "private_endpoints" {}
variable "resource_groups" {}
variable "resource_group" {}
variable "base_tags" {
  description = "Base tags for the resource to be inherited from the resource group."
  type        = bool
}
variable "private_dns" {
  default = {}
}
variable "keyvault_id" {}
variable "remote_objects" {}