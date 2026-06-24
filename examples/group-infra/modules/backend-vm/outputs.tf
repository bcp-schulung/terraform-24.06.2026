output "vm_id" {
  description = "The ID of the backend virtual machine."
  value       = azurerm_linux_virtual_machine.main.id
}

output "private_ip_address" {
  description = "The private IP address of the backend VM network interface."
  value       = azurerm_network_interface.main.private_ip_address
}
