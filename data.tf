data "cloudflare_zones" "domain" {
  name = var.domain
}
