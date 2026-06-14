################################################################################
# Script: Verifica registros de DNS Privado após failover
################################################################################

param(
    [string]$ResourceGroup = "rg-blog-castilho-network-brazilsouth"
)

$zonas = @(
    "privatelink.blob.core.windows.net",
    "privatelink.azurecr.io",
    "privatelink.azurewebsites.net"
)

foreach ($zona in $zonas) {
    Write-Output "=== $zona ==="
    try {
        $records = Get-AzPrivateDnsRecordSet -ResourceGroupName $ResourceGroup -ZoneName $zona -RecordType A
        foreach ($r in $records) {
            $ips = $r.Records | ForEach-Object { $_.Ipv4Address }
            Write-Output "  $($r.Name): $($ips -join ', ')"
        }
    } catch {
        Write-Warning "  Zona não encontrada: $zona"
    }
}

Write-Output ""
Write-Output "Verificação de DNS privado concluída"
Write-Output "Confirme que os IPs dos Private Endpoints apontam para a região correta"
