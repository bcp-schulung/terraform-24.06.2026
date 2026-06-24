# Integration test: verifies that the root module correctly wires the full
# customer_a stack. Uses mock_provider so no real Azure resources are created.
# The root module's providers.tf already provides the required azurerm features
# block, so mock_provider picks it up correctly.
mock_provider "azurerm" {}

run "integration_full_stack_plan" {
  command = plan

  # Test the root module — it already calls module.customer_a which calls
  # mother_of_modules. This validates the complete end-to-end wiring.
  # command=plan is used so resource IDs (unknown-after-apply) are not
  # evaluated; the plan succeeding is itself the integration assertion.
  variables {
    admin_password = "IntegrationTest123!"
  }
}

