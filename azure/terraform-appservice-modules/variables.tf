variable "plan_name" {
  description = "Nome do App Service Plan"
  type        = string
}

variable "app_name" {
  description = "Nome do Web App (precisa ser globalmente único no *.azurewebsites.net)"
  type        = string
}

variable "resource_group_name" {
  description = "Nome do Resource Group onde os recursos serão criados"
  type        = string
}

variable "location" {
  description = "Região do Azure"
  type        = string
  default     = "eastus"
}

variable "sku_name" {
  description = "SKU do App Service Plan (ex: B1, S1, P1v3)"
  type        = string
  default     = "B1"
}

variable "always_on" {
  description = "Mantém a aplicação sempre ativa (evita unload por inatividade)"
  type        = bool
  default     = true
}

variable "application_stack" {
  description = "Stack de runtime do Web App. Preencher só o(s) atributo(s) da stack usada. docker_image_name aceita o formato \"imagem:tag\"."
  type = object({
    node_version      = optional(string)
    python_version    = optional(string)
    dotnet_version    = optional(string)
    docker_image_name = optional(string)
  })
  default = {
    dotnet_version = "8.0"
  }
}

variable "app_settings" {
  description = "Application settings (variáveis de ambiente) do Web App"
  type        = map(string)
  default     = {}
}

variable "identity_type" {
  description = "Tipo de identidade gerenciada (SystemAssigned, UserAssigned, \"SystemAssigned, UserAssigned\") ou null pra não atribuir"
  type        = string
  default     = null
}

variable "tags" {
  description = "Tags a aplicar nos recursos"
  type        = map(string)
  default     = {}
}
