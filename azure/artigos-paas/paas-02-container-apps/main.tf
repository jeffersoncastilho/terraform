# Azure Container Apps: roda um container com scale-to-zero, ingress HTTPS
# gerenciado e billing por uso — sem gerenciar Kubernetes, sem VM.
# Série: artigos-paas | Artigo: paas-02-container-apps
#
# NÃO APLICADO nesta sessão (2026-09-03) — usuário ausente; Terraform validado
# (terraform validate + plan limpos), pendente de apply quando ele retomar.
# Custo baixo (consumo por vCPU-segundo, escala a zero quando ocioso) —
# provavelmente um dos mais baratos de testar depois do NAT Gateway.

resource "azurerm_resource_group" "containerapps" {
  name     = var.resource_group_name
  location = var.location
  tags     = var.tags
}

resource "azurerm_log_analytics_workspace" "containerapps" {
  name                = "log-containerapps-blog-castilho"
  resource_group_name = azurerm_resource_group.containerapps.name
  location            = azurerm_resource_group.containerapps.location
  sku                 = "PerGB2018"
  retention_in_days   = 30
  tags                = var.tags
}

resource "azurerm_container_app_environment" "this" {
  name                       = "cae-blog-castilho"
  resource_group_name       = azurerm_resource_group.containerapps.name
  location                   = azurerm_resource_group.containerapps.location
  log_analytics_workspace_id = azurerm_log_analytics_workspace.containerapps.id
  tags                       = var.tags
}

# Imagem de exemplo oficial da Microsoft (usada na própria documentação do
# Container Apps) — responde numa página HTML simples de "hello world".
resource "azurerm_container_app" "this" {
  name                         = "ca-blog-castilho"
  resource_group_name         = azurerm_resource_group.containerapps.name
  container_app_environment_id = azurerm_container_app_environment.this.id
  revision_mode                = "Single"

  template {
    min_replicas = 0
    max_replicas = 2

    container {
      name   = "hello-world"
      image  = "mcr.microsoft.com/azuredocs/containerapps-helloworld:latest"
      cpu    = 0.25
      memory = "0.5Gi"
    }
  }

  ingress {
    external_enabled = true
    target_port       = 80

    traffic_weight {
      percentage      = 100
      latest_revision = true
    }
  }

  tags = var.tags
}
