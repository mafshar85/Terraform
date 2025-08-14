# modules/kvm-vms/main.tf

terraform {
  required_providers {
    libvirt = {
      source  = "dmacvicar/libvirt"
    }
    random = {
      source  = "hashicorp/random"
    }
  }
}

# Create custom network for VMs (public/management network)
resource "libvirt_network" "vm_network" {
  name      = "${var.network_name}-static"
  mode      = "nat"
  domain    = "${var.environment}.local"
  addresses = [var.network_cidr]
  
  dns {
    enabled = true
  }
  
  dhcp {
    enabled = true
  }
  
  autostart = true
}

# Create cluster network (for Ceph OSD replication traffic)
resource "libvirt_network" "cluster_network" {
  count = var.enable_cluster_network ? 1 : 0
  
  name      = "${var.cluster_network_name}-${var.environment}"
  mode      = "nat"
  domain    = "${var.environment}-cluster.local"
  addresses = [var.cluster_network_cidr]
  
  dns {
    enabled = true
  }
  
  dhcp {
    enabled = true
  }
  
  autostart = true
}

# Generate unique MAC for all VMs (public network)
resource "random_id" "vm_mac" {
  for_each    = var.vms
  byte_length = 3
}

# Generate unique MAC for cluster network
resource "random_id" "cluster_mac" {
  for_each    = { for k, v in var.vms : k => v if v.enable_cluster_network == true }
  byte_length = 3
}

# Generate random ID for unique instance per VM
resource "random_id" "vm_id" {
  for_each    = var.vms
  byte_length = 4
}

# Create a copy of base qcow2 image for each VM
resource "libvirt_volume" "base" {
  for_each = var.vms
  name     = "${each.value.name}-${var.environment}-base-disk.qcow2"
  pool     = var.storage_pool
  source   = var.base_qcow2_path
  format   = "qcow2"
}

# Create the final disk for each VM
resource "libvirt_volume" "vm_disk" {
  for_each       = var.vms
  name           = "${each.value.name}-${var.environment}-disk.qcow2"
  pool           = var.storage_pool
  base_volume_id = libvirt_volume.base[each.key].id
  format         = "qcow2"
  size           = each.value.disk_size_bytes
}

# Create cloud-init disk for each VM
resource "libvirt_cloudinit_disk" "commoninit" {
  for_each = var.vms
  name     = "${each.value.name}-${var.environment}-commoninit.iso"
  pool     = var.storage_pool

  user_data = templatefile("${path.module}/templates/cloud-init.yaml", {
    hostname    = "${var.environment}-${each.value.name}"
    environment = var.environment
    username    = var.default_user
    password    = var.default_password
    ssh_keys    = var.ssh_public_key
    ssh_port    = var.ssh_port
    packages    = each.value.packages
    timezone    = each.value.timezone
  })

  network_config = templatefile("${path.module}/templates/network_config.yml", {
    interface        = var.network_interface
    static_ip        = each.value.static_ip
    gateway          = var.network_gateway
    dns_servers      = var.dns_servers
    enable_cluster   = each.value.enable_cluster_network
    cluster_ip       = try(each.value.cluster_ip, "")
    cluster_interface = "ens4"
    cluster_gateway   = var.cluster_network_gateway
  })
}

# Create multiple VMs
resource "libvirt_domain" "vm" {
  for_each = var.vms
  name     = "${var.environment}-${each.value.name}"
  memory   = each.value.memory_mb
  vcpu     = each.value.vcpus

  cloudinit = libvirt_cloudinit_disk.commoninit[each.key].id
  
  boot_device {
    dev = ["hd"]
  }

  # Primary disk
  disk {
    volume_id = libvirt_volume.vm_disk[each.key].id
  }

  # Public/Management network interface
  network_interface {
    network_id = libvirt_network.vm_network.id
    mac = each.value.mac_address != "" ? each.value.mac_address : format("52:54:00:%02x:%02x:%02x",
       random_id.vm_mac[each.key].dec % 256,
       floor(random_id.vm_mac[each.key].dec / 256) % 256,
       floor(random_id.vm_mac[each.key].dec / 65536) % 256
)  
    addresses      = each.value.static_ip != "" ? [each.value.static_ip] : null
  }

  # Cluster network interface (only for VMs that need it)
  dynamic "network_interface" {
    for_each = each.value.enable_cluster_network ? [1] : []
    content {
      network_id     = libvirt_network.cluster_network[0].id
      wait_for_lease = var.wait_for_lease
      hostname       = "${each.value.name}-cluster"
      mac            = format("52:54:01:%02x:%02x:%02x",
        random_id.cluster_mac[each.key].dec % 256,
        (random_id.cluster_mac[each.key].dec / 256) % 256,
        (random_id.cluster_mac[each.key].dec / 65536) % 256
      )
      addresses      = each.value.cluster_ip != "" ? [each.value.cluster_ip] : null
    }
  }

  console {
    type        = "pty"
    target_port = "0"
    target_type = "serial"
  }

  console {
    type        = "pty"
    target_type = "virtio"
    target_port = "1"
  }

  graphics {
    type           = "vnc"
    listen_type    = "address"
    listen_address = var.vnc_listen_address
    autoport       = true
  }

  cpu {
    mode = "host-passthrough"
  }

  autostart = each.value.autostart
  running   = each.value.start_vm

  lifecycle {
    ignore_changes = [running]
  }
}