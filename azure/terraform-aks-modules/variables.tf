variable "name" {
  description = "Nome do AKS Cluster"
  type        = string
}

variable "resource_group_name" {
  description = "Resource Group onde o AKS será criado"
  type        = string
}

variable "location" {
  description = "Região Azure do AKS"
  type        = string
}

variable "dns_prefix" {
  description = "Prefixo DNS do AKS"
  type        = string
}

variable "kubernetes_version" {
  description = "Versão do Kubernetes"
  type        = string
  default     = "1.33"
}

variable "node_resource_group" {
  description = "Nome do Resource Group gerenciado dos nós (deixe null para gerar automaticamente)"
  type        = string
  default     = null
}

variable "node_count" {
  description = "Número de nós no node pool padrão"
  type        = number
  default     = 2
}

variable "vm_size" {
  description = "Tamanho da VM dos nós"
  type        = string
  default     = "Standard_D2s_v3"
}

variable "subnet_id" {
  description = "ID da subnet para os nós do AKS"
  type        = string
}

variable "service_cidr" {
  description = "CIDR para os serviços Kubernetes (não deve sobrepor com VNets)"
  type        = string
  default     = "172.16.0.0/16"
}

variable "dns_service_ip" {
  description = "IP do DNS service dentro do service_cidr"
  type        = string
  default     = "172.16.0.10"
}

variable "acr_id" {
  description = "ID do ACR para atribuir a role AcrPull ao kubelet identity (null = não atribuir)"
  type        = string
  default     = null
}

variable "attach_acr_role" {
  description = "Cria azurerm_role_assignment AcrPull para o kubelet identity. Deve ser true apenas quando acr_id já existe no state (evita 'count depends on unknown value' no plan)."
  type        = bool
  default     = false
}

variable "tags" {
  description = "Tags aplicadas a todos os recursos"
  type        = map(string)
  default     = {}
}
