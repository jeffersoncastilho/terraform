variable "subscription_id" {
  type        = string
  description = "GUID da subscription onde a política será atribuída"
}

variable "location" {
  type        = string
  description = "Região usada para a managed identity da atribuição da policy"
  default     = "eastus"
}

variable "policy_name" {
  type        = string
  description = "Nome (id) da definição de policy"
  default     = "tag-governance-cost-center"
}

variable "policy_display_name" {
  type        = string
  description = "Nome de exibição da policy"
  default     = "Adicionar tag CostCenter em Resource Groups"
}

variable "assignment_name" {
  type        = string
  description = "Nome da atribuição da policy"
  default     = "assign-tag-governance-cost-center"
}

variable "tag_name" {
  type        = string
  description = "Nome da tag a ser garantida em todo Resource Group"
  default     = "CostCenter"
}

variable "tag_default_value" {
  type        = string
  description = "Valor padrão aplicado quando a tag estiver ausente"
  default     = "unassigned"
}
