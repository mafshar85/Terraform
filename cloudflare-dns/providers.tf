# Configure the Cloudflare provider
# Set the Cloudflare API Token as an environment variable:
# export TF_VAR_cloudflare_api_token="your_api_token_here"
provider "cloudflare" {
  api_token = var.cloudflare_api_token
}