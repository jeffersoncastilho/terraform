################################################################################
# Script: Inicia Failover Manual do Storage Account e Valida Leitura
# Uso: ./test-storage-failover.ps1
################################################################################

param(
    [string]$ResourceGroup  = "rg-blog-castilho-workload-brazilsouth",
    [string]$StorageName    = "stblogcastilhobrazil"
)

$storage = Get-AzStorageAccount -ResourceGroupName $ResourceGroup -Name $StorageName

Write-Host "=== Estado ANTES do Failover ==="
$stats = $storage | Get-AzStorageAccountGeoReplicationStats
Write-Host "Status de Geo-Replicação : $($stats.GeoReplicationStatus)"
Write-Host "Último Sync              : $($stats.LastSyncTime)"
Write-Host "Endpoint Primário        : $($storage.PrimaryEndpoints.Blob)"
Write-Host "Endpoint Secundário      : $($storage.SecondaryEndpoints.Blob)"
Write-Host ""

$confirm = Read-Host "Confirmar failover manual? Este processo pode levar minutos e é irreversível por 1h (s/n)"
if ($confirm -ne "s") { Write-Host "Cancelado."; exit 0 }

Write-Host "Iniciando failover..."
Invoke-AzStorageAccountFailover -ResourceGroupName $ResourceGroup -Name $StorageName -Force

Write-Host "Aguardando conclusão do failover..."
do {
    Start-Sleep -Seconds 15
    $storage = Get-AzStorageAccount -ResourceGroupName $ResourceGroup -Name $StorageName
    Write-Host "  Status: $($storage.StatusOfPrimary)"
} while ($storage.StatusOfPrimary -ne "available")

Write-Host ""
Write-Host "=== Estado APÓS o Failover ==="
Write-Host "Região Primária  : $($storage.PrimaryLocation)"
Write-Host "Endpoint Primário: $($storage.PrimaryEndpoints.Blob)"
Write-Host "Replicação atual : $($storage.Sku.Name)"
