# File: variables.tf (Updated)

variable "libvirt_uri" {
  description = "Libvirt connection URI"
  type        = string
  default     = "qemu:///system"
}

# New variable to define multiple VMs
variable "vms" {
  description = "Map of VMs to create"
  type = map(object({
    name        = string
    memory_mb   = number
    vcpus       = number
    disk_size_bytes = number
    packages    = list(string)
    timezone    = optional(string, "UTC")
    mac_address = optional(string, "")
    autostart   = optional(bool, true)
    start_vm    = optional(bool, true)
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
  description = "Wait for DHCP lease"
  type        = bool
  default     = true
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