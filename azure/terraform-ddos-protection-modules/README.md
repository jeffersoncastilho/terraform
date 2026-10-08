# terraform-ddos-protection-modules

Módulo Terraform para um DDoS Protection Plan (`azurerm_network_ddos_protection_plan`) — a associação com VNets e Public IPs é feita nos módulos consumidores (`terraform-virtual-network-modules` via `ddos_protection_plan_id`, `terraform-public-ip-modules` via `ddos_protection_mode`).

> **Custo:** o plano tem taxa fixa mensal alta (cobrada proporcionalmente por hora). Não deixar aplicado além do tempo necessário para validação.

## Uso

```hcl
module "ddos_plan" {
  source              = "../terraform-ddos-protection-modules"
  name                = "ddosplan-meulab"
  resource_group_name = module.rg.name
  location             = "eastus"

  tags = { managed_by = "terraform" }
}

module "vnet" {
  source                 = "../terraform-virtual-network-modules"
  # ...
  ddos_protection_plan_id = module.ddos_plan.id
}
```

## Inputs

| Nome | Tipo | Obrigatório | Descrição |
|------|------|-------------|-----------|
| `name` | `string` | sim | Nome do plano |
| `resource_group_name` | `string` | sim | Resource Group do plano |
| `location` | `string` | sim | Região Azure |
| `tags` | `map(string)` | não | Tags aplicadas ao recurso |

## Outputs

| Nome | Descrição |
|------|-----------|
| `id` | ID do DDoS Protection Plan |

## Requisitos

| Nome | Versão |
|------|--------|
| Terraform | >= 1.5 |
| azurerm | ~> 4.0 |
