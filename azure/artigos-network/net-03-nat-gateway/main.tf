# Azure NAT Gateway: saída de internet controlada e previsível — todo tráfego
# de saída da subnet passa a usar um IP público fixo e conhecido, em vez do
# esquema de portas SNAT dinâmico (e sujeito a esgotamento) do balanceador padrão.
# Série: artigos-network | Artigo: net-03-nat-gateway

resource "azurerm_resource_group" "natgw" {
  name     = var.resource_group_name
  location = var.location
  tags     = var.tags
}

# ── Rede: VNet + subnet delegada a Container Instances ───────────────────────

resource "azurerm_virtual_network" "natgw" {
  name                = "vnet-natgw-blog-castilho"
  resource_group_name = azurerm_resource_group.natgw.name
  location            = azurerm_resource_group.natgw.location
  address_space       = [var.vnet_address_space]
  tags                = var.tags
}

resource "azurerm_subnet" "natgw" {
  name                 = "snet-natgw"
  resource_group_name  = azurerm_resource_group.natgw.name
  virtual_network_name = azurerm_virtual_network.natgw.name
  address_prefixes     = [var.subnet_prefix]

  delegation {
    name = "aci-delegation"
    service_delegation {
      name    = "Microsoft.ContainerInstance/containerGroups"
      actions = ["Microsoft.Network/virtualNetworks/subnets/action"]
    }
  }
}

# ── NAT Gateway com IP público fixo ───────────────────────────────────────────

resource "azurerm_public_ip" "natgw" {
  name                = "pip-natgw-blog-castilho"
  resource_group_name = azurerm_resource_group.natgw.name
  location            = azurerm_resource_group.natgw.location
  allocation_method   = "Static"
  sku                 = "Standard"
  tags                = var.tags
}

resource "azurerm_nat_gateway" "this" {
  name                    = "natgw-blog-castilho"
  resource_group_name     = azurerm_resource_group.natgw.name
  location                = azurerm_resource_group.natgw.location
  sku_name                = "Standard"
  idle_timeout_in_minutes = 4
  tags                    = var.tags
}

resource "azurerm_nat_gateway_public_ip_association" "this" {
  nat_gateway_id       = azurerm_nat_gateway.this.id
  public_ip_address_id = azurerm_public_ip.natgw.id
}

resource "azurerm_subnet_nat_gateway_association" "this" {
  subnet_id      = azurerm_subnet.natgw.id
  nat_gateway_id = azurerm_nat_gateway.this.id
}

# ── Container de teste: faz uma requisição de saída e loga o IP público visto ─
# Roda uma vez (restart_policy = Never) e termina — sem custo de VM parada.

resource "azurerm_container_group" "test" {
  name                = "aci-natgw-test"
  resource_group_name = azurerm_resource_group.natgw.name
  location            = azurerm_resource_group.natgw.location
  os_type             = "Linux"
  restart_policy      = "Never"
  ip_address_type     = "Private"
  subnet_ids          = [azurerm_subnet.natgw.id]

  # Imagem do Microsoft Container Registry em vez de Docker Hub: pull anônimo
  # do Docker Hub a partir de IPs do Azure esbarra com frequência em rate
  # limit (409 RegistryErrorResponse) — mcr.microsoft.com não tem esse problema.
  container {
    name   = "curl-egress-ip"
    image  = "mcr.microsoft.com/azure-cli:latest"
    cpu    = "0.5"
    memory = "0.5"

    # Um Container Instance com VNet integration (subnet_ids) exige pelo menos
    # uma porta declarada no ip_address, mesmo sem precisar expor nada — sem
    # isso a API rejeita com "MissingIpAddressPorts".
    ports {
      port     = 80
      protocol = "TCP"
    }

    commands = ["curl", "-s", "https://api.ipify.org", "--max-time", "10"]
  }

  tags = var.tags

  depends_on = [azurerm_subnet_nat_gateway_association.this]
}
