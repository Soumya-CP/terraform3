output "resource_group_name" {
  description = "Name of the created resource group."
  value       = azurerm_resource_group.this.name
}

output "vm_id" {
  description = "Resource ID of the created Linux virtual machine."
  value       = azurerm_linux_virtual_machine.this.id
}

output "private_ip_address" {
  description = "Private IP address assigned to the VM network interface."
  value       = azurerm_network_interface.this.private_ip_address
}