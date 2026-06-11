################################################################################
# Script: Verifica Last Sync Time (indicador de RPO real do Storage)
# Uso: ./check-replication-lag.ps1
################################################################################

param(
    [string]$ResourceGroup = "rg-blog-castilho-workload-brazilsouth",
    [string]$StorageName   = "stblogcastilhobrazil"
)

$storage = Get-AzStorageAccount -ResourceGroupName $ResourceGroup -Name $StorageName
$stats   = $storage | Get-AzStorageAccountGeoReplicationStats

$lastSync = $stats.LastSyncTime
$lagMin   = if ($lastSync) { [math]::Round((Get-Date) - $lastSync | Select-Object -ExpandProperty TotalMinutes, 1) } else { "N/A" }

Write-Host "Storage Account  : $StorageName"
Write-Host "Replicação       : $($storage.Sku.Name)"
Write-Host "Status Geo-Rep   : $($stats.GeoReplicationStatus)"
Write-Host "Último Sync (UTC): $lastSync"
Write-Host "Lag aproximado   : $lagMin minutos"
