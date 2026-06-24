variable "admin_password" {
  type        = string
  description = "Administrator password for all VMs and databases. Provide via terraform.tfvars or -var flag."
  sensitive   = true
}
