# environments/k8s.tfvars
# This file provides the configuration for the 'k8s' environment,
# nested within the 'environments' map as required by the root module.

environments = {
  k8s = {
    # Environment configuration
    environment     = "k8s"

    # Network configuration
    network_cidr    = "192.168.130.0/24"
    network_gateway = "192.168.130.1"
    network_name    = "k8s-public"
    dns_servers     = ["8.8.8.8", "8.8.4.4"]

    # Cluster network (not needed for k8s)
    # This should be a variable in the module itself
    # and passed if needed. We'll set it here for completeness
    # of the expected object.
    enable_cluster_network = false

    # Storage
    storage_pool = "my-pool"

    # VM definitions
    vms = {
      k8s-master-01 = {
        name              = "master-01"
        memory_mb         = 4096
        vcpus             = 2
        disk_size_bytes   = 53687091200   # 50GB
        packages        = ["build-essential", "qemu-guest-agent", "curl", "wget", "vim", "htop", "net-tools"]
        timezone          = "UTC"
        static_ip         = "192.168.130.10"
        autostart         = true
        start_vm          = true
      }

      k8s-worker1 = {
        name              = "worker1"
        memory_mb         = 2048
        vcpus             = 2
        disk_size_bytes   = 85899345920   # 80GB
        packages        = ["build-essential", "qemu-guest-agent", "curl", "wget", "vim", "htop", "net-tools"]
        timezone          = "UTC"
        static_ip         = "192.168.130.11"
        autostart         = true
        start_vm          = true
      }

      k8s-worker2 = {
        name              = "worker2"
        memory_mb         = 2048
        vcpus             = 2
        disk_size_bytes   = 85899345920  # 80GB
        packages        = ["build-essential", "qemu-guest-agent", "curl", "wget", "vim", "htop", "net-tools"]
        timezone          = "UTC"
        static_ip         = "192.168.130.12"
        autostart         = true
        start_vm          = true
      }
    }
  }
}
