output "vmss_id" {
  description = "The ID of the frontend virtual machine scale set."
  value       = azurerm_linux_virtual_machine_scale_set.main.id
}
