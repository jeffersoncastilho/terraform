################################################################################
# Script: Inicia Test Failover no ASR (VMs isoladas — sem impacto em produção)
# Uso: ./01-start-test-failover.ps1 [-VmNames "vm1","vm2"]
################################################################################

param(
    [string[]]$VmNames,
    [string]$VaultResourceGroup = "rg-blog-castilho-network-eastus",
    [string]$VaultName          = "rsv-blog-castilho-eastus",
    [string]$TestNetworkId      = ""
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

Write-Output "=== INICIANDO TEST FAILOVER — $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss') ==="
Write-Output "VMs no escopo: $($protectedItems.Count)"
Write-Output ""

$jobs = @()
foreach ($item in $protectedItems) {
    Write-Output "Test Failover: $($item.FriendlyName)"

    $params = @{
        ReplicationProtectedItem = $item
        Direction                = "PrimaryToRecovery"
    }
    if ($TestNetworkId) { $params.TestNetworkId = $TestNetworkId }

    $job = Start-AzRecoveryServicesAsrTestFailoverJob @params
    $jobs += [pscustomobject]@{ VM = $item.FriendlyName; Job = $job }
    Write-Output "  Job iniciado: $($job.Name)"
}

Write-Output ""
Write-Output "Aguardando todos os Test Failovers..."
foreach ($entry in $jobs) {
    do {
        Start-Sleep -Seconds 30
        $j = Get-AzRecoveryServicesAsrJob -Job $entry.Job
        Write-Output "  $($entry.VM): $($j.State)"
    } while ($j.State -notin "Succeeded", "Failed", "Cancelled")

    if ($j.State -ne "Succeeded") {
        Write-Error "Test Failover falhou para $($entry.VM): $($j.State)"
    } else {
        Write-Output "  $($entry.VM): CONCLUÍDO"
    }
}

Write-Output ""
Write-Output "Test Failover concluído. VMs de teste rodando em East US de forma isolada."
Write-Output "Execute 02-validate-connectivity.ps1 para validar, depois 05-cleanup-test-failover.ps1"
