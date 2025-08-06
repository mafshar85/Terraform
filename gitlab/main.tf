# File: main.tf

provider "libvirt" {
  uri = var.libvirt_uri
}

# Create custom network for VMs
resource "libvirt_network" "vm_network" {
  name      = "${var.network_name}-static"
  mode      = "nat"
  domain    = "local"
  addresses = [var.network_cidr]
  
  dns {
    enabled = true
  }
  
  dhcp {
    enabled = true
  }
  
  autostart = true
}

#If the existing network
#terraform import libvirt_network.vm_network vm-network-1-static{UUID}
#sudo virsh net-info vm-network-1-static #you can see UUID
#terraform import libvirt_network.vm_network 2f449122-43d0-45d2-bc5e-20883049c879 


# Generate unique MAC for all VMs
resource "random_id" "vm_mac" {
  for_each    = var.vms
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
  name     = "${each.value.name}-base-disk.qcow2"
  pool     = var.storage_pool
  source   = var.base_qcow2_path
  format   = "qcow2"
}

# Create the final disk for each VM
resource "libvirt_volume" "vm_disk" {
  for_each       = var.vms
  name           = "${each.value.name}-disk.qcow2"
  pool           = var.storage_pool
  base_volume_id = libvirt_volume.base[each.key].id
  format         = "qcow2"
  size           = each.value.disk_size_bytes
}



# Create cloud-init disk for each VM (minimal configuration)
resource "libvirt_cloudinit_disk" "commoninit" {
  for_each = var.vms
  name     = "${each.value.name}-commoninit.iso"
  pool     = var.storage_pool

  user_data = templatefile("${path.module}/templates/cloud-init.yaml", {
    hostname = each.value.name
    username = var.default_user
    password = var.default_password  # Default password, should be changed in production
    ssh_keys = var.ssh_public_key
    packages = each.value.packages
    timezone = each.value.timezone
  })

  network_config = templatefile("${path.module}/templates/network_config.yml", {
    interface = var.network_interface
    static_ip = each.value.static_ip
    gateway = var.network_gateway
    dns_servers = var.dns_servers
  })
}

# Create multiple VMs
resource "libvirt_domain" "vm" {
  for_each = var.vms
  name     = each.value.name
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


  network_interface {
    network_id     = libvirt_network.vm_network.id
    wait_for_lease = var.wait_for_lease
    hostname       = each.value.name
    mac            = each.value.mac_address != "" ? each.value.mac_address : format("52:54:00:%02x:%02x:%02x", 
      random_id.vm_mac[each.key].dec % 256,
      (random_id.vm_mac[each.key].dec / 256) % 256,
      (random_id.vm_mac[each.key].dec / 65536) % 256
    )
    addresses      = each.value.static_ip != "" ? [each.value.static_ip] : null
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
