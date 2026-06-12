# ── Data Sources — Resource Groups ────────────────────────────────────────────

data "azurerm_resource_group" "workload_brazilsouth" {
  name = "rg-blog-castilho-workload-brazilsouth"
}

data "azurerm_resource_group" "workload_eastus" {
  name = "rg-blog-castilho-workload-eastus"
}

# ── Data Sources — Subnets AKS ────────────────────────────────────────────────

data "azurerm_subnet" "aks_brazilsouth" {
  name                 = "snet-aks"
  virtual_network_name = "vnet-spoke-blog-castilho-brazilsouth"
  resource_group_name  = "rg-blog-castilho-network-brazilsouth"
}

data "azurerm_subnet" "aks_eastus" {
  name                 = "snet-aks"
  virtual_network_name = "vnet-spoke-blog-castilho-eastus"
  resource_group_name  = "rg-blog-castilho-network-eastus"
}

# ── Data Sources — Firewall Policies (para FW rules) ──────────────────────────

data "azurerm_firewall_policy" "brazilsouth" {
  name                = "afwp-blog-castilho-brazilsouth"
  resource_group_name = "rg-blog-castilho-network-brazilsouth"
}

data "azurerm_firewall_policy" "eastus" {
  name                = "afwp-blog-castilho-eastus"
  resource_group_name = "rg-blog-castilho-network-eastus"
}

# ── Azure Container Registry ───────────────────────────────────────────────────

module "acr" {
  source              = "../../terraform-acr-modules"
  name                = "acrblogcastilho"
  resource_group_name = data.azurerm_resource_group.workload_brazilsouth.name
  location            = data.azurerm_resource_group.workload_brazilsouth.location
  sku                 = "Premium"
  geo_replication_locations = [
    { location = "eastus", zone_redundancy_enabled = false }
  ]
  tags = var.tags
}

# ── Firewall Rules — AKS Egress Brazil South ──────────────────────────────────

resource "azurerm_firewall_policy_rule_collection_group" "aks_brazilsouth" {
  name               = "rcg-aks-blog-castilho-brazilsouth"
  firewall_policy_id = data.azurerm_firewall_policy.brazilsouth.id
  priority           = 200

  application_rule_collection {
    name     = "arc-aks-required"
    priority = 201
    action   = "Allow"

    rule {
      name                  = "aks-fqdn-tag"
      source_addresses      = ["10.2.4.0/22"]
      destination_fqdn_tags = ["AzureKubernetesService"]
      protocols {
        type = "Https"
        port = 443
      }
      protocols {
        type = "Http"
        port = 80
      }
    }

    rule {
      name              = "docker-hub"
      source_addresses  = ["10.2.4.0/22"]
      destination_fqdns = ["registry-1.docker.io", "auth.docker.io", "index.docker.io", "production.cloudflare.docker.com", "production.cloudfront.docker.com"]
      protocols {
        type = "Https"
        port = 443
      }
    }

    rule {
      name              = "acr"
      source_addresses  = ["10.2.4.0/22"]
      destination_fqdns = ["acrblogcastilho.azurecr.io", "acrblogcastilho.brazilsouth.data.azurecr.io", "*.blob.core.windows.net"]
      protocols {
        type = "Https"
        port = 443
      }
    }
  }

  network_rule_collection {
    name     = "nrc-aks-required"
    priority = 202
    action   = "Allow"

    rule {
      name                  = "aks-api-server"
      source_addresses      = ["10.2.4.0/22"]
      destination_ports     = ["443"]
      destination_addresses = ["AzureCloud.BrazilSouth"]
      protocols             = ["TCP"]
    }

    rule {
      name                  = "aks-tcp-tunnel"
      source_addresses      = ["10.2.4.0/22"]
      destination_ports     = ["9000"]
      destination_addresses = ["AzureCloud.BrazilSouth"]
      protocols             = ["TCP"]
    }

    rule {
      name                  = "aks-udp-tunnel"
      source_addresses      = ["10.2.4.0/22"]
      destination_ports     = ["1194"]
      destination_addresses = ["AzureCloud.BrazilSouth"]
      protocols             = ["UDP"]
    }

    rule {
      name                  = "aks-ntp"
      source_addresses      = ["10.2.4.0/22"]
      destination_ports     = ["123"]
      destination_addresses = ["*"]
      protocols             = ["UDP"]
    }
  }
}

# ── Firewall Rules — AKS Egress East US ───────────────────────────────────────

resource "azurerm_firewall_policy_rule_collection_group" "aks_eastus" {
  name               = "rcg-aks-blog-castilho-eastus"
  firewall_policy_id = data.azurerm_firewall_policy.eastus.id
  priority           = 200

  application_rule_collection {
    name     = "arc-aks-required"
    priority = 201
    action   = "Allow"

    rule {
      name                  = "aks-fqdn-tag"
      source_addresses      = ["10.3.4.0/22"]
      destination_fqdn_tags = ["AzureKubernetesService"]
      protocols {
        type = "Https"
        port = 443
      }
      protocols {
        type = "Http"
        port = 80
      }
    }

    rule {
      name              = "docker-hub"
      source_addresses  = ["10.3.4.0/22"]
      destination_fqdns = ["registry-1.docker.io", "auth.docker.io", "index.docker.io", "production.cloudflare.docker.com", "production.cloudfront.docker.com"]
      protocols {
        type = "Https"
        port = 443
      }
    }

    rule {
      name              = "acr"
      source_addresses  = ["10.3.4.0/22"]
      destination_fqdns = ["acrblogcastilho.azurecr.io", "acrblogcastilho.eastus.data.azurecr.io", "*.blob.core.windows.net"]
      protocols {
        type = "Https"
        port = 443
      }
    }
  }

  network_rule_collection {
    name     = "nrc-aks-required"
    priority = 202
    action   = "Allow"

    rule {
      name                  = "aks-api-server"
      source_addresses      = ["10.3.4.0/22"]
      destination_ports     = ["443"]
      destination_addresses = ["AzureCloud.EastUS"]
      protocols             = ["TCP"]
    }

    rule {
      name                  = "aks-tcp-tunnel"
      source_addresses      = ["10.3.4.0/22"]
      destination_ports     = ["9000"]
      destination_addresses = ["AzureCloud.EastUS"]
      protocols             = ["TCP"]
    }

    rule {
      name                  = "aks-udp-tunnel"
      source_addresses      = ["10.3.4.0/22"]
      destination_ports     = ["1194"]
      destination_addresses = ["AzureCloud.EastUS"]
      protocols             = ["UDP"]
    }

    rule {
      name                  = "aks-ntp"
      source_addresses      = ["10.3.4.0/22"]
      destination_ports     = ["123"]
      destination_addresses = ["*"]
      protocols             = ["UDP"]
    }
  }
}

# ── AKS Cluster — Brazil South ────────────────────────────────────────────────

module "aks_brazilsouth" {
  source              = "../../terraform-aks-modules"
  name                = "aks-blog-castilho-brazilsouth"
  resource_group_name = data.azurerm_resource_group.workload_brazilsouth.name
  location            = data.azurerm_resource_group.workload_brazilsouth.location
  dns_prefix          = "aks-bcastilho-brs"
  kubernetes_version  = var.kubernetes_version
  node_resource_group = "rg-mc-aks-bcastilho-brs"
  subnet_id           = data.azurerm_subnet.aks_brazilsouth.id
  acr_id              = module.acr.registry_id
  attach_acr_role     = true
  service_cidr        = "172.16.0.0/16"
  dns_service_ip      = "172.16.0.10"
  tags                = var.tags

  depends_on = [azurerm_firewall_policy_rule_collection_group.aks_brazilsouth]
}

# ── AKS Cluster — East US ─────────────────────────────────────────────────────

module "aks_eastus" {
  source              = "../../terraform-aks-modules"
  name                = "aks-blog-castilho-eastus"
  resource_group_name = data.azurerm_resource_group.workload_eastus.name
  location            = data.azurerm_resource_group.workload_eastus.location
  dns_prefix          = "aks-bcastilho-eus"
  kubernetes_version  = var.kubernetes_version
  node_resource_group = "rg-mc-aks-bcastilho-eus"
  subnet_id           = data.azurerm_subnet.aks_eastus.id
  acr_id              = module.acr.registry_id
  attach_acr_role     = true
  service_cidr        = "172.16.0.0/16"
  dns_service_ip      = "172.16.0.10"
  tags                = var.tags

  depends_on = [azurerm_firewall_policy_rule_collection_group.aks_eastus]
}
