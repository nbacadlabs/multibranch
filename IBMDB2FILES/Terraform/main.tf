# provider "helm" {
#   kubernetes {
#     config_path = "~/.kube/config"
#   }
# }

# provider "kubernetes" {
#   config_path = "~/.kube/config"
# }

resource "random_string" "suffix" {
  length  = 6
  upper   = false
  special = false
}

resource "azurerm_resource_group" "rg" {
  name     = "rg-db2-aks"
  location = "eastus"
}

resource "azurerm_kubernetes_cluster" "aks" {
  name                = "db2-aks-cluster"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  dns_prefix          = "db2aks"

  default_node_pool {
    name       = "default"
    node_count = 2
    vm_size    = "Standard_DS3_v2"
  }

  identity {
    type = "SystemAssigned"
  }

  role_based_access_control_enabled = true

depends_on = [
    azurerm_resource_group.rg
  ]
}

# resource "azurerm_storage_account" "files" {
#   name                     = "db2files${random_string.suffix.result}"
#   resource_group_name      = azurerm_resource_group.rg.name
#   location                 = azurerm_resource_group.rg.location
#   account_tier             = "Standard"
#   account_replication_type = "LRS"
#   account_kind             = "StorageV2"
# }

# resource "azurerm_storage_share" "db2share" {
#   name                 = "db2share"
#   storage_account_id   = azurerm_storage_account.files.id
#   quota                = 50
#   enabled_protocol     = "SMB"
# }

# resource "azurerm_role_assignment" "aks_storage_share_access" {
#   principal_id         = azurerm_kubernetes_cluster.aks.identity[0].principal_id
#   role_definition_name = "Storage File Data Privileged Contributor"
#   scope                = azurerm_storage_account.files.id

#   depends_on = [
#     azurerm_kubernetes_cluster.aks,
#     azurerm_storage_share.db2share
#   ]
# }

# resource "kubernetes_service_account" "db2_service_account" {
#   metadata {
#     name      = "db2u"
#     namespace = "ibm-db2"
#   }
# }

# resource "kubernetes_persistent_volume_claim" "db2_pvc" {
#   metadata {
#     name      = "db2-pvc"
#     namespace = "ibm-db2"
#   }
#   spec {
#     access_modes = ["ReadWriteOnce"]
#     resources {
#       requests = {
#         storage = "100Gi"
#       }
#     }
#     storage_class_name = "managed-csi"
#   }
#   timeouts {
#     create = "20m"
#   }
# }

# resource "helm_release" "ibm_db2" {
#   depends_on = [
#     azurerm_kubernetes_cluster.aks,
#     azurerm_role_assignment.aks_storage_share_access,
#     kubernetes_service_account.db2_service_account,
#     kubernetes_persistent_volume_claim.db2_pvc
#   ]

#   name             = "ibm-db2"
#   chart            = "./ibm-db2-3.0.2.tgz"
#   namespace        = "ibm-db2"
#   create_namespace = true

#   values = [
#     file("db2-values.yaml")
#   ]

#   timeout = 900  # Increase the timeout to 10 minutes
# }




# provider "helm" {
#   kubernetes {
#     config_path = "~/.kube/config"
#   }
# }

# provider "kubernetes" {
#   config_path = "~/.kube/config"
# }

# resource "random_string" "suffix" {
#   length  = 6
#   upper   = false
#   special = false
# }

# resource "azurerm_resource_group" "rg" {
#   name     = "rg-db2-aks"
#   location = "eastus"
# }

# resource "azurerm_kubernetes_cluster" "aks" {
#   name                = "db2-aks-cluster"
#   location            = azurerm_resource_group.rg.location
#   resource_group_name = azurerm_resource_group.rg.name
#   dns_prefix          = "db2aks"

#   default_node_pool {
#     name       = "default"
#     node_count = 2
#     vm_size    = "Standard_DS3_v2"
#   }

#   identity {
#     type = "SystemAssigned"
#   }

#   role_based_access_control_enabled = true
# }

# resource "azurerm_storage_account" "files" {
#   name                     = "db2files${random_string.suffix.result}"
#   resource_group_name      = azurerm_resource_group.rg.name
#   location                 = azurerm_resource_group.rg.location
#   account_tier             = "Standard"
#   account_replication_type = "LRS"
#   account_kind             = "StorageV2"
# }

# resource "azurerm_storage_share" "db2share" {
#   name                 = "db2share"
#   storage_account_id   = azurerm_storage_account.files.id
#   quota                = 50
#   enabled_protocol     = "SMB"
# }

# resource "azurerm_role_assignment" "aks_storage_share_access" {
#   principal_id         = azurerm_kubernetes_cluster.aks.identity[0].principal_id
#   role_definition_name = "Storage File Data Privileged Contributor"
#   scope                = azurerm_storage_account.files.id

#     depends_on = [
#     azurerm_kubernetes_cluster.aks,
#     azurerm_storage_share.db2share
#   ]
# }

# resource "helm_release" "ibm_db2" {
#   depends_on = [
#     azurerm_kubernetes_cluster.aks,
#     azurerm_role_assignment.aks_storage_share_access
#   ]


#   name             = "ibm-db2"
#   chart            = "./ibm-db2-3.0.2.tgz"
#   namespace        = "ibm-db2"
#   create_namespace = true

#   values = [
#     file("db2-values.yaml")
#   ]

#   timeout = 600  # Increase the timeout to 10 minutes
# }

