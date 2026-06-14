################################################################################
# Runbook: Orquestrador de Failover Multi-Região
# Dispara os scripts de failover na ordem correta
################################################################################

param(
    [Parameter(Mandatory = $false)]
    [object]$WebhookData
)

$SubscriptionId = $env:AZURE_SUBSCRIPTION_ID
if (-not $SubscriptionId) { throw "Defina AZURE_SUBSCRIPTION_ID antes de executar." }

Connect-AzAccount -Identity
Set-AzContext -SubscriptionId $SubscriptionId

$StartTime = Get-Date
Write-Output "[$(Get-Date -Format 'HH:mm:ss')] Failover iniciado"

function Invoke-Step {
    param([string]$Nome, [scriptblock]$Acao)
    $t = Get-Date
    Write-Output "[$(Get-Date -Format 'HH:mm:ss')] STEP: $Nome"
    try {
        & $Acao
        Write-Output "[$(Get-Date -Format 'HH:mm:ss')] OK: $Nome ($([int]((Get-Date) - $t).TotalSeconds)s)"
    } catch {
        Write-Error "FALHA em $Nome`: $_"
        throw
    }
}

Invoke-Step "1. NSGs — liberar tráfego na região secundária" {
    & "$PSScriptRoot/01-failover-network.ps1"
}

Invoke-Step "2. ASR — failover das VMs" {
    & "$PSScriptRoot/02-failover-asr.ps1"
}

Invoke-Step "3. AKS East US — scale-out" {
    & "$PSScriptRoot/03-failover-aks-scaleout.ps1"
}

Invoke-Step "4. Traffic Manager — desativar endpoint primário" {
    & "$PSScriptRoot/04-failover-traffic-manager.ps1"
}

Invoke-Step "5. DNS privado — verificar registros" {
    & "$PSScriptRoot/05-failover-dns.ps1"
}

$RTO = [int]((Get-Date) - $StartTime).TotalMinutes
Write-Output ""
Write-Output "=== FAILOVER CONCLUÍDO ==="
Write-Output "RTO medido: $RTO minutos"

& "$PSScriptRoot/notify-teams.ps1" -Mensagem "Failover concluído em $RTO minutos"
