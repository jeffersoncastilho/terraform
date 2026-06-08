resource "azurerm_cdn_frontdoor_profile" "this" {
  name                = var.name
  resource_group_name = var.resource_group_name
  sku_name            = var.sku
  tags                = var.tags
}

resource "azurerm_cdn_frontdoor_firewall_policy" "this" {
  name                = var.waf_policy_name
  resource_group_name = var.resource_group_name
  sku_name            = azurerm_cdn_frontdoor_profile.this.sku_name
  enabled             = true
  mode                = var.waf_mode
  tags                = var.tags
}

resource "azurerm_cdn_frontdoor_endpoint" "this" {
  name                     = var.endpoint_name
  cdn_frontdoor_profile_id = azurerm_cdn_frontdoor_profile.this.id
  tags                     = var.tags
}

resource "azurerm_cdn_frontdoor_origin_group" "this" {
  name                     = var.origin_group_name
  cdn_frontdoor_profile_id = azurerm_cdn_frontdoor_profile.this.id
  session_affinity_enabled = false

  load_balancing {
    sample_size                        = var.lb_sample_size
    successful_samples_required        = var.lb_successful_samples
    additional_latency_in_milliseconds = var.lb_additional_latency_ms
  }

  health_probe {
    path                = var.probe_path
    protocol            = var.probe_protocol
    interval_in_seconds = var.probe_interval_seconds
    request_type        = "GET"
  }
}

resource "azurerm_cdn_frontdoor_origin" "this" {
  for_each = { for o in var.origins : o.name => o }

  name                           = each.value.name
  cdn_frontdoor_origin_group_id  = azurerm_cdn_frontdoor_origin_group.this.id
  host_name                      = each.value.host_name
  origin_host_header             = each.value.host_name
  http_port                      = 80
  https_port                     = 443
  priority                       = each.value.priority
  weight                         = each.value.weight
  enabled                        = true
  certificate_name_check_enabled = false
}

resource "azurerm_cdn_frontdoor_route" "this" {
  name                          = var.route_name
  cdn_frontdoor_endpoint_id     = azurerm_cdn_frontdoor_endpoint.this.id
  cdn_frontdoor_origin_group_id = azurerm_cdn_frontdoor_origin_group.this.id
  cdn_frontdoor_origin_ids      = [for o in azurerm_cdn_frontdoor_origin.this : o.id]
  https_redirect_enabled        = true
  patterns_to_match             = ["/*"]
  supported_protocols           = ["Http", "Https"]
  forwarding_protocol           = "HttpsOnly"
  link_to_default_domain        = true
}

resource "azurerm_cdn_frontdoor_security_policy" "this" {
  name                     = var.security_policy_name
  cdn_frontdoor_profile_id = azurerm_cdn_frontdoor_profile.this.id

  security_policies {
    firewall {
      cdn_frontdoor_firewall_policy_id = azurerm_cdn_frontdoor_firewall_policy.this.id
      association {
        domain {
          cdn_frontdoor_domain_id = azurerm_cdn_frontdoor_endpoint.this.id
        }
        patterns_to_match = ["/*"]
      }
    }
  }
}
