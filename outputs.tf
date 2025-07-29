output "zone" {
  description = "Current zone information."
  value       = { for k, v in data.cloudflare_zones.domain.result[0] : k => v if k != "development_mode" }
}

output "rules" {
  description = "Created Cloudflare rules for the current zone."
  value       = cloudflare_ruleset.this.rules
}
