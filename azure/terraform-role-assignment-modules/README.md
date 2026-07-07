# terraform-role-assignment-modules

Módulo Terraform para criar um **Azure RBAC Role Assignment** em qualquer escopo.

## Uso

```hcl
# Atribuir 'Contributor' à Managed Identity no Resource Group
module "rbac_rg" {
  source = "../../terraform-role-assignment-modules"

  scope                            = module.rg.id
  role_definition_name             = "Contributor"
  principal_id                     = module.identity.principal_id
  skip_service_principal_aad_check = true
}

# Atribuir 'Key Vault Secrets User' no Key Vault
module "rbac_kv" {
  source = "../../terraform-role-assignment-modules"

  scope                = module.key_vault.key_vault_id
  role_definition_name = "Key Vault Secrets User"
  principal_id         = module.identity.principal_id
}

# Atribuir 'Storage Blob Data Contributor' em uma Storage Account
module "rbac_storage" {
  source = "../../terraform-role-assignment-modules"

  scope                = module.storage.id
  role_definition_name = "Storage Blob Data Contributor"
  principal_id         = module.identity.principal_id
}
```

## Variáveis

| Nome | Tipo | Padrão | Descrição |
|------|------|--------|-----------|
| `scope` | string | — | ID do recurso, RG ou subscription |
| `role_definition_name` | string | — | Nome do papel Azure RBAC |
| `principal_id` | string | — | Object ID do principal |
| `skip_service_principal_aad_check` | bool | `false` | Evita race condition para identidades recém-criadas |

## Outputs

| Nome | Descrição |
|------|-----------|
| `id` | ID do role assignment |
| `role_definition_id` | ID da role definition |
| `principal_id` | Principal ao qual o papel foi atribuído |

## Papéis comuns

| Papel | Uso |
|-------|-----|
| `Contributor` | Gerenciar recursos no escopo (resource group, recurso) |
| `Key Vault Secrets User` | Leitura de secrets pela Managed Identity |
| `Storage Blob Data Contributor` | Acesso a dados em ADLS Gen2 / Blob |
| `Monitoring Reader` | Leitura de métricas |
