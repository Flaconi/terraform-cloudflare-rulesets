output "zone" {
  description = "Current zone information. Only available for zone-level rulesets."
  value       = var.kind == "zone" ? { for k, v in data.cloudflare_zones.this[0].result[0] : k => v if k != "development_mode" } : null
}

output "rules" {
  description = "Created Cloudflare rules for the current zone."
  value       = cloudflare_ruleset.this.rules
}
