variable "name" {
  description = "Nome da VPC (prefixo dos demais recursos)"
  type        = string
}

variable "cidr_block" {
  description = "CIDR da VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "az_count" {
  description = "Quantidade de Availability Zones (o EKS exige subnets em pelo menos 2)"
  type        = number
  default     = 2

  validation {
    condition     = var.az_count >= 2
    error_message = "O EKS exige subnets em pelo menos 2 Availability Zones."
  }
}

variable "subnet_newbits" {
  description = "Bits adicionados ao prefixo da VPC para cada subnet (/16 + 4 = /20)"
  type        = number
  default     = 4
}

variable "single_nat_gateway" {
  description = "true = um NAT Gateway para todas as AZs (lab/dev); false = um por AZ (produção)"
  type        = bool
  default     = true
}

variable "public_subnet_tags" {
  description = "Tags extras nas subnets públicas"
  type        = map(string)
  default     = {}
}

variable "private_subnet_tags" {
  description = "Tags extras nas subnets privadas (ex.: karpenter.sh/discovery)"
  type        = map(string)
  default     = {}
}

variable "tags" {
  description = "Tags aplicadas a todos os recursos"
  type        = map(string)
  default     = {}
}
