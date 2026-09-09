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

variable "vnet_address_space" {
  type    = string
  default = "10.80.0.0/16"
}

# O nome "GatewaySubnet" é obrigatório — igual no net-05, o Azure só
# reconhece um gateway numa subnet com esse nome exato.
variable "gateway_subnet_prefix" {
  type        = string
  description = "A subnet do gateway precisa se chamar exatamente GatewaySubnet"
  default     = "10.80.255.0/27"
}

variable "p2s_address_pool" {
  type        = string
  description = "Pool de IPs atribuído aos clientes P2S conectados (não pode sobrepor a vnet_address_space nem redes on-premises)"
  default     = "172.16.201.0/24"
}

variable "root_cert_name" {
  type        = string
  description = "Nome do certificado raiz confiável pela configuração P2S"
  default     = "P2SRootCert-blog-castilho"
}

variable "root_cert_public_data_path" {
  type        = string
  description = "Caminho pro arquivo com os dados base64 (DER, sem cabeçalho PEM) do certificado raiz público — ver README para gerar com PowerShell ou OpenSSL"
  default     = "certs/root-cert-public-data.txt"
}

variable "tags" {
  type        = map(string)
  description = "Tags aplicadas a todos os recursos"
  default = {
    project    = "blog-castilho"
    managed_by = "terraform"
    artigo     = "net-08-vpn-gateway-p2s"
  }
}
