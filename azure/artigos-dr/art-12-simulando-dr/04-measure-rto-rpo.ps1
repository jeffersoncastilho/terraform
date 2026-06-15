################################################################################
# Script: Mede RTO e RPO reais do DR Drill e gera relatório
# Uso: ./04-measure-rto-rpo.ps1 -StartTime "2026-06-03 10:00:00" -EndTime "2026-06-03 10:34:00"
################################################################################

param(
    [Parameter(Mandatory = $true)]
    [datetime]$StartTime,

    [datetime]$EndTime = (Get-Date),

    [string]$StorageResourceGroup = "rg-blog-castilho-workload-brazilsouth",
    [string]$StorageName          = "stblogcastilhobrazil",
    [string]$VaultResourceGroup   = "rg-blog-castilho-network-eastus",
    [string]$VaultName            = "rsv-blog-castilho-eastus",

    [int]$RtoObjetivoMin = 60,
    [int]$RpoObjetivoMin = 5
)

$rtoMedido = [int]($EndTime - $StartTime).TotalMinutes

$storage = Get-AzStorageAccount -ResourceGroupName $StorageResourceGroup -Name $StorageName
$stats   = $storage | Get-AzStorageAccountGeoReplicationStats
$rpoMedido = if ($stats.LastSyncTime) {
    [math]::Round(((Get-Date) - $stats.LastSyncTime.ToUniversalTime()).TotalMinutes, 1)
} else { "N/A" }

$rtoStatus = if ($rtoMedido -le $RtoObjetivoMin) { "DENTRO DO OBJETIVO" } else { "EXCEDIDO" }
$rpoStatus = if ($rpoMedido -le $RpoObjetivoMin)  { "DENTRO DO OBJETIVO" } else { "EXCEDIDO" }

$relatorio = @"
╔══════════════════════════════════════════════════╗
║         DR DRILL REPORT — blog-castilho          ║
╠══════════════════════════════════════════════════╣
║ Data/Hora Início : $($StartTime.ToString('yyyy-MM-dd HH:mm:ss'))
║ Data/Hora Fim    : $($EndTime.ToString('yyyy-MM-dd HH:mm:ss'))
╠══════════════════════════════════════════════════╣
║ RTO Objetivo : $RtoObjetivoMin minutos
║ RTO Medido   : $rtoMedido minutos
║ RTO Status   : $rtoStatus
╠══════════════════════════════════════════════════╣
║ RPO Objetivo : $RpoObjetivoMin minutos
║ RPO Medido   : $rpoMedido minutos
║ RPO Status   : $rpoStatus
╚══════════════════════════════════════════════════╝
"@

Write-Output $relatorio

$reportFile = "dr-drill-report-$(Get-Date -Format 'yyyyMMdd-HHmm').txt"
$relatorio | Out-File -FilePath $reportFile -Encoding UTF8
Write-Output "Relatório salvo em: $reportFile"
