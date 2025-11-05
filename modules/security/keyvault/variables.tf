variable "global_settings" {
  description = "Global settings object (see module README.md)"
}
variable "client_config" {
  description = "Client configuration object (see module README.md)."
}
variable "settings" {
  description = "Configuration settings for the Key Vault"
  type        = any

  validation {
    condition = can(var.settings.public_network_access_enabled) ? var.settings.public_network_access_enabled == false : true
    error_message = "Key Vault public network access should be disabled for security. Set public_network_access_enabled = false and use private endpoints or VNet integration."
  }

  validation {
    condition = can(var.settings.purge_protection_enabled) ? var.settings.purge_protection_enabled == true : true
    error_message = "Key Vault purge protection should be enabled for production environments to prevent accidental deletion of critical secrets and keys."
  }

  validation {
    condition = can(var.settings.soft_delete_retention_days) ? var.settings.soft_delete_retention_days >= 7 && var.settings.soft_delete_retention_days <= 90 : true
    error_message = "Key Vault soft delete retention days must be between 7 and 90 days. Recommended: 90 days for production environments."
  }

  validation {
    condition = can(var.settings.network.default_action) ? contains(["Deny", "Allow"], var.settings.network.default_action) : true
    error_message = "Key Vault network default_action must be 'Deny' or 'Allow'. 'Deny' is recommended for security."
  }
}
variable "vnets" {
  default = {}
}
variable "azuread_groups" {
  default = {}
}
variable "managed_identities" {
  default = {}
}
# For diagnostics settings
variable "diagnostics" {
  default = {}
}
variable "private_dns" {
  default = {}
}
variable "location" {
  description = "location of the resource if different from the resource group."
  default     = null
}
variable "resource_group_name" {
  description = "Resource group object to deploy the virtual machine"
  default     = null
}
variable "resource_group" {
  description = "Resource group object to deploy the virtual machine"
}
variable "base_tags" {
  description = "Base tags for the resource to be inherited from the resource group."
  type        = bool
}
variable "virtual_subnets" {
  description = "Map of virtual_subnets objects"
  default     = {}
  nullable    = false
}