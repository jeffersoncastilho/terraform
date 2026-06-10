################################################################################
# Script: Configura Replicação de VMs com Azure Site Recovery
# Uso: ./01-configure-replication.ps1 -VmName "vm-blog-castilho-01"
################################################################################

param(
    [Parameter(Mandatory = $true)]
    [string]$VmName,

    [string]$SourceResourceGroup = "rg-blog-castilho-workload-brazilsouth",
    [string]$VaultResourceGroup  = "rg-blog-castilho-network-eastus",
    [string]$VaultName           = "rsv-blog-castilho-eastus",
    [string]$TargetResourceGroup = "rg-blog-castilho-workload-eastus",
    [string]$CacheStorageAccount = "stblogcastilhocache"
)

Set-AzContext -SubscriptionId (Get-AzSubscription | Where-Object { $_.Name -eq "1" }).Id

$vault = Get-AzRecoveryServicesVault -ResourceGroupName $VaultResourceGroup -Name $VaultName
Set-AzRecoveryServicesAsrVaultContext -Vault $vault

$fabricBrazilsouth = Get-AzRecoveryServicesAsrFabric -Name "fabric-brazilsouth"
$fabricEastus      = Get-AzRecoveryServicesAsrFabric -Name "fabric-eastus"

$containerSource = Get-AzRecoveryServicesAsrProtectionContainer `
    -Fabric $fabricBrazilsouth -Name "container-brazilsouth"
$containerTarget = Get-AzRecoveryServicesAsrProtectionContainer `
    -Fabric $fabricEastus -Name "container-eastus"

$policy = Get-AzRecoveryServicesAsrPolicy -Name "policy-blog-castilho-5min"

$mapping = Get-AzRecoveryServicesAsrProtectionContainerMapping `
    -ProtectionContainer $containerSource `
    -Name "mapping-brazilsouth-to-eastus"

$vm         = Get-AzVM -ResourceGroupName $SourceResourceGroup -Name $VmName
$storageId  = (Get-AzStorageAccount -ResourceGroupName $VaultResourceGroup -Name $CacheStorageAccount).Id

$diskConfigs = @()
foreach ($disk in $vm.StorageProfile.OsDisk, $vm.StorageProfile.DataDisks) {
    if ($null -eq $disk) { continue }
    $diskConfigs += New-AzRecoveryServicesAsrAzureToAzureDiskReplicationConfig `
        -ManagedDisk `
        -LogStorageAccountId $storageId `
        -DiskId $disk.ManagedDisk.Id `
        -RecoveryResourceGroupId (Get-AzResourceGroup -Name $TargetResourceGroup).ResourceId `
        -RecoveryReplicaDiskAccountType "Premium_LRS" `
        -RecoveryTargetDiskAccountType "Premium_LRS"
}

$job = New-AzRecoveryServicesAsrReplicationProtectedItem `
    -AzureToAzure `
    -AzureVmId $vm.Id `
    -Name $VmName `
    -ProtectionContainerMapping $mapping `
    -AzureToAzureDiskReplicationConfiguration $diskConfigs `
    -RecoveryResourceGroupId (Get-AzResourceGroup -Name $TargetResourceGroup).ResourceId

Write-Host "Replicação iniciada. Job ID: $($job.Name)"
Write-Host "Acompanhe com: Get-AzRecoveryServicesAsrJob -Name $($job.Name)"
