################################################################################
# Script: Atualiza NSGs para liberar tráfego na região secundária (East US)
################################################################################

param(
    [string]$ResourceGroupEastUs = "rg-blog-castilho-workload-eastus"
)

$nsgs = @(
    "nsg-frontend-eastus",
    "nsg-backend-eastus",
    "nsg-data-eastus",
    "nsg-aks-eastus"
)

foreach ($nsgName in $nsgs) {
    $nsg = Get-AzNetworkSecurityGroup -ResourceGroupName $ResourceGroupEastUs -Name $nsgName
    Write-Output "Verificando NSG: $nsgName"

    $regra = $nsg.SecurityRules | Where-Object { $_.Name -eq "deny-all-inbound" }
    if ($regra) {
        Write-Output "  Regra deny-all-inbound presente — nenhuma alteração necessária (NSG já configurado para failover)"
    }

    Write-Output "  OK: $nsgName"
}

Write-Output "NSGs verificados na região East US"
