variable "api_token" {
  description = "The Cloudflare API token."
  type        = string
  sensitive   = true
}

variable "domain" {
  description = "Cloudflare domain to apply rules for."
  type        = string
}

variable "name" {
  description = "Name of the ruleset."
  type        = string
}

variable "kind" {
  description = "Type of Ruleset to create."
  type        = string

  # Ensure we specify only allowed kind values
  # https://registry.terraform.io/providers/cloudflare/cloudflare/latest/docs/resources/ruleset#kind
  validation {
    condition     = can(contains(["custom", "managed", "root", "zone"], var.kind))
    error_message = "Only the following kind types are allowed: custom, managed, root, zone."
  }
}

variable "phase" {
  description = "Point in the request/response lifecycle where the ruleset will be created."
  type        = string

  # Ensure we specify only allowed kind values
  # https://registry.terraform.io/providers/cloudflare/cloudflare/latest/docs/resources/ruleset#phase
  validation {
    condition     = can(contains(["ddos_l4", "ddos_l7", "http_config_settings", "http_custom_errors", "http_log_custom_fields", "http_ratelimit", "http_request_cache_settings", "http_request_dynamic_redirect", "http_request_firewall_custom", "http_request_firewall_managed", "http_request_late_transform", "http_request_origin", "http_request_redirect", "http_request_sanitize", "http_request_sbfm", "http_request_transform", "http_response_compression", "http_response_firewall_managed", "http_response_headers_transform", "magic_transit"], var.phase))
    error_message = "Only the following phase types are allowed: ddos_l4, ddos_l7, http_config_settings, http_custom_errors, http_log_custom_fields, http_ratelimit, http_request_cache_settings, http_request_dynamic_redirect, http_request_firewall_custom, http_request_firewall_managed, http_request_late_transform, http_request_origin, http_request_redirect, http_request_sanitize, http_request_sbfm, http_request_transform, http_response_compression, http_response_firewall_managed, http_response_headers_transform, magic_transit."
  }
}

variable "description" {
  description = "Brief summary of the ruleset and its intended use."
  type        = string
  default     = null
}

variable "rules" {
  description = "List of Cloudflare firewall rule objects."
  type = list(object({
    expression  = string
    action      = optional(string)
    description = optional(string)
    enabled     = optional(bool, true)
    products    = optional(list(string), [])
  }))
  default = []

  # Ensure we specify only allows action values
  # https://registry.terraform.io/providers/cloudflare/cloudflare/latest/docs/resources/firewall_rule#action
  validation {
    condition     = can([for rule in var.rules : contains(["block", "challenge", "js_challenge", "log", "managed_challenge", "skip"], rule.action)])
    error_message = "Only the following action elements are allowed: block, challenge, js_challenge, log, managed_challenge, skip."
  }

  # Ensure we specify only allowed products values
  # https://registry.terraform.io/providers/cloudflare/cloudflare/latest/docs/resources/firewall_rule#products
  validation {
    condition     = can([for rule in var.rules : [for product in rule.products : contains(["bic", "hot", "ratelimit", "securityLevel", "uablock", "waf", "zonelockdown"], product)]])
    error_message = "Only the following product elements are allowed: bic, hot, ratelimit, securityLevel, uablock, waf, zonelockdown."
  }
}
