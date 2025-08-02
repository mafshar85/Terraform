# File: terraform.tfvars (Updated for Multiple VMs)

# Define multiple VMs
vms = {
  # Web server VM
  web-server = {
    name            = "web-server"
    memory_mb       = 2048
    vcpus           = 2
    disk_size_bytes = 21474836480 # 20GB
    packages        = ["nginx", "curl", "wget", "vim", "htop", "qemu-guest-agent"]
    timezone        = "UTC"
    autostart       = true
    start_vm        = true
  }
  
  # Database server VM
  db-server = {
    name            = "db-server"
    memory_mb       = 2048
    vcpus           = 2
    disk_size_bytes = 42949672960 # 40GB
    packages        = [ "curl", "wget", "vim", "htop", "qemu-guest-agent"]
  # packages        = ["postgresql", "postgresql-contrib", "curl", "wget", "vim", "htop", "qemu-guest-agent"]
    timezone        = "UTC"
    autostart       = true
    start_vm        = true
  }
  
  # Development VM
#   dev-machine = {
#     name            = "dev-machine"
#     memory_mb       = 3072
#     vcpus           = 3
#     disk_size_bytes = 32212254720 # 30GB
#     packages        = ["git", "docker.io", "docker-compose", "nodejs", "npm", "python3", "python3-pip", "curl", "wget", "vim", "htop", "tree", "jq", "build-essential", "qemu-guest-agent"]
#     timezone        = "America/New_York"
#     mac_address     = "" # Leave empty for auto-generated
#     autostart       = true
#     start_vm        = true
#   }
  
#   # Monitoring VM
#   monitor = {
#     name            = "monitor"
#     memory_mb       = 1024
#     vcpus           = 1
#     disk_size_bytes = 16106127360 # 15GB
#     packages        = ["prometheus", "grafana", "curl", "wget", "vim", "htop", "qemu-guest-agent"]
#     timezone        = "UTC"
#     autostart       = true
#     start_vm        = true
#   }
}

# Common settings for all VMs
storage_pool        = "my-pool"
base_qcow2_path     = "/home/arye/kvm/ubuntu-22.04.qcow2"
network_name        = "default"
ssh_public_key      = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDCTbrUANn0hUU/ADVW1QIjARrNd9UaxYZ1PNi7VYnPLmm6OaJo1YO7y1yJ7Ulp2YGk+Yitm9qRqhk2ow57uloXdy5M1SSmMwQmzMg0GDTT+/p+FWkx/6OrJDC4jIT4s+/b4g5/WtD/U5IVBc2GsDK3lURUcI1FK8xwE1Cy6Lc8eczNE96emZZWQjc5FmoEPjdk/Dd3MCbzhPoQ2FIJpqgFk8wztaaBdstBj6KMjEQ+S9AGLPIl1e2NJuUOBGIowecRnJ8e5AcXqL1ePUKSEj1cpMaXGPNzoj3t5C8N1CFJjH6uGmsZaJMDL5Aj/QlaYcybKvH3NGbIWZVr2JCyLgJBceRGczcEdF3sLbSl9tqtcXdfqJHH6+Ko+EJx2KW5dW2boZalQUkIwHew7vKm7Qpn0LRPMeUXbwJRKjM43JYr7PT81iGoIRx0Itu/M0qGo752gHAaK/THzHCw/xwj0Gx1uaEUGusCil1AfiCASzLVDNA/nA4HWZQ35F+68UHqtnixcdjOIVmfjDgB5OGaWHwP6SunY8uQ1Zl4JQOCQLnNtt9Ms13+3wNRIUoAdRQySRp3pfCY1LPe625OHojRfZ/ewlxvnPafynlLjVTjAepTiTWXPtjuBnk7RBd00NKOOsPop5YXGTLuyqwmbCAwjJUpLzLPQrZh/PvNYDapO9O03w== mafshar85@hotmail.com"
default_user        = "ubuntu"