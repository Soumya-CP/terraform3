variable "subscription_id" {
  description = "Azure subscription ID in which to create the resources."
  type        = string
}

variable "location" {
  description = "Azure region in which to create the resources."
  type        = string
  default     = "Central India"
}

variable "admin_username" {
  description = "Administrator username for the Linux VM."
  type        = string
  default     = "azureadmin"
}

variable "ssh_public_key" {
  description = "SSH public key used to access the VM."
  type        = string
  sensitive   = true
}

variable "ssh_allowed_cidr" {
  description = "CIDR allowed to connect to the VM over SSH. Restrict this to your public IP when possible."
  type        = string
  default     = "0.0.0.0/0"
}
