################################################################################
# Script: Escala o cluster AKS secundário (East US) para capacidade de produção
################################################################################

param(
    [string]$ResourceGroup = "rg-blog-castilho-workload-eastus",
    [string]$ClusterName   = "aks-blog-castilho-eastus",
    [string]$NodePoolName  = "system",
    [int]$NodeCount        = 3
)

Write-Output "Escalando $ClusterName — pool: $NodePoolName → $NodeCount nós"

$job = Update-AzAksNodePool `
    -ResourceGroupName $ResourceGroup `
    -ClusterName $ClusterName `
    -Name $NodePoolName `
    -Count $NodeCount `
    -AsJob

Write-Output "Aguardando scale-out..."
$job | Wait-Job | Receive-Job

$cluster = Get-AzAksCluster -ResourceGroupName $ResourceGroup -Name $ClusterName
Write-Output "Cluster: $($cluster.Name) — Status: $($cluster.ProvisioningState)"

$pool = $cluster.AgentPoolProfiles | Where-Object { $_.Name -eq $NodePoolName }
Write-Output "Node pool '$NodePoolName': $($pool.Count) nós — $($pool.VmSize)"
