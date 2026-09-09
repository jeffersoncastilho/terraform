variable "name" {
  description = "Nome do Virtual Network Gateway"
  type        = string
}

variable "resource_group_name" {
  description = "Resource Group onde o Gateway será criado"
  type        = string
}

variable "location" {
  description = "Região Azure do Gateway"
  type        = string
}

variable "gateway_subnet_id" {
  description = "ID da subnet GatewaySubnet (nome obrigatório fixo pelo Azure) onde o Gateway é conectado"
  type        = string
}

variable "public_ip_address_id" {
  description = "ID do Public IP associado ao Gateway (ver terraform-public-ip-modules)"
  type        = string
}

variable "vpn_type" {
  description = "RouteBased (recomendado, suporta P2S e a maioria dos cenários) ou PolicyBased"
  type        = string
  default     = "RouteBased"
}

variable "sku" {
  description = "SKU do Gateway (ex: VpnGw1, VpnGw2, VpnGw1AZ). Define throughput e se suporta zona de disponibilidade"
  type        = string
  default     = "VpnGw1"
}

variable "generation" {
  description = "Geração do Gateway (Generation1 ou Generation2) — Generation2 exige SKUs VpnGw2+"
  type        = string
  default     = "Generation1"
}

variable "vpn_client_configuration" {
  description = "Configuração Point-to-Site (P2S). Deixe null para um Gateway sem P2S (ex: só site-to-site)."
  type = object({
    address_space        = list(string)
    vpn_client_protocols = list(string)
    vpn_auth_types       = list(string)
    root_certificates = list(object({
      name             = string
      public_cert_data = string
    }))
  })
  default = null
}

variable "tags" {
  description = "Tags aplicadas ao Gateway"
  type        = map(string)
  default     = {}
}
