

# File: main.tf (Updated)

provider "libvirt" {
  uri = var.libvirt_uri
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

# Create cloud-init disk for each VM
resource "libvirt_cloudinit_disk" "commoninit" {
  for_each = var.vms
  name     = "${each.value.name}-commoninit.iso"
  pool     = var.storage_pool

  user_data = templatefile("${path.module}/templates/cloud-init.yaml", {
    hostname = each.value.name
    username = var.default_user
    ssh_keys = var.ssh_public_key
    packages = each.value.packages
    timezone = each.value.timezone
  })

  network_config = templatefile("${path.module}/templates/network_config.yml", {
    interface = var.network_interface
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

  disk {
    volume_id = libvirt_volume.vm_disk[each.key].id
  }

  network_interface {
    network_name   = var.network_name
    wait_for_lease = var.wait_for_lease
    hostname       = each.value.name
    mac            = each.value.mac_address != "" ? each.value.mac_address : null
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

