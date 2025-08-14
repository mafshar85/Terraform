# outputs.tf (Root Module)

output "selected_environment" {
  description = "The environment that was deployed"
  value       = var.selected_environment
}

output "vm_details" {
  description = "Detailed information about all VMs in the selected environment"
  value = try({
    for k, v in module.kvm_vms : k => v.vm_details
  }, {})
}

output "vm_ips" {
  description = "IP addresses of all VMs in the selected environment"
  value = try({
    for k, v in module.kvm_vms : k => v.vm_ips
  }, {})
}

output "network_info" {
  description = "Network information for the selected environment"
  value = try({
    for k, v in module.kvm_vms : k => {
      network_id   = v.network_id
      network_name = v.network_name
      environment_info = v.environment_info
    }
  }, {})
}

output "deployment_summary" {
  description = "Summary of the deployment"
  value = {
    selected_environment = var.selected_environment
    total_vms = try(length(var.environments[var.selected_environment].vms), 0)
    network_cidr = try(var.environments[var.selected_environment].network_cidr, "N/A")
    network_gateway = try(var.environments[var.selected_environment].network_gateway, "N/A")
  }
}