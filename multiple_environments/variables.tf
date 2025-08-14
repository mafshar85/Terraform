# variables.tf (Root Module)

# Environment configurations - define different environments here
variable "environments" {
  description = "Configuration for different environments"
  type = map(object({
    environment                = string
    network_cidr              = string
    network_gateway           = string
    network_name              = string
    dns_servers               = list(string)
    storage_pool              = string
    enable_cluster_network    = optional(bool, false)
    cluster_network_cidr      = optional(string, "10.0.0.0/24")
    cluster_network_gateway   = optional(string, "10.0.0.1")
    cluster_network_name      = optional(string, "cluster")
    vms = map(object({
      name                   = string
      memory_mb              = number
      vcpus                  = number
      disk_size_bytes        = number
      packages               = list(string)
      timezone               = optional(string, "UTC")
      mac_address            = optional(string, "")
      static_ip              = optional(string, "")
      cluster_ip             = optional(string, "")
      autostart              = optional(bool, true)
      start_vm               = optional(bool, true)
      enable_cluster_network = optional(bool, false)
    }))
  }))
  
  # Default example configurations
  default = {
    gitlab = {
      environment     = "gitlab"
      network_cidr    = "192.168.120.0/24"
      network_gateway = "192.168.120.1"
      network_name    = "gitlab-net"
      dns_servers     = ["8.8.8.8", "8.8.4.4"]
      storage_pool    = "default"
      enable_cluster_network = false
      vms = {
        gitlab-server = {
          name            = "gitlab-server"
          memory_mb       = 8192
          vcpus           = 4
          disk_size_bytes = 107374182400  # 100GB
          packages        = ["docker.io", "docker-compose", "git", "curl"]
          timezone        = "UTC"
          static_ip       = "192.168.120.10"
          autostart       = true
          start_vm        = true
          enable_cluster_network = false
        }
        gitlab-runner = {
          name            = "gitlab-runner"
          memory_mb       = 4096
          vcpus           = 2
          disk_size_bytes = 53687091200   # 50GB
          packages        = ["docker.io", "git", "curl"]
          timezone        = "UTC"
          static_ip       = "192.168.120.11"
          autostart       = true
          start_vm        = true
          enable_cluster_network = false
        }
      }
    }
    
    k8s = {
      environment     = "k8s"
      network_cidr    = "192.168.130.0/24"
      network_gateway = "192.168.130.1"
      network_name    = "k8s-net"
      dns_servers     = ["8.8.8.8", "8.8.4.4"]
      storage_pool    = "default"
      enable_cluster_network = false
      vms = {
        k8s-master = {
          name            = "k8s-master"
          memory_mb       = 4096
          vcpus           = 2
          disk_size_bytes = 53687091200   # 50GB
          packages        = ["docker.io", "kubeadm", "kubelet", "kubectl"]
          timezone        = "UTC"
          static_ip       = "192.168.130.10"
          autostart       = true
          start_vm        = true
          enable_cluster_network = false
        }
        k8s-worker1 = {
          name            = "k8s-worker1"
          memory_mb       = 2048
          vcpus           = 2
          disk_size_bytes = 32212254720   # 30GB
          packages        = ["docker.io", "kubeadm", "kubelet"]
          timezone        = "UTC"
          static_ip       = "192.168.130.11"
          autostart       = true
          start_vm        = true
          enable_cluster_network = false
        }
        k8s-worker2 = {
          name            = "k8s-worker2"
          memory_mb       = 2048
          vcpus           = 2
          disk_size_bytes = 32212254720   # 30GB
          packages        = ["docker.io", "kubeadm", "kubelet"]
          timezone        = "UTC"
          static_ip       = "192.168.130.12"
          autostart       = true
          start_vm        = true
          enable_cluster_network = false
        }
      }
    }
    
    ceph = {
      environment     = "ceph"
      network_cidr    = "192.168.140.0/24"
      network_gateway = "192.168.140.1"
      network_name    = "ceph-net"
      dns_servers     = ["8.8.8.8", "8.8.4.4"]
      storage_pool    = "default"
      enable_cluster_network = true
      cluster_network_cidr   = "10.140.0.0/24"
      cluster_network_gateway = "10.140.0.1"
      cluster_network_name   = "ceph-cluster"
      vms = {
        ceph-mon1 = {
          name            = "ceph-mon1"
          memory_mb       = 2048
          vcpus           = 2
          disk_size_bytes = 53687091200   # 50GB
          packages        = ["ceph", "ceph-mon", "ceph-mgr"]
          timezone        = "UTC"
          static_ip       = "192.168.140.10"
          cluster_ip      = "10.140.0.10"
          autostart       = true
          start_vm        = true
          enable_cluster_network = true
        }
        ceph-osd1 = {
          name            = "ceph-osd1"
          memory_mb       = 4096
          vcpus           = 2
          disk_size_bytes = 107374182400  # 100GB
          packages        = ["ceph", "ceph-osd"]
          timezone        = "UTC"
          static_ip       = "192.168.140.11"
          cluster_ip      = "10.140.0.11"
          autostart       = true
          start_vm        = true
          enable_cluster_network = true
        }
        ceph-osd2 = {
          name            = "ceph-osd2"
          memory_mb       = 4096
          vcpus           = 2
          disk_size_bytes = 107374182400  # 100GB
          packages        = ["ceph", "ceph-osd"]
          timezone        = "UTC"
          static_ip       = "192.168.140.12"
          cluster_ip      = "10.140.0.12"
          autostart       = true
          start_vm        = true
          enable_cluster_network = true
        }
      }
    }
  }
}

# Global/Common variables
variable "libvirt_uri" {
  description = "Libvirt connection URI"
  type        = string
  default     = "qemu:///system"
}

variable "base_qcow2_path" {
  description = "Path to your base qcow2 image"
  type        = string
}

variable "ssh_public_key" {
  description = "SSH public key for accessing the VMs"
  type        = string
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
  default     = false
}