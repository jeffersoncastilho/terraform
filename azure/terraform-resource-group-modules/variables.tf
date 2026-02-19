# variables.tf

variable "resource_type" {
  description = "Abreviação do tipo de recurso (ex: rg, st, vnet, vm, aks)."
  type        = string
}

variable "project_name" {
  description = "Nome do projeto, aplicação ou carga de trabalho."
  type        = string
}

variable "environment" {
  description = "Ambiente de implantação (ex: dev, hml, prod)."
  type        = string
}

variable "location_suffix" {
  description = "Abreviação da região (ex: brs, eus2). Opcional."
  type        = string
  default     = ""
}

variable "index" {
  description = "Sufixo numérico ou identificador de instância (ex: 001). Opcional."
  type        = string
  default     = ""
}

variable "separator" {
  description = "Separador a ser utilizado entre os componentes do nome."
  type        = string
  default     = "-"
}

variable "location" {
  description = "A localização (região) do Azure onde o Grupo de Recursos será criado."
  type        = string
}

variable "tags" {
  description = "Um mapa de tags a serem aplicadas ao Grupo de Recursos."
  type        = map(string)
  default     = {}
}