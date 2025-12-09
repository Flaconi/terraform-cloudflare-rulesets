data "cloudflare_zones" "this" {
  count = var.kind == "zone" ? 1 : 0
  name  = var.domain
}
