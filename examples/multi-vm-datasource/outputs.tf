output "public_ip_addresses" {
  description = "Public IP addresses of the VMs, keyed by role."
  value       = { for k, v in azurerm_public_ip.main : k => v.ip_address }
}

output "ssh_commands" {
  description = "SSH commands to connect to each VM, keyed by role."
  value       = { for k, v in azurerm_public_ip.main : k => "ssh ${var.admin_username}@${v.ip_address}" }
}

output "vm_ids" {
  description = "Resource IDs of the virtual machines, keyed by role."
  value       = { for k, v in azurerm_linux_virtual_machine.main : k => v.id }
}

output "private_keys_pem" {
  description = "Private keys to SSH into each VM (save to a file and chmod 600), keyed by role."
  value       = { for k, v in tls_private_key.main : k => v.private_key_openssh }
  sensitive   = true
}

output "resolved_image_version" {
  description = "Exact image version resolved by the platform image data source. Useful to verify which build was deployed."
  value       = "${var.image_publisher}:${var.image_offer}:${var.image_sku}:${data.azurerm_platform_image.main.version}"
}
