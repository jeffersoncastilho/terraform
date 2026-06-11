output "primary_storage_id" {
  description = "ID do Storage Account primário"
  value       = module.storage_primary.storage_account_id
}

output "primary_blob_endpoint" {
  description = "Endpoint blob do Storage Account primário"
  value       = module.storage_primary.primary_blob_endpoint
}

output "cache_storage_id" {
  description = "ID do Storage Account de cache (ASR)"
  value       = module.storage_cache.storage_account_id
}
