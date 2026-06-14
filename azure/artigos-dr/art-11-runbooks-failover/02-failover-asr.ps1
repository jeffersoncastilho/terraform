################################################################################
# Script: Dispara Failover Planejado no Azure Site Recovery
# Uso: ./02-failover-asr.ps1 [-VmNames "vm1","vm2"]
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

foreach ($item in $protectedItems) {
    Write-Output "Iniciando failover: $($item.FriendlyName)"
    $job = Start-AzRecoveryServicesAsrPlannedFailoverJob `
        -ReplicationProtectedItem $item `
        -Direction PrimaryToRecovery

    Write-Output "  Job: $($job.Name) — aguardando..."
    do {
        Start-Sleep -Seconds 30
        $job = Get-AzRecoveryServicesAsrJob -Job $job
        Write-Output "  Status: $($job.State)"
    } while ($job.State -notin "Succeeded", "Failed", "Cancelled")

    if ($job.State -ne "Succeeded") {
        throw "Failover falhou para $($item.FriendlyName): $($job.State)"
    }
    Write-Output "  Failover concluído: $($item.FriendlyName)"
}
