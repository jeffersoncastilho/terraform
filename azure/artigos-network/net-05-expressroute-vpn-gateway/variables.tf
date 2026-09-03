variable "subscription_id" {
  type        = string
  description = "ID da subscription Azure"
  sensitive   = true
}

variable "location" {
  type        = string
  description = "Região onde os recursos são criados"
  default     = "eastus"
}

variable "resource_group_name" {
  type        = string
  description = "Resource Group que concentra a VNet, o VPN Gateway e o ExpressRoute Circuit de exemplo"
  default     = "rg-blog-castilho-hybrid"
}

variable "vnet_address_space" {
  type    = string
  default = "10.70.0.0/16"
}

variable "gateway_subnet_prefix" {
  type        = string
  description = "A subnet do gateway precisa se chamar exatamente GatewaySubnet"
  default     = "10.70.255.0/27"
}

# ── VPN Gateway (site-to-site) ────────────────────────────────────────────────

variable "on_premises_address_space" {
  type        = string
  description = "Endereçamento fictício do 'datacenter on-premises' simulado pelo Local Network Gateway"
  default     = "192.168.0.0/16"
}

variable "on_premises_gateway_ip" {
  type        = string
  description = "IP público fictício do roteador VPN on-premises (não precisa existir de verdade pra terraform plan/validate)"
  default     = "203.0.113.1"
}

variable "shared_key" {
  type        = string
  description = "Pre-shared key da conexão IPsec — usar TF_VAR_shared_key ou .tfvars fora do Git, nunca hardcoded"
  sensitive   = true
  default     = "changeme-use-tfvars-ou-tf-var-env"
}

# ── ExpressRoute Circuit ───────────────────────────────────────────────────────

variable "expressroute_service_provider" {
  type        = string
  description = "Nome do provedor de conectividade (ex: Equinix, Megaport) — precisa constar na lista de provedores do Azure na região"
  default     = "Equinix"
}

variable "expressroute_peering_location" {
  type        = string
  description = "Local de peering físico do provedor (ex: 'Silicon Valley', 'Washington DC')"
  default     = "Washington DC"
}

variable "expressroute_bandwidth_mbps" {
  type    = number
  default = 50
}

variable "tags" {
  type        = map(string)
  description = "Tags aplicadas a todos os recursos"
  default = {
    project    = "blog-castilho"
    managed_by = "terraform"
    artigo     = "net-05-expressroute-vpn-gateway"
  }
}
