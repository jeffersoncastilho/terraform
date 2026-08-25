# Módulo: terraform-tag-governance-modules
# Provider: azure
# Cria uma Azure Policy custom (efeito "modify") que adiciona automaticamente uma tag padrão
# em Resource Groups que não a tiverem, e a atribui na subscription com managed identity.

resource "azurerm_policy_definition" "tag_governance" {
  name         = var.policy_name
  policy_type  = "Custom"
  mode         = "All"
  display_name = var.policy_display_name
  description  = "Adiciona automaticamente a tag '${var.tag_name}' com valor padrão em Resource Groups que não a tiverem, para garantir rateio de custo (FinOps)."

  metadata = jsonencode({
    category = "Tags"
  })

  policy_rule = jsonencode({
    if = {
      field  = "type"
      equals = "Microsoft.Resources/subscriptions/resourceGroups"
    }
    then = {
      effect = "modify"
      details = {
        roleDefinitionIds = [
          "/providers/microsoft.authorization/roleDefinitions/4a9ae827-6dc8-4573-8ac7-8239d42aa03f" # Tag Contributor
        ]
        operations = [
          {
            operation = "add"
            field     = "tags['${var.tag_name}']"
            value     = var.tag_default_value
          }
        ]
      }
    }
  })
}

resource "azurerm_subscription_policy_assignment" "tag_governance" {
  name                 = var.assignment_name
  display_name         = var.policy_display_name
  policy_definition_id = azurerm_policy_definition.tag_governance.id
  subscription_id      = "/subscriptions/${var.subscription_id}"
  location             = var.location

  identity {
    type = "SystemAssigned"
  }
}

resource "azurerm_role_assignment" "tag_contributor" {
  scope                = "/subscriptions/${var.subscription_id}"
  role_definition_name = "Tag Contributor"
  principal_id         = azurerm_subscription_policy_assignment.tag_governance.identity[0].principal_id
}
