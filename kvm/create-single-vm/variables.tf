
# File: variables.tf
variable "libvirt_uri" {
  description = "Libvirt connection URI"
  type        = string
  default     = "qemu:///system"
}

variable "vm_name" {
  description = "Name of the virtual machine"
  type        = string
  default     = "terraform-vm"
}

variable "memory_mb" {
  description = "Memory allocation in MB"
  type        = number
  default     = 2048
}

variable "vcpus" {
  description = "Number of virtual CPUs"
  type        = number
  default     = 2
}

variable "disk_size_bytes" {
  description = "Disk size in bytes"
  type        = number
  default     = 21474836480 # 20GB
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

variable "base_image_path" {
  description = "Path to base image (optional)"
  type        = string
  default     = ""
}

variable "iso_path" {
  description = "Path to ISO file for installation"
  type        = string
  default     = ""
}

variable "vnc_listen_address" {
  description = "VNC listen address"
  type        = string
  default     = "127.0.0.1"
}

variable "mac_address" {
  description = "MAC address for the VM (optional)"
  type        = string
  default     = ""
}

variable "wait_for_lease" {
  description = "Wait for DHCP lease"
  type        = bool
  default     = true
}

variable "autostart" {
  description = "Autostart VM on host boot"
  type        = bool
  default     = true
}

variable "start_vm" {
  description = "Start VM after creation"
  type        = bool
  default     = true
}

variable "enable_cloud_init" {
  description = "Enable cloud-init configuration"
  type        = bool
  default     = false
}

variable "ssh_public_keys" {
  description = "List of SSH public keys for cloud-init"
  type        = list(string)
  default     = []
}

variable "ssh_public_key" {
  description = "SSH public key for accessing the VM"
  type        = string
}

variable "packages" {
  description = "List of packages to install via cloud-init"
  type        = list(string)
  default     = ["qemu-guest-agent", "curl", "wget", "vim", "htop", "build-essential"]
}

variable "default_user" {
  description = "Default user for cloud-init"
  type        = string
  default     = "ubuntu"
}

variable "vm_password" {
  description = "Password for the VM user (optional, SSH key preferred)"
  type        = string
  default     = ""
  sensitive   = true
}


variable "timezone" {
  description = "Timezone for the VM"
  type        = string
  default     = "UTC"
}

