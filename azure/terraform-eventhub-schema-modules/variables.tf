variable "namespace_id" {
  description = "ID do Event Hubs Namespace onde os Schema Groups serão criados"
  type        = string
}

variable "schema_groups" {
  description = "Lista de Schema Groups a criar"
  type = list(object({
    name                 = string
    schema_type          = string
    schema_compatibility = string
  }))
  default = []

  validation {
    condition = alltrue([
      for sg in var.schema_groups :
      contains(["Avro", "Json", "Custom"], sg.schema_type)
    ])
    error_message = "schema_type deve ser Avro, Json ou Custom."
  }

  validation {
    condition = alltrue([
      for sg in var.schema_groups :
      contains(["None", "Backward", "Forward", "Full"], sg.schema_compatibility)
    ])
    error_message = "schema_compatibility deve ser None, Backward, Forward ou Full."
  }
}
