# terraform-managed-identity-modules

Módulo Terraform para criar uma **User-Assigned Managed Identity** no Azure.

## Uso

```hcl
module "identity" {
  source = "../../terraform-managed-identity-modules"

  name                = "id-app-exemplo"
  resource_group_name = module.rg.name
  location            = "brazilsouth"
  tags                = var.tags
}

# Atribuir papel no Key Vault
module "rbac_kv" {
  source = "../../terraform-role-assignment-modules"

  scope                = module.key_vault.key_vault_id
  role_definition_name = "Key Vault Secrets User"
  principal_id         = module.identity.principal_id
}
```

## Variáveis

| Nome | Tipo | Padrão | Descrição |
|------|------|--------|-----------|
| `name` | string | — | Nome da identidade |
| `resource_group_name` | string | — | Resource Group de destino |
| `location` | string | — | Região Azure |
| `tags` | map(string) | `{}` | Tags aplicadas ao recurso |

## Outputs

| Nome | Descrição |
|------|-----------|
| `id` | ID do recurso |
| `name` | Nome da identidade |
| `principal_id` | Object ID para role assignments |
| `client_id` | Client ID para autenticação |
| `tenant_id` | Tenant ID |
