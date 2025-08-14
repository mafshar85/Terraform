# modules/kvm-vms/outputs.tf

# Outputs for all VMs in this environment
output "vm_ips" {
  description = "IP addresses of all VMs in this environment"
  value = {
    for k, vm in libvirt_domain.vm : k => {
      public_ip = (
        length(vm.network_interface[0].addresses) > 0
        ? vm.network_interface[0].addresses[0]
        : "N/A - IP not available yet"
      )
      cluster_ip = (
        length(vm.network_interface) > 1 && length(vm.network_interface[1].addresses) > 0
        ? vm.network_interface[1].addresses[0]
        : null
      )
    }
  }
}

output "vm_names" {
  description = "Names of all VMs in this environment"
  value = {
    for k, vm in libvirt_domain.vm : k => vm.name
  }
}

output "vm_ids" {
  description = "IDs of all VMs in this environment"
  value = {
    for k, vm in libvirt_domain.vm : k => vm.id
  }
}

output "network_id" {
  description = "Public network ID for this environment"
  value       = libvirt_network.vm_network.id
}

output "network_name" {
  description = "Public network name for this environment"
  value       = libvirt_network.vm_network.name
}

output "cluster_network_id" {
  description = "Cluster network ID for this environment"
  value       = var.enable_cluster_network ? libvirt_network.cluster_network[0].id : null
}

output "cluster_network_name" {
  description = "Cluster network name for this environment"
  value       = var.enable_cluster_network ? libvirt_network.cluster_network[0].name : null
}

output "vm_details" {
  description = "Detailed information about all VMs"
  value = {
    for k, vm in libvirt_domain.vm : k => {
      name      = vm.name
      memory_mb = vm.memory
      vcpus     = vm.vcpu
      public_ip = (
        length(vm.network_interface[0].addresses) > 0
        ? vm.network_interface[0].addresses[0]
        : "N/A - IP not available yet"
      )
      cluster_ip = (
        length(vm.network_interface) > 1 && length(vm.network_interface[1].addresses) > 0
        ? vm.network_interface[1].addresses[0]
        : null
      )
      public_mac_address = vm.network_interface[0].mac
      cluster_mac_address = (
        length(vm.network_interface) > 1
        ? vm.network_interface[1].mac
        : null
      )
      autostart   = vm.autostart
      running     = vm.running
      has_cluster_network = var.vms[k].enable_cluster_network
    }
  }
}

output "environment_info" {
  description = "Environment information"
  value = {
    environment         = var.environment
    public_network_cidr = var.network_cidr
    public_gateway      = var.network_gateway
    cluster_network_cidr = var.enable_cluster_network ? var.cluster_network_cidr : null
    cluster_gateway     = var.enable_cluster_network ? var.cluster_network_gateway : null
    vm_count            = length(var.vms)
    storage_pool        = var.storage_pool
    cluster_network_enabled = var.enable_cluster_network
  }
}

output "ceph_network_info" {
  description = "Ceph-specific network information (if applicable)"
  value = var.environment == "ceph" ? {
    public_network = {
      name = libvirt_network.vm_network.name
      cidr = var.network_cidr
      purpose = "Client access, monitor communication, and management"
    }
    cluster_network = var.enable_cluster_network ? {
      name = libvirt_network.cluster_network[0].name
      cidr = var.cluster_network_cidr
      purpose = "OSD replication, recovery, and heartbeat traffic"
    } : null
    mon_ips = {
      for k, vm in libvirt_domain.vm : k => {
        public_ip = (
          length(vm.network_interface[0].addresses) > 0
          ? vm.network_interface[0].addresses[0]
          : "N/A"
        )
      } if can(regex("mon", k))
    }
    osd_ips = {
      for k, vm in libvirt_domain.vm : k => {
        public_ip = (
          length(vm.network_interface[0].addresses) > 0
          ? vm.network_interface[0].addresses[0]
          : "N/A"
        )
        cluster_ip = (
          length(vm.network_interface) > 1 && length(vm.network_interface[1].addresses) > 0
          ? vm.network_interface[1].addresses[0]
          : "N/A"
        )
      } if can(regex("osd", k))
    }
  } : null
}