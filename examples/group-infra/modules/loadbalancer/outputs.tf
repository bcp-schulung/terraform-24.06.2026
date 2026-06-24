output "lb_id" {
  description = "The ID of the load balancer."
  value       = azurerm_lb.main.id
}

output "backend_address_pool_id" {
  description = "The ID of the load balancer backend address pool."
  value       = azurerm_lb_backend_address_pool.main.id
}

output "public_ip_address" {
  description = "The allocated public IP address of the load balancer."
  value       = azurerm_public_ip.main.ip_address
}
