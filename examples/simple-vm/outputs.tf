output "public_ip_address" {
  description = "Public IP address of the VM"
  value       = azurerm_public_ip.main.ip_address
}

output "ssh_command" {
  description = "SSH command to connect to the VM"
  value       = "ssh ${var.admin_username}@${azurerm_public_ip.main.ip_address}"
}

output "vm_id" {
  description = "Resource ID of the virtual machine"
  value       = azurerm_linux_virtual_machine.main.id
}

output "private_key_pem" {
  description = "Private key to SSH into the VM (save to a file and chmod 600)"
  value       = tls_private_key.main.private_key_openssh
  sensitive   = true
}
