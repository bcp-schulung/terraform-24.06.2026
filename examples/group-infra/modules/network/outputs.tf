output "vnet_id" {
  description = "The ID of the virtual network."
  value       = azurerm_virtual_network.main.id
}

output "frontend_subnet_id" {
  description = "The ID of the frontend subnet."
  value       = azurerm_subnet.frontend.id
}

output "backend_subnet_id" {
  description = "The ID of the backend subnet."
  value       = azurerm_subnet.backend.id
}

output "database_subnet_id" {
  description = "The ID of the database subnet."
  value       = azurerm_subnet.database.id
}
