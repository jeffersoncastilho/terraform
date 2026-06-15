################################################################################
# Script: Valida conectividade dos componentes após Test Failover
################################################################################

param(
    [string]$SubscriptionId = $env:AZURE_SUBSCRIPTION_ID
)

Set-AzContext -SubscriptionId $SubscriptionId

$resultados = @()

function Test-AzResource {
    param([string]$Nome, [scriptblock]$Teste)
    try {
        $ok = & $Teste
        $resultados += [pscustomobject]@{ Componente = $Nome; Status = if ($ok) { "OK" } else { "FALHA" }; Detalhe = "" }
        Write-Output "  [$(if ($ok) { 'OK  ' } else { 'FAIL' })] $Nome"
    } catch {
        $resultados += [pscustomobject]@{ Componente = $Nome; Status = "ERRO"; Detalhe = $_.Exception.Message }
        Write-Output "  [ERRO] $Nome`: $_"
    }
}

Write-Output "=== VALIDAÇÃO DE CONECTIVIDADE — $(Get-Date -Format 'HH:mm:ss') ==="
Write-Output ""

Test-AzResource "AKS East US — API server" {
    $cluster = Get-AzAksCluster -ResourceGroupName "rg-blog-castilho-workload-eastus" -Name "aks-blog-castilho-eastus"
    $cluster.ProvisioningState -eq "Succeeded"
}

Test-AzResource "Storage Account — geo-replication" {
    $storage = Get-AzStorageAccount -ResourceGroupName "rg-blog-castilho-workload-brazilsouth" -Name "stblogcastilhobrazil"
    $stats = $storage | Get-AzStorageAccountGeoReplicationStats
    $stats.GeoReplicationStatus -eq "Live"
}

Test-AzResource "Traffic Manager — endpoint East US" {
    $ep = Get-AzTrafficManagerEndpoint `
        -ResourceGroupName "rg-blog-castilho-workload-brazilsouth" `
        -ProfileName "tm-blog-castilho" `
        -Type AzureEndpoints `
        -Name "endpoint-eastus"
    $ep.EndpointStatus -eq "Enabled"
}

Test-AzResource "Azure Firewall East US — provisionado" {
    $afw = Get-AzFirewall -ResourceGroupName "rg-blog-castilho-network-eastus" -Name "afw-blog-castilho-eastus"
    $afw.ProvisioningState -eq "Succeeded"
}

Write-Output ""
Write-Output "=== RESUMO ==="
$resultados | Format-Table -AutoSize

$falhas = $resultados | Where-Object { $_.Status -ne "OK" }
if ($falhas.Count -eq 0) {
    Write-Output "Todos os componentes validados com sucesso"
} else {
    Write-Warning "$($falhas.Count) componente(s) com problema"
}
