# Cloudflare API Configuration
variable "cloudflare_api_token" {
  description = "Cloudflare API Token with DNS edit permissions"
  type        = string
  sensitive   = true
}

variable "cloudflare_zone_id" {
  description = "The Cloudflare Zone ID for the domain"
  type        = string
  default     = "7134369191cc2d4c593a15ec05fa6562"
}

# Domain Configuration
variable "domain_name" {
  description = "The root domain name"
  type        = string
  default     = "sterlink.ir"
}

variable "ip_address" {
  description = "The IPv4 address for A record"
  type        = string
  default     = "159.69.85.64"
  
  validation {
    condition = can(regex("^(?:[0-9]{1,3}\\.){3}[0-9]{1,3}$", var.ip_address))
    error_message = "The ip_address must be a valid IPv4 address."
  }
}

# DNS Record Configuration
variable "dns_ttl" {
  description = "The TTL (Time To Live) for DNS records in seconds (1 for automatic)"
  type        = number
  default     = 1
  
  validation {
    condition = var.dns_ttl == 1 || (var.dns_ttl >= 60 && var.dns_ttl <= 86400)
    error_message = "TTL must be 1 (automatic) or between 60 and 86400 seconds."
  }
}

variable "proxy_enabled" {
  description = "Whether Cloudflare's proxy (CDN, WAF, etc.) should be enabled"
  type        = bool
  default     = false
}

# Subdomain Configuration
variable "subdomains" {
  description = "List of subdomains to create CNAME records for"
  type        = list(string)
  default     = ["www", "cookie"]
}