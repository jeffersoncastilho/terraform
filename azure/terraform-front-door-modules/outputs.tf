output "profile_id" {
  description = "ID do Front Door Profile"
  value       = azurerm_cdn_frontdoor_profile.this.id
}

output "endpoint_hostname" {
  description = "Hostname do Front Door Endpoint"
  value       = azurerm_cdn_frontdoor_endpoint.this.host_name
}

output "endpoint_id" {
  description = "ID do Front Door Endpoint"
  value       = azurerm_cdn_frontdoor_endpoint.this.id
}
