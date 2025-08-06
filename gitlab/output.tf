# Outputs for all VMs
output "vm_ips" {
  description = "IP addresses of all VMs"
  value = {
    for k, vm in libvirt_domain.vm : k => (
      length(vm.network_interface[0].addresses) > 0
      ? vm.network_interface[0].addresses[0]
      : "N/A - IP not available yet"
    )
  }
}

output "vm_names" {
  description = "Names of all VMs"
  value = {
    for k, vm in libvirt_domain.vm : k => vm.name
  }
}

output "vm_ids" {
  description = "IDs of all VMs"
  value = {
    for k, vm in libvirt_domain.vm : k => vm.id
  }
}