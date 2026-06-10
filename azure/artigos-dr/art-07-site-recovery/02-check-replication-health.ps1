################################################################################
# Script: Verifica Saúde da Replicação e RPO Atual
# Uso: ./02-check-replication-health.ps1
################################################################################

param(
    [string]$VaultResourceGroup = "rg-blog-castilho-network-eastus",
    [string]$VaultName          = "rsv-blog-castilho-eastus"
)

$vault = Get-AzRecoveryServicesVault -ResourceGroupName $VaultResourceGroup -Name $VaultName
Set-AzRecoveryServicesAsrVaultContext -Vault $vault

$fabric    = Get-AzRecoveryServicesAsrFabric -Name "fabric-brazilsouth"
$container = Get-AzRecoveryServicesAsrProtectionContainer `
    -Fabric $fabric -Name "container-brazilsouth"

$items = Get-AzRecoveryServicesAsrReplicationProtectedItem -ProtectionContainer $container

$items | Select-Object `
    FriendlyName,
    ReplicationHealth,
    @{ N = "RPO (min)"; E = { [math]::Round($_.LastRpoInSeconds / 60, 1) } },
    @{ N = "Último sync"; E = { $_.LastHeartbeat } } |
    Format-Table -AutoSize
