variable "name" {
  description = "Nome do Azure Virtual Network Manager"
  type        = string
}

variable "resource_group_name" {
  description = "Resource Group onde o Network Manager será criado"
  type        = string
}

variable "location" {
  description = "Região Azure do Network Manager"
  type        = string
}

variable "subscription_id" {
  description = "ID da subscription no escopo de governança do Network Manager"
  type        = string
}

variable "scope_accesses" {
  description = "Capacidades habilitadas (Connectivity, SecurityAdmin, Routing)"
  type        = list(string)
  default     = ["Connectivity", "SecurityAdmin"]
}

variable "network_group_name" {
  description = "Nome do grupo de rede que reúne as VNets governadas"
  type        = string
}

variable "member_vnet_ids" {
  description = "Map de VNets (chave arbitrária => ID da VNet) que entram no grupo como membros estáticos"
  type        = map(string)
}

variable "enable_connectivity_configuration" {
  description = "Cria a Connectivity Configuration (topologia entre as VNets do grupo)"
  type        = bool
  default     = true
}

variable "connectivity_configuration_name" {
  type    = string
  default = "conn-config"
}

variable "connectivity_topology" {
  description = "Mesh (peering completo entre todas) ou HubAndSpoke"
  type        = string
  default     = "Mesh"
}

variable "security_admin_configuration_name" {
  type    = string
  default = "secadmin-config"
}

variable "admin_rule_collection_name" {
  type    = string
  default = "rulecoll"
}

variable "admin_rules" {
  description = "Regras de segurança aplicadas a TODAS as VNets do grupo, com prioridade acima de qualquer NSG local. Lista vazia (padrão) não cria Security Admin Configuration."
  type = list(object({
    name                             = string
    action                           = string
    direction                        = string
    priority                         = number
    protocol                         = string
    source_address_prefix_type       = string
    source_address_prefix            = string
    destination_address_prefix_type  = string
    destination_address_prefix       = string
    source_port_ranges               = list(string)
    destination_port_ranges          = list(string)
  }))
  default = []
}

variable "tags" {
  description = "Tags aplicadas ao Network Manager"
  type        = map(string)
  default     = {}
}
