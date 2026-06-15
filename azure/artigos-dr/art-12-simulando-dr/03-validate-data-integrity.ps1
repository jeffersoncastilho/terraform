################################################################################
# Script: Verifica integridade dos dados replicados (Storage + ASR last sync)
################################################################################

param(
    [string]$StorageResourceGroup = "rg-blog-castilho-workload-brazilsouth",
    [string]$StorageName          = "stblogcastilhobrazil",
    [string]$VaultResourceGroup   = "rg-blog-castilho-network-eastus",
    [string]$VaultName            = "rsv-blog-castilho-eastus",
    [int]$MaxSyncLagMinutes       = 5
)

Write-Output "=== VALIDAÇÃO DE INTEGRIDADE DOS DADOS ==="
Write-Output ""

Write-Output "--- Storage Geo-Replication ---"
$storage = Get-AzStorageAccount -ResourceGroupName $StorageResourceGroup -Name $StorageName
$stats   = $storage | Get-AzStorageAccountGeoReplicationStats

$lagMinutes = if ($stats.LastSyncTime) {
    [int]((Get-Date) - $stats.LastSyncTime.ToUniversalTime()).TotalMinutes
} else { 999 }

Write-Output "  Status       : $($stats.GeoReplicationStatus)"
Write-Output "  Último sync  : $($stats.LastSyncTime)"
Write-Output "  Lag (min)    : $lagMinutes"

if ($lagMinutes -le $MaxSyncLagMinutes) {
    Write-Output "  Resultado    : OK (dentro do RPO de $MaxSyncLagMinutes min)"
} else {
    Write-Warning "  Resultado    : ALERTA — lag de $lagMinutes min excede RPO de $MaxSyncLagMinutes min"
}

Write-Output ""
Write-Output "--- ASR — Recovery Points ---"
$vault = Get-AzRecoveryServicesVault -ResourceGroupName $VaultResourceGroup -Name $VaultName
Set-AzRecoveryServicesAsrVaultContext -Vault $vault

$fabric    = Get-AzRecoveryServicesAsrFabric -Name "fabric-brazilsouth"
$container = Get-AzRecoveryServicesAsrProtectionContainer -Fabric $fabric -Name "container-brazilsouth"
$items     = Get-AzRecoveryServicesAsrReplicationProtectedItem -ProtectionContainer $container

foreach ($item in $items) {
    $rp        = Get-AzRecoveryServicesAsrRecoveryPoint -ReplicationProtectedItem $item | Select-Object -Last 1
    $rpAge     = if ($rp) { [int]((Get-Date) - $rp.RecoveryPointTime.ToUniversalTime()).TotalMinutes } else { 999 }
    $rpStatus  = if ($rpAge -le $MaxSyncLagMinutes) { "OK" } else { "ALERTA" }
    Write-Output "  $($item.FriendlyName): RP $($rp.RecoveryPointTime) (${rpAge}min atrás) — $rpStatus"
}
