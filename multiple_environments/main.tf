# main.tf (Root Module)

terraform {
  required_version = ">= 1.0"
  required_providers {
    libvirt = {
      source  = "dmacvicar/libvirt"
      version = "~> 0.7.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.1"
    }
  }
}

provider "libvirt" {
  uri = var.libvirt_uri
}

# This variable allows you to select which environment to deploy.
# You can set its value in terraform.tfvars or via the command line.
variable "selected_environment" {
  description = "The environment to deploy (e.g., 'gitlab' or 'k8s' or 'ceph')."
  type        = string
}

# The single module call that uses the selected_environment variable
module "kvm_vms" {
  # This for_each looop ensures the module is only created for the selected environment.
  # This makes your deployment dynamic and prevents deploying all environments at once.
  for_each = { for key, value in var.environments : key => value if key == var.selected_environment }
  
  source = "./modules/kvm-vms"
  
  # Environment specific configuration for the selected environment
  environment       = each.value.environment
  network_cidr      = each.value.network_cidr
  network_gateway   = each.value.network_gateway
  network_name      = "${each.value.network_name}-${each.value.environment}"
  dns_servers       = each.value.dns_servers
  
  # VM configuration
  vms = each.value.vms
  
  # Common settings
  storage_pool      = each.value.storage_pool
  
  # Cluster network settings (added missing variables)
  enable_cluster_network   = try(each.value.enable_cluster_network, false)
  cluster_network_cidr     = try(each.value.cluster_network_cidr, "10.0.0.0/24")
  cluster_network_gateway  = try(each.value.cluster_network_gateway, "10.0.0.1")
  cluster_network_name     = try(each.value.cluster_network_name, "cluster")
  
  # Global variables
  base_qcow2_path    = var.base_qcow2_path
  ssh_public_key     = var.ssh_public_key
  default_user       = var.default_user
  default_password   = var.default_password
  network_interface  = var.network_interface
  vnc_listen_address = var.vnc_listen_address
  wait_for_lease     = var.wait_for_lease
  libvirt_uri        = var.libvirt_uri
}