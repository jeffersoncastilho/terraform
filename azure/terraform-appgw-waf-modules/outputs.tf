output "id" {
  description = "ID do Application Gateway"
  value       = azurerm_application_gateway.this.id
}

output "waf_policy_id" {
  description = "ID da WAF Policy"
  value       = azurerm_web_application_firewall_policy.this.id
}
