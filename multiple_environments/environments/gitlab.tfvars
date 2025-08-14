# environments/gitlab.tfvars
# This file provides the configuration for the 'gitlab' environment,
# nested within the 'environments' map as required by the root module.

environments = {
  gitlab = {
    # Environment configuration
    environment = "gitlab"

    # Network configuration
    network_cidr    = "192.168.120.0/24"
    network_gateway = "192.168.120.1"
    network_name    = "gitlab-public"
    dns_servers     = ["8.8.8.8", "8.8.4.4"]

    # Storage
    storage_pool = "default"
    
    # Enable cluster network (moved to the environment block)
    enable_cluster_network = false

    # VM definitions
    vms = {
      gitlab-server = {
        name              = "server-01"
        memory_mb         = 8192
        vcpus             = 4
        disk_size_bytes   = 107374182400   # 100GB
        packages        = ["build-essential", "qemu-guest-agent", "curl", "wget", "vim", "htop", "net-tools"]
        timezone          = "UTC"
        static_ip         = "192.168.120.10"
        autostart         = true
        start_vm          = true
        enable_cluster_network = false
      }
      
      gitlab-runner = {
        name              = "runner-01"
        memory_mb         = 4096
        vcpus             = 2
        disk_size_bytes   = 53687091200   # 50GB
        packages        = ["build-essential", "qemu-guest-agent", "curl", "wget", "vim", "htop", "net-tools"]
        timezone          = "UTC"
        static_ip         = "192.168.120.11"
        autostart         = true
        start_vm          = true
        enable_cluster_network = false
      } 

    }
  }
}
