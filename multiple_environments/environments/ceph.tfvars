# environments/ceph.tfvars
# This file provides the configuration for the 'ceph' environment,
# nested within the 'environments' map as required by the root module.

environments = {
  ceph = {
    # Environment configuration
    environment = "ceph"

    # Public network configuration (for client access and mon communication)
    network_cidr    = "192.168.140.0/24"
    network_gateway = "192.168.140.1"
    network_name    = "ceph-public"
    dns_servers     = ["8.8.8.8", "8.8.4.4"]

    # Cluster network configuration (for OSD replication and recovery traffic)
    enable_cluster_network   = true
    cluster_network_cidr     = "10.140.0.0/24"
    cluster_network_gateway  = "10.140.0.1"
    cluster_network_name     = "ceph-cluster"

    # Storage
    storage_pool = "default"

    # VM definitions
    vms = {
      ceph-mon1 = {
        name              = "mon1"
        memory_mb         = 2048
        vcpus             = 2
        disk_size_bytes   = 53687091200   # 50GB
        timezone          = "UTC"
        packages        = ["build-essential", "qemu-guest-agent", "curl", "wget", "vim", "htop", "net-tools"]
        static_ip         = "192.168.140.10"
        cluster_ip        = "10.140.0.10"
        autostart         = true
        start_vm          = true
        enable_cluster_network = true
      }
      
      ceph-mon2 = {
        name              = "mon2"
        memory_mb         = 2048
        vcpus             = 2
        disk_size_bytes   = 53687091200   # 50GB
        packages        = ["build-essential", "qemu-guest-agent", "curl", "wget", "vim", "htop", "net-tools"]
        timezone          = "UTC"
        static_ip         = "192.168.140.11"
        cluster_ip        = "10.140.0.11"
        autostart         = true
        start_vm          = true
        enable_cluster_network = true
      }
      
      ceph-mon3 = {
        name              = "mon3"
        memory_mb         = 2048
        vcpus             = 2
        disk_size_bytes   = 53687091200   # 50GB
        packages        = ["build-essential", "qemu-guest-agent", "curl", "wget", "vim", "htop", "net-tools"]
        timezone          = "UTC"
        static_ip         = "192.168.140.12"
        cluster_ip        = "10.140.0.12"
        autostart         = true
        start_vm          = true
        enable_cluster_network = true
      }
      
      ceph-osd1 = {
        name              = "osd1"
        memory_mb         = 4096
        vcpus             = 2
        disk_size_bytes   = 107374182400  # 100GB
        packages        = ["build-essential", "qemu-guest-agent", "curl", "wget", "vim", "htop", "net-tools"]
        timezone          = "UTC"
        static_ip         = "192.168.140.20"
        cluster_ip        = "10.140.0.20"
        autostart         = true
        start_vm          = true
        enable_cluster_network = true
      }
      
      ceph-osd2 = {
        name              = "osd2"
        memory_mb         = 4096
        vcpus             = 2
        disk_size_bytes   = 107374182400  # 100GB
        packages        = ["build-essential", "qemu-guest-agent", "curl", "wget", "vim", "htop", "net-tools"]
        timezone          = "UTC"
        static_ip         = "192.168.140.21"
        cluster_ip        = "10.140.0.21"
        autostart         = true
        start_vm          = true
        enable_cluster_network = true
      }
      
      ceph-osd3 = {
        name              = "osd3"
        memory_mb         = 4096
        vcpus             = 2
        disk_size_bytes   = 107374182400  # 100GB
        packages        = ["build-essential", "qemu-guest-agent", "curl", "wget", "vim", "htop", "net-tools"]
        timezone          = "UTC"
        static_ip         = "192.168.140.22"
        cluster_ip        = "10.140.0.22"
        autostart         = true
        start_vm          = true
        enable_cluster_network = true
      }
    }
  }
}
