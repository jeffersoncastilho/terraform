variable "cluster_name" {
  description = "Nome do cluster EKS"
  type        = string
}

variable "name" {
  description = "Nome do node group"
  type        = string
}

variable "subnet_ids" {
  description = "Subnets dos nós (normalmente as privadas)"
  type        = list(string)
}

variable "kubernetes_version" {
  description = "Versão do kubelet; null = mesma do control plane"
  type        = string
  default     = null
}

variable "ami_type" {
  description = "AMI gerenciada (AL2023_x86_64_STANDARD, AL2023_ARM_64_STANDARD, BOTTLEROCKET_x86_64...)"
  type        = string
  default     = "AL2023_x86_64_STANDARD"
}

variable "capacity_type" {
  description = "ON_DEMAND ou SPOT"
  type        = string
  default     = "ON_DEMAND"

  validation {
    condition     = contains(["ON_DEMAND", "SPOT"], var.capacity_type)
    error_message = "Use ON_DEMAND ou SPOT."
  }
}

variable "instance_types" {
  description = "Tipos de instância. Em SPOT, liste vários tipos do mesmo tamanho para reduzir interrupções"
  type        = list(string)
  default     = ["t3.medium"]
}

variable "disk_size" {
  description = "Disco raiz dos nós em GiB"
  type        = number
  default     = 20
}

variable "min_size" {
  description = "Mínimo de nós"
  type        = number
  default     = 1
}

variable "desired_size" {
  description = "Quantidade inicial de nós (ignorada depois da criação)"
  type        = number
  default     = 2
}

variable "max_size" {
  description = "Máximo de nós"
  type        = number
  default     = 3
}

variable "max_unavailable_percentage" {
  description = "Percentual de nós substituídos ao mesmo tempo em updates"
  type        = number
  default     = 33
}

variable "labels" {
  description = "Labels do Kubernetes aplicadas aos nós"
  type        = map(string)
  default     = {}
}

variable "taints" {
  description = "Taints dos nós (effect: NO_SCHEDULE, NO_EXECUTE ou PREFER_NO_SCHEDULE)"
  type = list(object({
    key    = string
    value  = optional(string)
    effect = string
  }))
  default = []
}

variable "enable_ssm" {
  description = "Anexa AmazonSSMManagedInstanceCore para acessar os nós via Session Manager"
  type        = bool
  default     = true
}

variable "tags" {
  description = "Tags aplicadas a todos os recursos"
  type        = map(string)
  default     = {}
}
