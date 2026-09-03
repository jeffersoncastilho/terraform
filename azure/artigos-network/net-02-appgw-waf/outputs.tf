output "appgw_public_ip" {
  value = azurerm_public_ip.appgw.ip_address
}

output "backend_fqdn" {
  value = replace(replace(azurerm_storage_account.backend.primary_web_endpoint, "https://", ""), "/", "")
}

output "waf_policy_id" {
  value = azurerm_web_application_firewall_policy.this.id
}
