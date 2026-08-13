variable "name" {
  description = "Nome da User-Assigned Managed Identity."
  type        = string
}

variable "resource_group_name" {
  description = "Nome do Resource Group onde a identidade será criada."
  type        = string
}

variable "location" {
  description = "Região do Azure."
  type        = string
}

variable "tags" {
  description = "Tags aplicadas à identidade."
  type        = map(string)
  default     = {}
}
