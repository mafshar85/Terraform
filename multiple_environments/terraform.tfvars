# terraform.tfvars

# Select which environment to deploy
# selected_environment = "k8s"  # Change this to "gitlab", "k8s", or "ceph"

# Global configuration
libvirt_uri         = "qemu:///system"
base_qcow2_path     = "/home/arye/kvm/ubuntu-22.04.qcow2"
ssh_public_key      = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDCTbrUANn0hUU/ADVW1QIjARrNd9UaxYZ1PNi7VYnPLmm6OaJo1YO7y1yJ7Ulp2YGk+Yitm9qRqhk2ow57uloXdy5M1SSmMwQmzMg0GDTT+/p+FWkx/6OrJDC4jIT4s+/b4g5/WtD/U5IVBc2GsDK3lURUcI1FK8xwE1Cy6Lc8eczNE96emZZWQjc5FmoEPjdk/Dd3MCbzhPoQ2FIJpqgFk8wztaaBdstBj6KMjEQ+S9AGLPIl1e2NJuUOBGIowecRnJ8e5AcXqL1ePUKSEj1cpMaXGPNzoj3t5C8N1CFJjH6uGmsZaJMDL5Aj/QlaYcybKvH3NGbIWZVr2JCyLgJBceRGczcEdF3sLbSl9tqtcXdfqJHH6+Ko+EJx2KW5dW2boZalQUkIwHew7vKm7Qpn0LRPMeUXbwJRKjM43JYr7PT81iGoIRx0Itu/M0qGo752gHAaK/THzHCw/xwj0Gx1uaEUGusCil1AfiCASzLVDNA/nA4HWZQ35F+68UHqtnixcdjOIVmfjDgB5OGaWHwP6SunY8uQ1Zl4JQOCQLnNtt9Ms13+3wNRIUoAdRQySRp3pfCY1LPe625OHojRfZ/ewlxvnPafynlLjVTjAepTiTWXPtjuBnk7RBd00NKOOsPop5YXGTLuyqwmbCAwjJUpLzLPQrZh/PvNYDapO9O03w== mafshar85@hotmail.com"
default_user        = "ubuntu"
default_password    = "$6$acFWB0s19QB9xkge$/HjdAJbqjE6DKjWzx41ZyRSEXy4RcFwCdfA9qSuXaLdfFDDjbQm2RQ4sfGFAUgruKJ8Ji9fdTCq9kgt1.EIWI."
network_interface   = "ens3"
vnc_listen_address  = "127.0.0.1"
wait_for_lease      = false

# You can override the default environment configurations here if needed
# For example, to customize the k8s environment:
# environments = {
#   k8s = {
#     environment     = "k8s"
#     network_cidr    = "192.168.135.0/24"  # Custom network
#     network_gateway = "192.168.135.1"
#     network_name    = "k8s-custom-net"
#     dns_servers     = ["1.1.1.1", "1.0.0.1"]  # Cloudflare DNS
#     storage_pool    = "ssd-pool"  # Custom storage pool
#     enable_cluster_network = false
#     vms = {
#       k8s-master = {
#         name            = "k8s-master"
#         memory_mb       = 6144  # Increased memory
#         vcpus           = 3     # Increased CPU
#         disk_size_bytes = 75161927680   # 70GB
#         packages        = ["docker.io", "kubeadm", "kubelet", "kubectl", "htop", "vim"]
#         timezone        = "America/New_York"  # Custom timezone
#         static_ip       = "192.168.135.10"
#         autostart       = true
#         start_vm        = true
#         enable_cluster_network = false
#       }
#       # ... other VMs
#     }
#   }
# }