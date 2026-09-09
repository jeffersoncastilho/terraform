# terraform-vpn-gateway-modules

Módulo Terraform para criação de um Azure VPN Gateway (`azurerm_virtual_network_gateway`, `type = "Vpn"`), reutilizável tanto para cenários **Site-to-Site** (sem `vpn_client_configuration`) quanto **Point-to-Site** (com `vpn_client_configuration` preenchido).

Cenários específicos de S2S (Local Network Gateway + conexão IPsec) ou de autenticação P2S via Azure AD/Entra ID/RADIUS ficam fora do módulo — compõem no chamador, junto com este módulo.

## Uso — Point-to-Site (autenticação por certificado)

```hcl
module "vpn_gateway_p2s" {
  source                = "../terraform-vpn-gateway-modules"
  name                  = "vpngw-p2s-meulab"
  resource_group_name   = module.rg.name
  location              = "eastus"
  gateway_subnet_id     = module.vnet.subnets["gateway"].id
  public_ip_address_id  = module.pip_vpngw.id

  vpn_client_configuration = {
    address_space         = ["172.16.201.0/24"]
    vpn_client_protocols  = ["OpenVPN"]
    vpn_auth_types        = ["Certificate"]
    root_certificates = [{
      name             = "P2SRootCert"
      public_cert_data = file("certs/root-cert-public-data.txt")
    }]
  }

  tags = { managed_by = "terraform" }
}
```

## Uso — Site-to-Site (sem P2S)

```hcl
module "vpn_gateway_s2s" {
  source                = "../terraform-vpn-gateway-modules"
  name                  = "vpngw-s2s-meulab"
  resource_group_name   = module.rg.name
  location              = "eastus"
  gateway_subnet_id     = module.vnet.subnets["gateway"].id
  public_ip_address_id  = module.pip_vpngw.id
  # vpn_client_configuration não informado = gateway sem P2S
}

resource "azurerm_local_network_gateway" "on_premises" {
  # ... configurado no chamador, é específico do cenário S2S
}
```

## Inputs

| Nome | Tipo | Obrigatório | Descrição |
|------|------|-------------|-----------|
| `name` | `string` | sim | Nome do Gateway |
| `resource_group_name` | `string` | sim | Resource Group do Gateway |
| `location` | `string` | sim | Região Azure |
| `gateway_subnet_id` | `string` | sim | ID da subnet `GatewaySubnet` |
| `public_ip_address_id` | `string` | sim | ID do Public IP associado (ver `terraform-public-ip-modules`) |
| `vpn_type` | `string` | não | `RouteBased` (padrão) ou `PolicyBased` |
| `sku` | `string` | não | `VpnGw1` (padrão) até `VpnGw5`/`AZ` |
| `generation` | `string` | não | `Generation1` (padrão) ou `Generation2` |
| `vpn_client_configuration` | `object` | não | Bloco P2S — `null` (padrão) desativa P2S |
| `tags` | `map(string)` | não | Tags aplicadas ao recurso |

## Outputs

| Nome | Descrição |
|------|-----------|
| `id` | ID do Virtual Network Gateway |
| `name` | Nome do Virtual Network Gateway |

## Requisitos

| Nome | Versão |
|------|--------|
| Terraform | >= 1.5 |
| azurerm | ~> 4.0 |
