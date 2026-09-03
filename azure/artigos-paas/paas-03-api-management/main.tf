# API Management, tier Consumption: publica uma API interna (ou de terceiros)
# atrás de um gateway com throttling, chave de API e transformação de
# requisição/resposta, sem precisar manter servidor de gateway próprio.
# Série: artigos-paas | Artigo: paas-03-api-management
#
# NÃO APLICADO nesta sessão (2026-09-03) — usuário ausente; Terraform validado
# (terraform validate + plan limpos), pendente de apply quando ele retomar.
# Tier Consumption escolhido de propósito: provisiona em ~15min (bem mais
# rápido que Developer/Standard, que levam 30-45min) e cobra por chamada,
# sem taxa fixa mensal alta.

resource "azurerm_resource_group" "apim" {
  name     = var.resource_group_name
  location = var.location
  tags     = var.tags
}

resource "azurerm_api_management" "this" {
  name                = "apim-blog-castilho"
  resource_group_name = azurerm_resource_group.apim.name
  location            = azurerm_resource_group.apim.location
  publisher_name      = var.publisher_name
  publisher_email     = var.publisher_email
  sku_name            = "Consumption_0"
  tags                = var.tags
}

# API de exemplo publicada apontando pra um backend público conhecido
# (httpbin.org) — só pra demonstrar o gateway funcionando de ponta a ponta
# sem precisar manter um backend próprio.
resource "azurerm_api_management_api" "example" {
  name                = "httpbin-api"
  resource_group_name = azurerm_resource_group.apim.name
  api_management_name = azurerm_api_management.this.name
  revision            = "1"
  display_name        = "HTTPBin (exemplo)"
  path                = "httpbin"
  protocols           = ["https"]
  service_url         = "https://httpbin.org"
}

resource "azurerm_api_management_api_operation" "get_ip" {
  operation_id        = "get-ip"
  api_name            = azurerm_api_management_api.example.name
  api_management_name = azurerm_api_management.this.name
  resource_group_name = azurerm_resource_group.apim.name
  display_name        = "Get IP"
  method              = "GET"
  url_template        = "/ip"
}

# Policy simples de exemplo: adiciona um cabeçalho de resposta customizado,
# só pra provar que o APIM está de fato interceptando e transformando o
# tráfego, não apenas repassando.
resource "azurerm_api_management_api_policy" "example" {
  api_name            = azurerm_api_management_api.example.name
  api_management_name = azurerm_api_management.this.name
  resource_group_name = azurerm_resource_group.apim.name

  xml_content = <<XML
<policies>
  <inbound>
    <base />
  </inbound>
  <backend>
    <base />
  </backend>
  <outbound>
    <base />
    <set-header name="X-Gateway" exists-action="override">
      <value>apim-blog-castilho</value>
    </set-header>
  </outbound>
  <on-error>
    <base />
  </on-error>
</policies>
XML
}
