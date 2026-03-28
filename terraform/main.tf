resource "azurerm_resource_group" "main" {
  name     = "rg-finops-dashboard-dev"
  location = "France Central"
}

resource "azurerm_storage_account" "main" {
  name                     = "stfinopsdashboarddev01"
  resource_group_name      = azurerm_resource_group.main.name
  location                 = azurerm_resource_group.main.location
  account_tier             = "Standard"
  account_replication_type = "LRS"

  tags = {
    project     = "finops-dashboard"
    environment = "dev"
  }
}

resource "azurerm_storage_container" "cost_exports" {
  name                  = "cost-exports"
  storage_account_id    = azurerm_storage_account.main.id
  container_access_type = "private"
}

resource "azurerm_monitor_action_group" "main" {
  name                = "ag-finops-dashboard-dev"
  resource_group_name = azurerm_resource_group.main.name
  short_name          = "finopsag"

  email_receiver {
    name          = "cost-alert-email"
    email_address = "tosinadeyemo44@gmail.com"
  }

  tags = {
    project     = "finops-dashboard"
    environment = "dev"
  }
}

resource "azurerm_consumption_budget_subscription" "main" {
  name            = "budget-finops-dashboard-dev"
  subscription_id = "/subscriptions/${data.azurerm_client_config.current.subscription_id}"

  amount     = 50
  time_grain = "Monthly"

  time_period {
    start_date = "2026-03-01T00:00:00Z"
    end_date   = "2030-03-01T00:00:00Z"
  }

  notification {
    enabled        = true
    threshold      = 50
    operator       = "GreaterThan"
    threshold_type = "Actual"

    contact_emails = ["tosinadeyemo@gmail.com"]
  }

  notification {
    enabled        = true
    threshold      = 80
    operator       = "GreaterThan"
    threshold_type = "Actual"

    contact_groups = [azurerm_monitor_action_group.main.id]
  }

  notification {
    enabled        = true
    threshold      = 100
    operator       = "GreaterThan"
    threshold_type = "Actual"

    contact_groups = [azurerm_monitor_action_group.main.id]
  }
}