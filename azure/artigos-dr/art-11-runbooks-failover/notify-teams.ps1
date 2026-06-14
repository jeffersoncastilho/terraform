################################################################################
# Script: Envia notificação para canal Teams via webhook
# Uso: ./notify-teams.ps1 -Mensagem "Failover concluído em 28 minutos"
################################################################################

param(
    [Parameter(Mandatory = $true)]
    [string]$Mensagem,

    [string]$WebhookUri = $env:TEAMS_WEBHOOK_URI
)

if (-not $WebhookUri) {
    Write-Warning "TEAMS_WEBHOOK_URI não configurado — notificação ignorada"
    return
}

$body = @{
    "@type"      = "MessageCard"
    "@context"   = "http://schema.org/extensions"
    summary      = "DR Failover — blog-castilho"
    themeColor   = "0078D4"
    title        = "DR Failover — blog-castilho"
    text         = $Mensagem
    sections     = @(@{
        facts = @(
            @{ name = "Ambiente"; value = "blog-castilho" }
            @{ name = "Horário";  value = (Get-Date -Format "yyyy-MM-dd HH:mm:ss UTC") }
        )
    })
} | ConvertTo-Json -Depth 5

Invoke-RestMethod -Uri $WebhookUri -Method Post -Body $body -ContentType "application/json"
Write-Output "Notificação enviada para Teams"
