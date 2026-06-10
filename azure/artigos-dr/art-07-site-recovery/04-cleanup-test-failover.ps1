################################################################################
# Script: Remove Recursos Criados pelo Test Failover
# Uso: ./04-cleanup-test-failover.ps1 -VmName "vm-blog-castilho-01"
################################################################################

param(
    [Parameter(Mandatory = $true)]
    [string]$VmName,

    [string]$VaultResourceGroup = "rg-blog-castilho-network-eastus",
    [string]$VaultName          = "rsv-blog-castilho-eastus"
)

$vault = Get-AzRecoveryServicesVault -ResourceGroupName $VaultResourceGroup -Name $VaultName
Set-AzRecoveryServicesAsrVaultContext -Vault $vault

$fabric    = Get-AzRecoveryServicesAsrFabric -Name "fabric-brazilsouth"
$container = Get-AzRecoveryServicesAsrProtectionContainer `
    -Fabric $fabric -Name "container-brazilsouth"

$item = Get-AzRecoveryServicesAsrReplicationProtectedItem `
    -ProtectionContainer $container -FriendlyName $VmName

$job = Start-AzRecoveryServicesAsrTestFailoverCleanupJob `
    -ReplicationProtectedItem $item `
    -Comment "Cleanup após validação do Test Failover"

Write-Host "Cleanup do Test Failover iniciado. Job: $($job.Name)"
