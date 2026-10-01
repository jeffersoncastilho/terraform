# terraform-appgw-waf-modules

Módulo Terraform para um Application Gateway v2 (SKU `WAF_v2`) com WAF Policy (OWASP managed rules) — um listener HTTP, uma regra de roteamento `Basic`, um backend por FQDN ou IP. Cobre o cenário mais comum de exemplo/tutorial; topologias com múltiplos listeners/regras/backends exigem composição adicional no chamador.

## Uso — backend por FQDN (ex: Storage Static Website)

```hcl
module "appgw_waf" {
  source                 = "../terraform-appgw-waf-modules"
  name                   = "agw-meulab"
  waf_policy_name        = "wafpolicy-meulab"
  resource_group_name    = module.rg.name
  location               = "eastus"
  gateway_subnet_id      = module.vnet.subnets["appgw"].id
  public_ip_address_id   = module.pip_appgw.id
  backend_fqdns          = [module.storage.primary_web_endpoint]

  tags = { managed_by = "terraform" }
}
```

## Inputs

| Nome | Tipo | Obrigatório | Descrição |
|------|------|-------------|-----------|
| `name` | `string` | sim | Nome do Application Gateway |
| `waf_policy_name` | `string` | sim | Nome da WAF Policy |
| `resource_group_name` | `string` | sim | Resource Group dos recursos |
| `location` | `string` | sim | Região Azure |
| `gateway_subnet_id` | `string` | sim | Subnet dedicada ao Application Gateway |
| `public_ip_address_id` | `string` | sim | Public IP do frontend |
| `waf_mode` | `string` | não | `Prevention` (padrão) ou `Detection` |
| `owasp_version` | `string` | não | Versão do OWASP CRS (padrão `3.2`) |
| `autoscale_min_capacity` / `autoscale_max_capacity` | `number` | não | Padrão `0`/`2` |
| `frontend_port` | `number` | não | Porta do listener (padrão `80`) |
| `backend_fqdns` | `list(string)` | não | FQDNs do backend (use isto OU `backend_ip_addresses`) |
| `backend_ip_addresses` | `list(string)` | não | IPs do backend |
| `backend_port` / `backend_protocol` | | não | Padrão `443`/`Https` |
| `backend_pick_host_name` | `bool` | não | Padrão `true` |
| `tags` | `map(string)` | não | Tags aplicadas aos recursos |

## Outputs

| Nome | Descrição |
|------|-----------|
| `id` | ID do Application Gateway |
| `waf_policy_id` | ID da WAF Policy |

## Requisitos

| Nome | Versão |
|------|--------|
| Terraform | >= 1.5 |
| azurerm | ~> 4.0 |
