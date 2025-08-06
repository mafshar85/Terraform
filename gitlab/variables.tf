# File: variables.tf

variable "libvirt_uri" {
  description = "Libvirt connection URI"
  type        = string
  default     = "qemu:///system"
}

# VM configuration with static IP support
variable "vms" {
  description = "Map of VMs to create"
  type = map(object({
    name            = string
    memory_mb       = number
    vcpus           = number
    disk_size_bytes = number
    packages        = list(string)
    timezone        = optional(string, "UTC")
    mac_address     = optional(string, "")
    static_ip       = optional(string, "")
    autostart       = optional(bool, true)
    start_vm        = optional(bool, true)
  }))
  default = {}
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

variable "vnc_listen_address" {
  description = "VNC listen address"
  type        = string
  default     = "127.0.0.1"
}

variable "wait_for_lease" {
  description = "Wait for DHCP lease on the network interface"
  type        = bool
  default     = false # Changed to false to prevent timeout for static IPs
}

variable "ssh_public_key" {
  description = "SSH public key for accessing the VM"
  type        = string
}

variable "default_user" {
  description = "Default user for cloud-init"
  type        = string
  default     = "ubuntu"
}

#mkpasswd --method=SHA-512 
variable "default_password" {
  description = "Default password for cloud-init"
  type        = string
  default     = "$6$acFWB0s19QB9xkge$/HjdAJbqjE6DKjWzx41ZyRSEXy4RcFwCdfA9qSuXaLdfFDDjbQm2RQ4sfGFAUgruKJ8Ji9fdTCq9kgt1.EIWI."
}

# Network configuration for static IPs
variable "network_cidr" {
  description = "Network CIDR for the libvirt network"
  type        = string
  default     = "192.168.110.0/24"
}

variable "network_gateway" {
  description = "Gateway IP for the network"
  type        = string
  default     = "192.168.110.1"
}

variable "dns_servers" {
  description = "DNS servers for the network"
  type        = list(string)
  default     = ["8.8.8.8", "8.8.4.4"]
}
