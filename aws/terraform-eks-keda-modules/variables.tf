variable "cluster_name" {
  description = "Nome do cluster EKS (também nomeia a role do operator)"
  type        = string
}

variable "chart_version" {
  description = "Versão do chart kedacore/keda (sem o v)"
  type        = string
}

variable "namespace" {
  description = "Namespace do KEDA"
  type        = string
  default     = "keda"
}

variable "sqs_queue_arns" {
  description = "Filas SQS que o operator pode ler (GetQueueAttributes); vazio = sem role de AWS"
  type        = list(string)
  default     = []
}

variable "node_selector" {
  description = "nodeSelector dos pods do KEDA (operator, metrics server e webhooks)"
  type        = map(string)
  default     = {}
}

variable "operator_replicas" {
  description = "Réplicas do operator (só uma fica ativa; as outras esperam a eleição de líder)"
  type        = number
  default     = 1
}

variable "tags" {
  description = "Tags aplicadas aos recursos da AWS"
  type        = map(string)
  default     = {}
}
