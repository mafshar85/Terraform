# modules/kvm-vms/variables.tf

variable "environment" {
  description = "Environment name (dev, prod, etc.)"
  type        = string
  
  validation {
    condition     = can(regex("^(gitlab|k8s|ceph|dev|prod|staging|test)$", var.environment))
    error_message = "Environment must be one of: gitlab, k8s, ceph, dev, prod, staging, test."
  }
}

variable "libvirt_uri" {
  description = "Libvirt connection URI"
  type        = string
  default     = "qemu:///system"
}

# VM configuration with static IP and cluster IP support
variable "vms" {
  description = "Map of VMs to create"
  type = map(object({
    name              = string
    memory_mb         = number
    vcpus             = number
    disk_size_bytes   = number
    packages          = list(string)
    timezone          = optional(string, "UTC")
    mac_address       = optional(string, "")
    static_ip         = optional(string, "")
    cluster_ip        = optional(string, "")
    autostart         = optional(bool, true)
    start_vm          = optional(bool, true)
    enable_cluster_network = optional(bool, false)
  }))
  default = {}
  
  validation {
    condition = alltrue([
      for vm_key, vm in var.vms : vm.memory_mb >= 512
    ])
    error_message = "VM memory must be at least 512MB."
  }
  
  validation {
    condition = alltrue([
      for vm_key, vm in var.vms : vm.vcpus >= 1
    ])
    error_message = "VM must have at least 1 vCPU."
  }
}

variable "storage_pool" {
  description = "Libvirt storage pool name"
  type        = string
  default     = "default"
}

variable "base_qcow2_path" {
  description = "Path to your base qcow2 image"
  type        = string
}

# Public network configuration
variable "network_name" {
  description = "Network name to connect VM to"
  type        = string
  default     = "default"
}

variable "network_interface" {
  description = "Network interface name in the VM"
  type        = string
  default     = "ens3"
}

variable "network_cidr" {
  description = "Network CIDR for the libvirt network"
  type        = string
  default     = "192.168.110.0/24"
  
  validation {
    condition     = can(cidrhost(var.network_cidr, 0))
    error_message = "Network CIDR must be a valid CIDR block."
  }
}

variable "network_gateway" {
  description = "Gateway IP for the network"
  type        = string
  default     = "192.168.110.1"
  
  validation {
    condition     = can(regex("^(?:[0-9]{1,3}\\.){3}[0-9]{1,3}$", var.network_gateway))
    error_message = "Network gateway must be a valid IPv4 address."
  }
}

variable "dns_servers" {
  description = "DNS servers for the network"
  type        = list(string)
  default     = ["8.8.8.8", "8.8.4.4"]
  
  validation {
    condition = alltrue([
      for ip in var.dns_servers : can(regex("^(?:[0-9]{1,3}\\.){3}[0-9]{1,3}$", ip))
    ])
    error_message = "All DNS servers must be valid IPv4 addresses."
  }
}

# Cluster network configuration (for Ceph)
variable "enable_cluster_network" {
  description = "Enable cluster network (for Ceph)"
  type        = bool
  default     = false
}

variable "cluster_network_name" {
  description = "Cluster network name"
  type        = string
  default     = "cluster"
}

variable "cluster_network_cidr" {
  description = "Cluster network CIDR for internal communication"
  type        = string
  default     = "10.0.0.0/24"
  
  validation {
    condition     = can(cidrhost(var.cluster_network_cidr, 0))
    error_message = "Cluster network CIDR must be a valid CIDR block."
  }
}

variable "cluster_network_gateway" {
  description = "Gateway IP for the cluster network"
  type        = string
  default     = "10.0.0.1"
  
  validation {
    condition     = can(regex("^(?:[0-9]{1,3}\\.){3}[0-9]{1,3}$", var.cluster_network_gateway))
    error_message = "Cluster network gateway must be a valid IPv4 address."
  }
}

# Other settings
variable "vnc_listen_address" {
  description = "VNC listen address"
  type        = string
  default     = "127.0.0.1"
}

variable "wait_for_lease" {
  description = "Wait for DHCP lease on the network interface"
  type        = bool
  default     = false
}

variable "ssh_public_key" {
  description = "SSH public key for accessing the VM"
  type        = string
}

variable "ssh_port" {
  description = " SSH Port for cloud-init"
  type        = number
  default     = 8822
}

variable "default_user" {
  description = "Default user for cloud-init"
  type        = string
  default     = "ubuntu"
}

variable "default_password" {
  description = "Default password for cloud-init (hashed)"
  type        = string
  default     = "$6$acFWB0s19QB9xkge$/HjdAJbqjE6DKjWzx41ZyRSEXy4RcFwCdfA9qSuXaLdfFDDjbQm2RQ4sfGFAUgruKJ8Ji9fdTCq9kgt1.EIWI."
}