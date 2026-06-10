################################################################################
# Script: Executa Test Failover (não impacta produção)
# Uso: ./03-test-failover.ps1 -VmName "vm-blog-castilho-01"
################################################################################

param(
    [Parameter(Mandatory = $true)]
    [string]$VmName,

    [string]$VaultResourceGroup  = "rg-blog-castilho-network-eastus",
    [string]$VaultName           = "rsv-blog-castilho-eastus",
    [string]$TestNetworkId       = ""  # vnet de isolamento para o teste
)

$vault = Get-AzRecoveryServicesVault -ResourceGroupName $VaultResourceGroup -Name $VaultName
Set-AzRecoveryServicesAsrVaultContext -Vault $vault

$fabric    = Get-AzRecoveryServicesAsrFabric -Name "fabric-brazilsouth"
$container = Get-AzRecoveryServicesAsrProtectionContainer `
    -Fabric $fabric -Name "container-brazilsouth"

$item = Get-AzRecoveryServicesAsrReplicationProtectedItem `
    -ProtectionContainer $container -FriendlyName $VmName

$recoveryPoint = (Get-AzRecoveryServicesAsrRecoveryPoint -ReplicationProtectedItem $item |
    Sort-Object RecoveryPointTime -Descending | Select-Object -First 1)

Write-Host "Iniciando Test Failover para $VmName..."
Write-Host "Recovery Point: $($recoveryPoint.RecoveryPointTime)"

$job = Start-AzRecoveryServicesAsrTestFailoverJob `
    -ReplicationProtectedItem $item `
    -Direction PrimaryToRecovery `
    -AzureVMNetworkId $TestNetworkId `
    -RecoveryPoint $recoveryPoint

Write-Host "Test Failover iniciado. Job: $($job.Name)"
Write-Host "Após validar a VM em East US, execute: ./04-cleanup-test-failover.ps1 -VmName $VmName"
