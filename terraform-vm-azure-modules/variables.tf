variable "resource_group_name" {
  description = "O nome do Resource Group onde os recursos serão criados."
  type        = string
}

variable "location" {
  description = "A região do Azure onde os recursos serão criados."
  type        = string
}

variable "vm_name" {
  description = "O nome da Máquina Virtual."
  type        = string
}

variable "subnet_id" {
  description = "O ID da Subnet onde a interface de rede da VM será conectada."
  type        = string
}

variable "vm_size" {
  description = "O tamanho (SKU) da Máquina Virtual."
  type        = string
  default     = "Standard_B1s"
}

variable "admin_username" {
  description = "O nome de usuário do administrador para a VM."
  type        = string
  default     = "azureuser"
}

variable "public_key" {
  description = "A chave pública SSH para autenticação."
  type        = string
}

variable "enable_public_ip" {
  description = "Define se um IP público deve ser criado e associado à VM."
  type        = bool
  default     = false
}

variable "nsg_rules" {
  description = "Uma lista de objetos definindo as regras de segurança do NSG."
  type = list(object({
    name                       = string
    priority                   = number
    direction                  = string
    access                     = string
    protocol                   = string
    source_port_range          = string
    destination_port_range     = string
    source_address_prefix      = string
    destination_address_prefix = string
  }))
  default = []
}

variable "tags" {
  description = "Um mapa de tags para atribuir aos recursos."
  type        = map(string)
  default     = {}
}

variable "enable_custom_script" {
  description = "Habilita a extensão de Custom Script na VM."
  type        = bool
  default     = false
}

variable "custom_script_file_uris" {
  description = "Lista de URIs de arquivos para a extensão de Custom Script baixar."
  type        = list(string)
  default     = []
}

variable "custom_script_command" {
  description = "O comando a ser executado pela extensão de Custom Script."
  type        = string
  default     = ""
}