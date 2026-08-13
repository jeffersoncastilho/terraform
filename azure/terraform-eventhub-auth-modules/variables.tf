variable "namespace_name" {
  description = "Nome do Event Hubs Namespace"
  type        = string
}

variable "eventhub_name" {
  description = "Nome do Event Hub (tópico)"
  type        = string
}

variable "resource_group_name" {
  description = "Resource Group do Event Hubs Namespace"
  type        = string
}

variable "auth_rules" {
  description = "Lista de Authorization Rules a criar"
  type = list(object({
    name   = string
    listen = bool
    send   = bool
    manage = bool
  }))
  default = []
}

variable "consumer_group_names" {
  description = "Lista de nomes de Consumer Groups a criar"
  type        = list(string)
  default     = []
}
