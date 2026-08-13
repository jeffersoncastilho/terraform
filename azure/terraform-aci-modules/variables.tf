variable "name" {
  description = "Nome do Container Group"
  type        = string
}

variable "resource_group_name" {
  description = "Resource Group onde o Container Group será criado"
  type        = string
}

variable "location" {
  description = "Região Azure do Container Group"
  type        = string
}

variable "restart_policy" {
  description = "Política de restart (Always, Never, OnFailure)"
  type        = string
  default     = "Always"

  validation {
    condition     = contains(["Always", "Never", "OnFailure"], var.restart_policy)
    error_message = "restart_policy deve ser Always, Never ou OnFailure."
  }
}

variable "container_name" {
  description = "Nome do container dentro do grupo"
  type        = string
}

variable "image" {
  description = "Imagem Docker do container (ex: confluentinc/cp-kafka-connect:7.6.0)"
  type        = string
}

variable "cpu" {
  description = "CPU alocada ao container (vCPUs)"
  type        = string
  default     = "1.0"
}

variable "memory" {
  description = "Memória alocada ao container (GB)"
  type        = string
  default     = "2.0"
}

variable "ports" {
  description = "Portas expostas pelo container"
  type = list(object({
    port     = number
    protocol = string
  }))
  default = []
}

variable "environment_variables" {
  description = "Variáveis de ambiente não-sensíveis"
  type        = map(string)
  default     = {}
}

variable "secure_environment_variables" {
  description = "Variáveis de ambiente sensíveis (não aparecem nos logs ou no state)"
  type        = map(string)
  sensitive   = true
  default     = {}
}

variable "image_registry_credentials" {
  description = "Credenciais de registry privado para pull da imagem (opcional; usar com ACR ou Docker Hub autenticado)"
  type = list(object({
    server   = string
    username = string
    password = string
  }))
  default   = []
  sensitive = true
}

variable "tags" {
  description = "Tags aplicadas ao Container Group"
  type        = map(string)
  default     = {}
}
