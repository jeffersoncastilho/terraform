# ── Lado A ────────────────────────────────────────────────────────────────────

variable "peering_a_name" {
  description = "Nome do peering do lado A para o lado B"
  type        = string
}

variable "peering_a_rg" {
  description = "Resource Group da VNet do lado A"
  type        = string
}

variable "peering_a_vnet_name" {
  description = "Nome da VNet do lado A"
  type        = string
}

variable "peering_a_vnet_id" {
  description = "ID da VNet do lado A (usado como remote no peering B→A)"
  type        = string
}

variable "peering_a_allow_forwarded_traffic" {
  description = "Permite tráfego encaminhado no lado A"
  type        = bool
  default     = false
}

variable "peering_a_allow_gateway_transit" {
  description = "Permite gateway transit no lado A"
  type        = bool
  default     = false
}

variable "peering_a_use_remote_gateways" {
  description = "Usa gateways remotos no lado A"
  type        = bool
  default     = false
}

# ── Lado B ────────────────────────────────────────────────────────────────────

variable "peering_b_name" {
  description = "Nome do peering do lado B para o lado A"
  type        = string
}

variable "peering_b_rg" {
  description = "Resource Group da VNet do lado B"
  type        = string
}

variable "peering_b_vnet_name" {
  description = "Nome da VNet do lado B"
  type        = string
}

variable "peering_b_vnet_id" {
  description = "ID da VNet do lado B (usado como remote no peering A→B)"
  type        = string
}

variable "peering_b_allow_forwarded_traffic" {
  description = "Permite tráfego encaminhado no lado B"
  type        = bool
  default     = false
}

variable "peering_b_allow_gateway_transit" {
  description = "Permite gateway transit no lado B"
  type        = bool
  default     = false
}

variable "peering_b_use_remote_gateways" {
  description = "Usa gateways remotos no lado B"
  type        = bool
  default     = false
}
