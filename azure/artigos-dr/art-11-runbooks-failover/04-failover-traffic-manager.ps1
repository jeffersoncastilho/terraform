################################################################################
# Script: Desativa o endpoint primário no Traffic Manager durante o failover
################################################################################

param(
    [string]$ResourceGroup   = "rg-blog-castilho-workload-brazilsouth",
    [string]$ProfileName     = "tm-blog-castilho",
    [string]$EndpointName    = "endpoint-brazilsouth"
)

$profile = Get-AzTrafficManagerProfile -ResourceGroupName $ResourceGroup -Name $ProfileName

Write-Output "=== Estado ANTES ==="
foreach ($ep in $profile.Endpoints) {
    Write-Output "  $($ep.Name): $($ep.EndpointStatus)"
}

$endpoint = Get-AzTrafficManagerEndpoint `
    -ResourceGroupName $ResourceGroup `
    -ProfileName $ProfileName `
    -Type AzureEndpoints `
    -Name $EndpointName

Disable-AzTrafficManagerEndpoint -TrafficManagerEndpoint $endpoint -Force
Write-Output ""
Write-Output "Endpoint '$EndpointName' desativado"

$profile = Get-AzTrafficManagerProfile -ResourceGroupName $ResourceGroup -Name $ProfileName
Write-Output ""
Write-Output "=== Estado APÓS ==="
foreach ($ep in $profile.Endpoints) {
    Write-Output "  $($ep.Name): $($ep.EndpointStatus)"
}
