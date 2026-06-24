# Tests for the loadbalancer module.
# Uses mock_provider so no real Azure credentials or API calls are needed.
mock_provider "azurerm" {}

# ── Resource naming ───────────────────────────────────────────────────────────

run "loadbalancer_resource_names" {
  command = plan

  module {
    source = "./modules/loadbalancer"
  }

  variables {
    name                            = "test-customer"
    resource_group_name             = "rg-tf-lab"
    azurerm_public_ip               = "pip-test-customer"
    azurerm_lb                      = "lb-test-customer"
    azurerm_lb_backend_address_pool = "lbbap-test-customer"
    azurerm_lb_probe                = "lbprobe-test-customer"
    azurerm_lb_rule                 = "lbrule-test-customer"
  }

  assert {
    condition     = azurerm_public_ip.main.name == "pip-test-customer"
    error_message = "Public IP name must match the azurerm_public_ip input variable."
  }

  assert {
    condition     = azurerm_lb.main.name == "lb-test-customer"
    error_message = "Load balancer name must match the azurerm_lb input variable."
  }

  assert {
    condition     = azurerm_lb_backend_address_pool.main.name == "lbbap-test-customer"
    error_message = "Backend address pool name must match the azurerm_lb_backend_address_pool input variable."
  }

  assert {
    condition     = azurerm_lb_probe.main.name == "lbprobe-test-customer"
    error_message = "LB probe name must match the azurerm_lb_probe input variable."
  }

  assert {
    condition     = azurerm_lb_rule.main.name == "lbrule-test-customer"
    error_message = "LB rule name must match the azurerm_lb_rule input variable."
  }
}

# ── SKU propagation ───────────────────────────────────────────────────────────

run "loadbalancer_sku_propagation" {
  command = plan

  module {
    source = "./modules/loadbalancer"
  }

  variables {
    name                            = "test-customer"
    resource_group_name             = "rg-tf-lab"
    sku                             = "Standard"
    azurerm_public_ip               = "pip-test-customer"
    azurerm_lb                      = "lb-test-customer"
    azurerm_lb_backend_address_pool = "lbbap-test-customer"
    azurerm_lb_probe                = "lbprobe-test-customer"
    azurerm_lb_rule                 = "lbrule-test-customer"
  }

  assert {
    condition     = azurerm_public_ip.main.sku == "Standard"
    error_message = "Public IP SKU must match the sku input variable."
  }

  assert {
    condition     = azurerm_lb.main.sku == "Standard"
    error_message = "Load balancer SKU must match the sku input variable."
  }
}

# ── HTTP probe and rule configuration ─────────────────────────────────────────

run "loadbalancer_http_probe_and_rule" {
  command = plan

  module {
    source = "./modules/loadbalancer"
  }

  variables {
    name                            = "test-customer"
    resource_group_name             = "rg-tf-lab"
    azurerm_public_ip               = "pip-test-customer"
    azurerm_lb                      = "lb-test-customer"
    azurerm_lb_backend_address_pool = "lbbap-test-customer"
    azurerm_lb_probe                = "lbprobe-test-customer"
    azurerm_lb_rule                 = "lbrule-test-customer"
  }

  assert {
    condition     = azurerm_lb_probe.main.port == 80
    error_message = "LB health probe must listen on port 80."
  }

  assert {
    condition     = azurerm_lb_probe.main.protocol == "Http"
    error_message = "LB health probe must use HTTP protocol."
  }

  assert {
    condition     = azurerm_lb_rule.main.frontend_port == 80
    error_message = "LB rule frontend port must be 80."
  }

  assert {
    condition     = azurerm_lb_rule.main.backend_port == 80
    error_message = "LB rule backend port must be 80."
  }

  assert {
    condition     = azurerm_lb_rule.main.protocol == "Tcp"
    error_message = "LB rule protocol must be Tcp."
  }
}
