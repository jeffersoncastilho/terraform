output "dns_zone_ids" {
  description = "Map de zone_name => ID das Private DNS Zones criadas"
  value       = { for k, v in module.dns_zones : k => v.id }
}
