# DNS A record for the root domain
resource "cloudflare_record" "root_a_record" {
  zone_id = var.cloudflare_zone_id
  name    = var.domain_name
  type    = "A"
  content = var.ip_address
  ttl     = var.dns_ttl
  proxied = var.proxy_enabled
  comment = "Managed by Terraform - Root Domain A Record"

}

# DNS CNAME records for subdomains
resource "cloudflare_record" "subdomain_cname_records" {
  for_each = toset(var.subdomains)
  
  zone_id = var.cloudflare_zone_id
  name    = each.value
  type    = "CNAME"
  content = var.domain_name
  ttl     = var.dns_ttl
  proxied = var.proxy_enabled
  comment = "Managed by Terraform - ${title(each.value)} Subdomain CNAME"

}
