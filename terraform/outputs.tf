output "resource_group_name" {
  value = azurerm_resource_group.main.name
}

output "storage_account_name" {
  value = azurerm_storage_account.main.name
}

output "storage_container_name" {
  value = azurerm_storage_container.cost_exports.name
}

output "logic_app_name" {
  value = azurerm_logic_app_workflow.main.name
}

output "workbook_id" {
  value = azurerm_application_insights_workbook.main.id
}