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

  # Ensure we specify only the supported kind values
  # https://registry.terraform.io/providers/cloudflare/cloudflare/latest/docs/resources/ruleset#kind
  validation {
    condition     = can(contains(["zone"], var.kind))
    error_message = "Only the following kind types are allowed: zone."
  }
}

variable "phase" {
  description = "Point in the request/response lifecycle where the ruleset will be created."
  type        = string

  # Ensure we specify only the supported kind values
  # https://registry.terraform.io/providers/cloudflare/cloudflare/latest/docs/resources/ruleset#phase
  # https://developers.cloudflare.com/ruleset-engine/reference/phases-list/
  validation {
    condition     = contains(["http_config_settings", "http_log_custom_fields", "http_ratelimit", "http_request_dynamic_redirect", "http_request_firewall_custom", "http_request_firewall_managed", "http_request_origin", "http_request_transform"], var.phase)
    error_message = "Only the following phase types are allowed: http_config_settings, http_log_custom_fields, http_ratelimit, http_request_dynamic_redirect, http_request_firewall_custom, http_request_firewall_managed, http_request_origin, http_request_transform."
  }
}

variable "description" {
  description = "Brief summary of the ruleset and its intended use."
  type        = string
  default     = null
}

variable "rules" {
  description = "List of Cloudflare rule objects."
  type = list(object({
    expression = string
    action     = string
    action_parameters = optional(object({
      # phase: http_config_settings, action: set_config
      polish = optional(string)

      # phase: http_log_custom_fields, action: log_custom_field
      cookie_fields   = optional(list(string))
      request_fields  = optional(list(string))
      response_fields = optional(list(string))

      # phase: http_request_dynamic_redirect, action: redirect
      from_value = optional(object({
        preserve_query_string = optional(bool)
        status_code           = number
        target_url = object({
          value      = optional(string)
          expression = optional(string)
        })
      }), null)

      # phase: http_request_firewall_custom, action: block, challenge, js_challenge, log, managed_challenge, skip
      phases   = optional(list(string))
      products = optional(list(string))
      ruleset  = optional(string)

      # phase: http_request_firewall_managed, action: block, challenge, js_challenge, log, managed_challenge, skip
      id      = optional(string)
      version = optional(string)
      overrides = optional(object({
        action = optional(string)
        categories = optional(list(object({
          action   = optional(string)
          category = string
          enabled  = bool
        })), [])
        enabled = optional(bool)
        rules = optional(list(object({
          id              = string
          action          = string
          enabled         = bool
          score_threshold = optional(number)
        })), [])
      }), null)

      # phase: http_request_origin, action: route
      host_header = optional(string)
      origin = optional(object({
        host = optional(string)
        port = optional(number)
      }), null)

      # phase: http_request_transform
      uri = optional(object({
        path  = optional(string)
        query = optional(string)
      }))
    }), null)
    # phase: http_ratelimit, action: block, challenge, js_challenge, log, managed_challenge
    ratelimit = optional(object({
      characteristics            = optional(list(string))
      counting_expression        = optional(string)
      mitigation_timeout         = optional(number)
      period                     = optional(number)
      requests_per_period        = optional(number)
      requests_to_origin         = optional(bool)
      score_per_period           = optional(number)
      score_response_header_name = optional(string)
    }), null)
    description = optional(string)
    enabled     = optional(bool, true)
    logging = optional(object({
      enabled = bool
    }), null)
  }))
  default = []

  # Ensure we specify only the supported action values
  # https://registry.terraform.io/providers/cloudflare/cloudflare/latest/docs/resources/ruleset#action
  validation {
    condition     = alltrue([for rule in var.rules : contains(["block", "challenge", "execute", "js_challenge", "log", "log_custom_field", "managed_challenge", "redirect", "rewrite", "route", "set_config", "skip"], rule.action)])
    error_message = "Only the following action elements are allowed: block, challenge, execute, js_challenge, log, log_custom_field, managed_challenge, redirect, rewrite, route, skip."
  }

  # Ensure we specify only allowed action_parameters.products values
  # https://registry.terraform.io/providers/cloudflare/cloudflare/latest/docs/resources/ruleset#products
  validation {
    condition     = alltrue([for rule in var.rules : try(alltrue([for product in rule.action_parameters.products : contains(["bic", "hot", "ratelimit", "securityLevel", "uablock", "waf", "zonelockdown"], product)]), true)])
    error_message = "Only the following product elements are allowed: bic, hot, ratelimit, securityLevel, uablock, waf, zonelockdown."
  }

  # Ensure we specify logging with skip action
  # https://registry.terraform.io/providers/cloudflare/cloudflare/latest/docs/resources/ruleset#logging
  validation {
    condition     = alltrue([for rule in var.rules : rule.action != "skip" ? !can(rule.logging.enabled) : true])
    error_message = "Logging element can be used with skip action."
  }

  # Ensure we specify only allowed action_parameters.from_value.status_code values
  validation {
    condition     = alltrue([for rule in var.rules : try(contains([301, 302, 303, 307, 308], rule.action_parameters.from_value.status_code), true)])
    error_message = "Only the following status_code elements are allowed: 301, 302, 303, 307, 308."
  }

  # Ensure action_parameters.from_value.target_url.value is not empty
  validation {
    condition     = alltrue([for rule in var.rules : try(length(rule.action_parameters.from_value.target_url.value) > 0, true)])
    error_message = "action_parameters.from_value.target_url.value cannot be empty"
  }

  # Ensure action_parameters.from_value.target_url.expression is not empty
  validation {
    condition     = alltrue([for rule in var.rules : try(length(rule.action_parameters.from_value.target_url.expression) > 0, true)])
    error_message = "action_parameters.from_value.target_url.expression cannot be empty"
  }

  # Ensure we specify only allowed action_parameters.polish
  validation {
    condition     = alltrue([for rule in var.rules : try(contains(["off", "lossless", "lossy"], rule.action_parameters.polish), true)])
    error_message = "Only the following polish elements are allowed off, lossless, lossy"
  }

  # Ensure that either query or path are set for rewrite rules
  validation {
    condition     = alltrue([for rule in var.rules : rule.action == "rewrite" ? (can(rule.action_parameters.uri.path) || can(rule.action_parameters.uri.query)) : true])
    error_message = "action_parameters.uri needs to have either path or query value for rewrite"
  }

  # Ensure that either expression or value are set for redirect rules as target_url
  validation {
    condition     = alltrue([for rule in var.rules : rule.action == "redirect" ? (rule.action_parameters.from_value.target_url.value != null || rule.action_parameters.from_value.target_url.expression != null) : true])
    error_message = "action_parameters.from_value.target_url needs to have either expression or value for redirect"
  }
}
