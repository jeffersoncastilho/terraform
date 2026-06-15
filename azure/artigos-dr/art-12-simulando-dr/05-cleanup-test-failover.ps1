################################################################################
# Script: Remove recursos do Test Failover (cleanup pós-drill)
# Uso: ./05-cleanup-test-failover.ps1 [-VmNames "vm1","vm2"]
################################################################################

param(
    [string[]]$VmNames,
    [string]$VaultResourceGroup = "rg-blog-castilho-network-eastus",
    [string]$VaultName          = "rsv-blog-castilho-eastus"
)

$vault = Get-AzRecoveryServicesVault -ResourceGroupName $VaultResourceGroup -Name $VaultName
Set-AzRecoveryServicesAsrVaultContext -Vault $vault

$fabricBrazilsouth = Get-AzRecoveryServicesAsrFabric -Name "fabric-brazilsouth"
$container         = Get-AzRecoveryServicesAsrProtectionContainer `
    -Fabric $fabricBrazilsouth -Name "container-brazilsouth"

$protectedItems = Get-AzRecoveryServicesAsrReplicationProtectedItem -ProtectionContainer $container

if ($VmNames) {
    $protectedItems = $protectedItems | Where-Object { $_.FriendlyName -in $VmNames }
}

Write-Output "=== CLEANUP DO TEST FAILOVER — $(Get-Date -Format 'HH:mm:ss') ==="

foreach ($item in $protectedItems) {
    Write-Output "Removendo Test Failover: $($item.FriendlyName)"
    $job = Start-AzRecoveryServicesAsrTestFailoverCleanupJob `
        -ReplicationProtectedItem $item `
        -Comment "Cleanup pós DR Drill $(Get-Date -Format 'yyyy-MM-dd')"

    do {
        Start-Sleep -Seconds 20
        $job = Get-AzRecoveryServicesAsrJob -Job $job
        Write-Output "  Status: $($job.State)"
    } while ($job.State -notin "Succeeded", "Failed", "Cancelled")

    Write-Output "  $($item.FriendlyName): cleanup $($job.State)"
}

Write-Output ""
Write-Output "Cleanup concluído — ambiente de produção não foi afetado"
