# File: terraform.tfvars

# Network configuration
network_cidr    = "192.168.110.0/24"
network_gateway = "192.168.110.1"
dns_servers     = ["8.8.8.8", "8.8.4.4"]



# Define multiple VMs with static IPs
vms = {
  #  gitlab server VM
  gitlab-server-01 = {
    name            = "gitlab-ce-01"
    memory_mb       = 2048
    vcpus           = 2
    disk_size_bytes = 42949672960 # 40GB
    packages        = ["build-essential", "qemu-guest-agent", "curl", "wget", "vim", "htop", "net-tools"]
    timezone        = "UTC"
    static_ip       = "192.168.110.20"
    mac_address     = "52:54:00:12:34:20"
    autostart       = true
    start_vm        = true
  }
  
  # runner server VM
  gitlab-runner-01 = {
    name            = "gitlab-runner-01"
    memory_mb       = 2048
    vcpus           = 2
    disk_size_bytes = 42949672960 # 40GB
    packages        = ["build-essential", "qemu-guest-agent", "curl", "wget", "vim", "htop", "net-tools"]
    timezone        = "UTC"
    static_ip       = "192.168.110.21"
    mac_address     = "52:54:00:12:34:21"
    autostart       = true
    start_vm        = true
  }
}

# Common settings for all VMs
storage_pool        = "my-pool"
base_qcow2_path     = "/home/arye/kvm/ubuntu-22.04.qcow2"
network_name        = "vm-network-1"
ssh_public_key      = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDCTbrUANn0hUU/ADVW1QIjARrNd9UaxYZ1PNi7VYnPLmm6OaJo1YO7y1yJ7Ulp2YGk+Yitm9qRqhk2ow57uloXdy5M1SSmMwQmzMg0GDTT+/p+FWkx/6OrJDC4jIT4s+/b4g5/WtD/U5IVBc2GsDK3lURUcI1FK8xwE1Cy6Lc8eczNE96emZZWQjc5FmoEPjdk/Dd3MCbzhPoQ2FIJpqgFk8wztaaBdstBj6KMjEQ+S9AGLPIl1e2NJuUOBGIowecRnJ8e5AcXqL1ePUKSEj1cpMaXGPNzoj3t5C8N1CFJjH6uGmsZaJMDL5Aj/QlaYcybKvH3NGbIWZVr2JCyLgJBceRGczcEdF3sLbSl9tqtcXdfqJHH6+Ko+EJx2KW5dW2boZalQUkIwHew7vKm7Qpn0LRPMeUXbwJRKjM43JYr7PT81iGoIRx0Itu/M0qGo752gHAaK/THzHCw/xwj0Gx1uaEUGusCil1AfiCASzLVDNA/nA4HWZQ35F+68UHqtnixcdjOIVmfjDgB5OGaWHwP6SunY8uQ1Zl4JQOCQLnNtt9Ms13+3wNRIUoAdRQySRp3pfCY1LPe625OHojRfZ/ewlxvnPafynlLjVTjAepTiTWXPtjuBnk7RBd00NKOOsPop5YXGTLuyqwmbCAwjJUpLzLPQrZh/PvNYDapO9O03w== mafshar85@hotmail.com"
default_user        = "ubuntu"
# wait_for_lease is now false by default in variables.tf, so no need to specify here unless you want to override it.


