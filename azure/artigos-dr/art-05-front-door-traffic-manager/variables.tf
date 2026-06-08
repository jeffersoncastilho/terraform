variable "subscription_id" {
  description = "ID da subscription Azure"
  type        = string
  sensitive   = true
}

variable "waf_mode" {
  description = "Modo da WAF do Front Door (Detection, Prevention)"
  type        = string
  default     = "Prevention"
}

variable "tm_ttl" {
  description = "TTL do DNS do Traffic Manager em segundos"
  type        = number
  default     = 30
}

variable "tags" {
  description = "Tags aplicadas a todos os recursos"
  type        = map(string)
  default = {
    project    = "blog-castilho"
    managed_by = "terraform"
    artigo     = "art-05-front-door-traffic-manager"
  }
}
