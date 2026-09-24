variable "name" {
  description = "Nome da Virtual Network"
  type        = string
}

variable "resource_group_name" {
  description = "Nome do Resource Group onde a VNet será criada"
  type        = string
}

variable "location" {
  description = "Região Azure (ex: brazilsouth, eastus)"
  type        = string
}

variable "address_space" {
  description = "Lista de blocos CIDR da VNet"
  type        = list(string)
}

variable "subnets" {
  description = "Lista de subnets a criar na VNet"
  type = list(object({
    key                                            = string
    name                                           = string
    address_prefixes                               = list(string)
    private_endpoint_network_policies              = optional(string)
    private_link_service_network_policies_enabled  = optional(bool)
    delegation = optional(object({
      name                        = string
      service_delegation_name    = string
      service_delegation_actions = list(string)
    }))
  }))
  default = []
}

variable "ddos_protection_plan_id" {
  description = "ID de um DDoS Protection Plan (ver terraform-ddos-protection-modules) — null (padrão) não associa nenhum plano"
  type        = string
  default     = null
}

variable "tags" {
  description = "Tags aplicadas à VNet"
  type        = map(string)
  default     = {}
}
