vm_name         = "cloud-vm"
memory_mb       = 2048
vcpus           = 2
disk_size_bytes = 21474836480 # 20GB
storage_pool    = "my-pool"
#base_image_path = "/var/lib/libvirt/images/ubuntu-22.04.qcow2"
# Base image path - UPDATE THIS with your actual qcow2 path
base_qcow2_path   = "/home/arye/kvm/ubuntu-22.04.qcow2"
network_name      = "default"
enable_cloud_init = true
ssh_public_keys = [

]
#iso_path = "" # optional: /var/lib/libvirt/images/ubuntu.iso

# SSH Configuration - UPDATE THESE with your actual keys
ssh_public_key       = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDCTbrUANn0hUU/ADVW1QIjARrNd9UaxYZ1PNi7VYnPLmm6OaJo1YO7y1yJ7Ulp2YGk+Yitm9qRqhk2ow57uloXdy5M1SSmMwQmzMg0GDTT+/p+FWkx/6OrJDC4jIT4s+/b4g5/WtD/U5IVBc2GsDK3lURUcI1FK8xwE1Cy6Lc8eczNE96emZZWQjc5FmoEPjdk/Dd3MCbzhPoQ2FIJpqgFk8wztaaBdstBj6KMjEQ+S9AGLPIl1e2NJuUOBGIowecRnJ8e5AcXqL1ePUKSEj1cpMaXGPNzoj3t5C8N1CFJjH6uGmsZaJMDL5Aj/QlaYcybKvH3NGbIWZVr2JCyLgJBceRGczcEdF3sLbSl9tqtcXdfqJHH6+Ko+EJx2KW5dW2boZalQUkIwHew7vKm7Qpn0LRPMeUXbwJRKjM43JYr7PT81iGoIRx0Itu/M0qGo752gHAaK/THzHCw/xwj0Gx1uaEUGusCil1AfiCASzLVDNA/nA4HWZQ35F+68UHqtnixcdjOIVmfjDgB5OGaWHwP6SunY8uQ1Zl4JQOCQLnNtt9Ms13+3wNRIUoAdRQySRp3pfCY1LPe625OHojRfZ/ewlxvnPafynlLjVTjAepTiTWXPtjuBnk7RBd00NKOOsPop5YXGTLuyqwmbCAwjJUpLzLPQrZh/PvNYDapO9O03w== mafshar85@hotmail.com"


# Custom packages to install
packages = ["qemu-guest-agent", "curl", "wget", "vnstat", "git", "vim", "htop", "tree", "jq", "build-essential", "python3-pip"]