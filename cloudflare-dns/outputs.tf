# Output the FQDN of the root A record
output "root_domain_fqdn" {
  description = "The fully qualified domain name of the root A record"
  value       = cloudflare_record.root_a_record.hostname
}

# Output the IP address of the root domain
output "root_domain_ip" {
  description = "The IP address of the root domain"
  value       = cloudflare_record.root_a_record.content
}

# Output the FQDNs of all subdomain CNAME records
output "subdomain_fqdns" {
  description = "The fully qualified domain names of all subdomain CNAME records"
  value = {
    for subdomain, record in cloudflare_record.subdomain_cname_records : 
    subdomain => record.hostname
  }
}

# Output zone information
output "zone_id" {
  description = "The Cloudflare Zone ID being used"
  value       = var.cloudflare_zone_id
}

# Output DNS configuration summary
output "dns_summary" {
  description = "Summary of DNS configuration"
  value = {
    domain        = var.domain_name
    ip_address    = var.ip_address
    ttl           = var.dns_ttl
    proxy_enabled = var.proxy_enabled
    subdomains    = var.subdomains
  }
}