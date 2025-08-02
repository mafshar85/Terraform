# Copy this file to terraform.tfvars and fill in your values
# DO NOT commit terraform.tfvars to version control!

# Cloudflare Configuration
cloudflare_api_token = "your_cloudflare_api_token_here"
cloudflare_zone_id   = "7134369191cc2d4c593a15ec05fa6562"

# Domain Configuration
domain_name = "sterlink.ir"
ip_address  = "159.69.85.64"

# DNS Settings
dns_ttl       = 1      # 1 for automatic, or 60-86400 seconds
proxy_enabled = false  # true to enable Cloudflare proxy features

# Subdomains
subdomains = ["www", "cookie", "*.customers"]