output "resource_group_name" {
  description = "Name of the created resource group."
  value       = azurerm_resource_group.artizens.name
}

output "vm_public_ip" {
  description = "Public IP address of the VM."
  value       = azurerm_public_ip.vm.ip_address
}

output "ssh_command" {
  description = "Command used to connect to the VM."
  value       = "ssh ${var.admin_username}@${azurerm_public_ip.vm.ip_address}"
}
