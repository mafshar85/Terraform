

provider "libvirt" {
  uri = var.libvirt_uri
}

# Generate random ID for unique instance
resource "random_id" "vm_id" {
  byte_length = 4
}

# 1. Create a copy of your base qcow2 image for the VM.
#    This resource ensures we have a separate, writable disk.
resource "libvirt_volume" "base" {
  name   = "${var.vm_name}-disk.qcow2"
  pool   = var.storage_pool
  source = var.base_qcow2_path
  format = "qcow2"
}

#qemu-img resize ubuntu-22.04.qcow2 20G   #it is better insted step 2. and you can apply before runing terraform

# 2. Create the final disk for the VM based on the copy.
#    This is where we apply the desired size.
resource "libvirt_volume" "vm_disk" {
  name           = "${var.vm_name}-disk.qcow2"
  pool           = var.storage_pool
  base_volume_id = libvirt_volume.base.id
  format         = "qcow2"
  size           = var.disk_size_bytes
}

# Create comprehensive cloud-init configuration
# data "template_file" "user_data" {
#   template = file("${path.module}/templates/cloud-init.yaml")
#   vars = {
#     hostname       = var.vm_name
#     username       = var.default_user
#     password       = var.vm_password
#     ssh_key        = var.ssh_public_key
#     packages       = jsonencode(var.packages) 
# #   custom_script  = var.custom_script
#     timezone       = var.timezone
#   }
# }

# # Network config template
# data "template_file" "network_config" {
#   template = file("${path.module}/templates/network_config.yml")
#   vars = {
#     interface = var.network_interface
#   }
# }

# # Create cloud-init meta data
# data "template_file" "meta_data" {
#   template = <<-EOF
# instance-id: ${var.vm_name}-${random_id.vm_id.hex}
# local-hostname: ${var.vm_name}
# EOF
# }

# Create cloud-init disk
# resource "libvirt_cloudinit_disk" "commoninit" {
#   name           = "${var.vm_name}-cloudinit.iso"
#   pool           = var.storage_pool
#   user_data      = data.template_file.user_data.rendered
#   meta_data      = data.template_file.meta_data.rendered
#   network_config = data.template_file.network_config.rendered
# }

resource "libvirt_cloudinit_disk" "commoninit" {
  # count     = var.enable_cloud_init ? 1 : 0
  name = "${var.vm_name}-commoninit.iso"
  pool = var.storage_pool

  user_data = templatefile("${path.module}/templates/cloud-init.yaml", {
    hostname = var.vm_name
    username = var.default_user
    ssh_keys = var.ssh_public_key
    packages = var.packages
    timezone = var.timezone
  })

  network_config = templatefile("${path.module}/templates/network_config.yml", {
    interface = var.network_interface
  })
}

resource "libvirt_domain" "vm" {
  name   = var.vm_name
  memory = var.memory_mb
  vcpu   = var.vcpus


  cloudinit = libvirt_cloudinit_disk.commoninit.id
  # cloudinit = libvirt_cloudinit_disk.commoninit[count.index].id

  boot_device {
    dev = ["hd"]
  }



  disk {
    volume_id = libvirt_volume.vm_disk.id
  }



  network_interface {
    network_name   = var.network_name
    wait_for_lease = var.wait_for_lease
    hostname       = var.vm_name
    mac            = var.mac_address != "" ? var.mac_address : null
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

  autostart = var.autostart
  running   = var.start_vm

  lifecycle {
    ignore_changes = [running]
  }
}

output "vm_ip" {
  description = "IP address of the VM"
  value = (
    length(libvirt_domain.vm.network_interface[0].addresses) > 0
    ? libvirt_domain.vm.network_interface[0].addresses[0]
    : "N/A - IP not available yet"
  )
}

output "vm_name" {
  value = libvirt_domain.vm.name
}

output "vm_id" {
  value = libvirt_domain.vm.id
}

# output "vnc_port" {
#   value = "VNC available on ${var.vnc_listen_address}:${libvirt_domain.vm.graphics[0].port}"
# }

