output "vnet_id" {
  description = "The ID of the virtual network."
  value       = module.network.vnet_id
}

output "frontend_subnet_id" {
  description = "The ID of the frontend subnet."
  value       = module.network.frontend_subnet_id
}

output "backend_subnet_id" {
  description = "The ID of the backend subnet."
  value       = module.network.backend_subnet_id
}

output "database_subnet_id" {
  description = "The ID of the database subnet."
  value       = module.network.database_subnet_id
}

output "lb_id" {
  description = "The ID of the load balancer."
  value       = module.loadbalancer.lb_id
}

output "lb_backend_address_pool_id" {
  description = "The ID of the load balancer backend address pool."
  value       = module.loadbalancer.backend_address_pool_id
}

output "lb_public_ip_address" {
  description = "The public IP address of the load balancer."
  value       = module.loadbalancer.public_ip_address
}

output "backend_vm_private_ip" {
  description = "The private IP address of the backend virtual machine."
  value       = module.backend_vm.private_ip_address
}

output "db_fqdn" {
  description = "The fully qualified domain name of the database server."
  value       = module.database.db_fqdn
}
