# Terraform KVM Multi-Environment Setup

This repository provides a Terraform-based infrastructure-as-code solution for deploying multiple virtual machine environments using KVM/libvirt on a local system. It supports deploying different environments (GitLab, Kubernetes, Ceph) with dedicated networking and VM configurations.

## 📋 Table of Contents

- [Features](#features)
- [Prerequisites](#prerequisites)
- [Quick Start](#quick-start)
- [Environment Configurations](#environment-configurations)
- [Usage](#usage)
- [Network Architecture](#network-architecture)
- [Customization](#customization)
- [Troubleshooting](#troubleshooting)
- [File Structure](#file-structure)

## ✨ Features

- **Multi-Environment Support**: Deploy GitLab, Kubernetes, or Ceph environments independently
- **Dual Network Configuration**: Public network for management and optional cluster network for internal communication
- **Cloud-Init Integration**: Automated VM provisioning with custom packages and configurations
- **Static IP Assignment**: Predictable IP addresses for all VMs
- **Flexible VM Sizing**: Customizable CPU, memory, and disk configurations per environment
- **SSH Key Management**: Automated SSH key deployment for secure access
- **Environment Isolation**: Each environment uses separate networks and naming conventions

## 🔧 Prerequisites

### System Requirements
- Linux host system (tested on Ubuntu/Debian)
- KVM/QEMU virtualization support
- libvirt installed and configured
- Terraform >= 1.0
- Sufficient system resources (RAM, disk space, CPU cores)

### Software Installation

```bash
# Install KVM/QEMU and libvirt
sudo apt update
sudo apt install -y qemu-kvm libvirt-daemon-system libvirt-clients bridge-utils virt-manager

# Add your user to libvirt group
sudo usermod -aG libvirt $USER
sudo usermod -aG kvm $USER

# Install Terraform
wget -O- https://apt.releases.hashicorp.com/gpg | sudo gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg
echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com jammy main" | sudo tee /etc/apt/sources.list.d/hashicorp.list
sudo apt update && sudo apt install terraform

# Verify libvirt is running
sudo systemctl enable libvirtd
sudo systemctl start libvirtd
```

### Download Ubuntu Base Image

```bash
# Create directory for images
mkdir -p ~/kvm

# Download Ubuntu 22.04 cloud image
cd ~/kvm
wget https://cloud-images.ubuntu.com/jammy/current/jammy-server-cloudimg-amd64.img
mv jammy-server-cloudimg-amd64.img ubuntu-22.04.qcow2

# Or use a direct link for the latest image
curl -L -o ubuntu-22.04.qcow2 https://cloud-images.ubuntu.com/jammy/current/jammy-server-cloudimg-amd64.img
```

## 🚀 Quick Start

### 1. Clone and Setup

```bash
git clone <your-repo-url>
cd multiple_environments

# Copy and edit the configuration file
cp terraform.tfvars.example terraform.tfvars
```

### 2. Configure SSH Key

Generate an SSH key pair if you don't have one:

```bash
# Generate SSH key
ssh-keygen -t rsa -b 4096 -C "your-email@domain.com"

# Copy public key content
cat ~/.ssh/id_rsa.pub
```

### 3. Edit Configuration

Update `terraform.tfvars`:

```hcl
# Select environment to deploy
selected_environment = "k8s"  # Options: "gitlab", "k8s", "ceph"

# Update paths and keys
base_qcow2_path = "/home/yourusername/kvm/ubuntu-22.04.qcow2"
ssh_public_key  = "ssh-rsa AAAAB3NzaC1yc2E... your-public-key-here"

# Optional: customize other settings
libvirt_uri = "qemu:///system"
default_user = "ubuntu"
```

### 4. Deploy Environment

```bash
# Initialize Terraform
terraform init

# Plan deployment
terraform plan -var="selected_environment=k8s"

# Apply configuration
terraform apply -var="selected_environment=k8s"
```

### 5. Access VMs

After deployment, get VM information:

```bash
# Show all outputs
terraform output

# Get specific VM IPs
terraform output vm_ips

# SSH to a VM (example for k8s master)
ssh ubuntu@192.168.130.10 -p 8822
```

## 🏗️ Environment Configurations

### GitLab Environment
- **Network**: 192.168.120.0/24
- **VMs**:
  - GitLab Server: 8GB RAM, 4 vCPUs, 100GB disk
  - GitLab Runner: 4GB RAM, 2 vCPUs, 50GB disk
- **Use Case**: CI/CD pipeline setup

### Kubernetes Environment
- **Network**: 192.168.130.0/24
- **VMs**:
  - K8s Master: 4GB RAM, 2 vCPUs, 50GB disk
  - K8s Worker1: 2GB RAM, 2 vCPUs, 80GB disk
  - K8s Worker2: 2GB RAM, 2 vCPUs, 80GB disk
- **Use Case**: Container orchestration cluster

### Ceph Environment
- **Networks**: 
  - Public: 192.168.140.0/24 (client access, monitor communication)
  - Cluster: 10.140.0.0/24 (OSD replication, recovery)
- **VMs**:
  - 3x Monitor nodes: 2GB RAM, 2 vCPUs, 50GB disk
  - 3x OSD nodes: 4GB RAM, 2 vCPUs, 100GB disk
- **Use Case**: Distributed storage cluster

## 📊 Network Architecture

### Single Network (GitLab, K8s)
```
Host System
├── libvirt NAT Network (192.168.X.0/24)
└── VMs with static IPs
    ├── Management Interface (ens3)
    └── SSH access on port 8822
```

### Dual Network (Ceph)
```
Host System
├── Public Network (192.168.140.0/24)
│   └── Client access, monitor communication
└── Cluster Network (10.140.0.0/24)
    └── OSD replication, recovery traffic
```

## ⚙️ Customization

### Adding New Environment

1. Create new tfvars file:
```bash
# Create environments/myenv.tfvars
environments = {
  myenv = {
    environment = "myenv"
    network_cidr = "192.168.150.0/24"
    network_gateway = "192.168.150.1"
    network_name = "myenv-network"
    dns_servers = ["8.8.8.8", "8.8.4.4"]
    storage_pool = "default"
    enable_cluster_network = false
    vms = {
      myvm = {
        name = "myvm"
        memory_mb = 2048
        vcpus = 2
        disk_size_bytes = 53687091200  # 50GB
        packages = ["htop", "vim", "curl"]
        timezone = "UTC"
        static_ip = "192.168.150.10"
        autostart = true
        start_vm = true
        enable_cluster_network = false
      }
    }
  }
}
```

2. Deploy the new environment:
```bash
terraform apply -var="selected_environment=myenv" -var-file="environments/myenv.tfvars"
```

### Modifying VM Specifications

Edit the respective environment file or override in `terraform.tfvars`:

```hcl
environments = {
  k8s = {
    # ... other settings
    vms = {
      k8s-master-01 = {
        name = "master-01"
        memory_mb = 8192        # Increased memory
        vcpus = 4               # More CPUs
        disk_size_bytes = 107374182400  # 100GB disk
        # ... other settings
      }
    }
  }
}
```

## 🔍 Troubleshooting

### Common Issues

1. **Permission Denied**
```bash
# Fix libvirt permissions
sudo usermod -aG libvirt $USER
sudo usermod -aG kvm $USER
# Log out and log back in
```

2. **VM Not Getting IP Address**
```bash
# Check libvirt networks
sudo virsh net-list --all
sudo virsh net-start default

# Check VM status
sudo virsh list --all
sudo virsh dominfo <vm-name>
```

3. **SSH Connection Issues**
```bash
# VMs use custom SSH port 8822
ssh ubuntu@<vm-ip> -p 8822

# Check if VM is fully booted
sudo virsh console <vm-name>
```

4. **Insufficient Resources**
```bash
# Check available resources
free -h
df -h
nproc

# Adjust VM specifications in configuration
```

### Useful Commands

```bash
# List all VMs
sudo virsh list --all

# Start/stop a VM
sudo virsh start <vm-name>
sudo virsh shutdown <vm-name>

# Check network status
sudo virsh net-list
sudo virsh net-info <network-name>

# View VM console
sudo virsh console <vm-name>

# Clean up resources
terraform destroy -var="selected_environment=k8s"
```

## 📁 File Structure

```
multiple_environments/
├── main.tf                          # Root module configuration
├── variables.tf                     # Root module variables
├── outputs.tf                       # Root module outputs
├── terraform.tfvars                 # Main configuration file
├── environments/                    # Environment-specific configurations
│   ├── ceph.tfvars                 # Ceph cluster setup
│   ├── gitlab.tfvars               # GitLab CI/CD setup
│   └── k8s.tfvars                  # Kubernetes cluster setup
└── modules/
    └── kvm-vms/                    # Reusable VM module
        ├── main.tf                 # Module resources
        ├── variables.tf            # Module variables
        ├── outputs.tf              # Module outputs
        └── templates/
            ├── cloud-init.yaml     # VM initialization template
            └── network_config.yml  # Network configuration template
```

## 📝 Configuration Files

- **`terraform.tfvars`**: Main configuration file with global settings
- **`environments/*.tfvars`**: Environment-specific configurations
- **`modules/kvm-vms/`**: Reusable module for VM creation
- **`templates/`**: Cloud-init and network configuration templates

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Test with different environments
5. Submit a pull request

## 📄 License

This project is licensed under the MIT License - see the LICENSE file for details.

## 🆘 Support

For issues and questions:
1. Check the troubleshooting section
2. Review libvirt and Terraform documentation
3. Open an issue with detailed error logs and system information

---

**Note**: This setup is designed for local development and testing environments. For production use, consider additional security hardening and backup strategies.