resource "azurerm_resource_group" "default" {
  name     = "rg-${var.name}"
  location = var.location
}

resource "azurerm_virtual_network" "default" {
  name                = "vnet-${var.name}"
  location            = azurerm_resource_group.default.location
  resource_group_name = azurerm_resource_group.default.name
  address_space       = ["10.0.0.0/21"]
}

resource "azurerm_subnet" "aks_subnet" {
  name                 = "aks-subnet"
  resource_group_name  = azurerm_resource_group.default.name
  virtual_network_name = azurerm_virtual_network.default.name
  address_prefixes     = ["10.0.0.0/24"]
}

resource "azurerm_network_security_group" "default" {
  name                = "nsg-default"
  location            = azurerm_resource_group.default.location
  resource_group_name = azurerm_resource_group.default.name
}

resource "azurerm_subnet_network_security_group_association" "aks_subnet" {
  subnet_id                 = azurerm_subnet.aks_subnet.id
  network_security_group_id = azurerm_network_security_group.default.id
}

resource "azurerm_kubernetes_cluster" "default" {
  name                = "monolith-${var.name}"
  location            = azurerm_resource_group.default.location
  resource_group_name = azurerm_resource_group.default.name
  dns_prefix          = "monolith-${var.name}"

  default_node_pool {
    name                = "sys01"
    node_count          = var.workers_count
    vm_size             = var.vm_size
    vnet_subnet_id      = azurerm_subnet.aks_subnet.id
    enable_auto_scaling = true
    max_count           = 5
    max_pods            = 110
    min_count           = 1

    upgrade_settings {
      max_surge = "10%"
    }
  }

  network_profile {
    network_plugin    = "kubenet"
    load_balancer_sku = "standard"
    service_cidr      = "172.16.0.0/16"
    dns_service_ip    = "172.16.0.10"
    pod_cidr          = "172.17.0.0/16"
  }

  identity {
    type = "SystemAssigned"
  }
}

resource "azurerm_role_assignment" "aks_subnet" {
  scope                = azurerm_subnet.aks_subnet.id
  role_definition_name = "Network Contributor"
  principal_id         = azurerm_kubernetes_cluster.default.identity[0].principal_id
}

output "name" {
  value = {
    resource_group = azurerm_resource_group.default.name
    aks_name       = azurerm_kubernetes_cluster.default.name
    vnet_name      = azurerm_virtual_network.default.name
  }
}
