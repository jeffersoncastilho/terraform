output "appgw_public_ip" {
  value = module.pip_appgw.ip_address
}

output "backend_fqdn" {
  value = replace(replace(module.storage_backend.primary_web_endpoint, "https://", ""), "/", "")
}

output "waf_policy_id" {
  value = module.appgw_waf.waf_policy_id
}
