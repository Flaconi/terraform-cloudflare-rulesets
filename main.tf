resource "cloudflare_ruleset" "this" {
  zone_id     = lookup(data.cloudflare_zones.domain.zones[0], "id")
  name        = var.name
  kind        = var.kind
  phase       = var.phase
  description = var.description

  dynamic "rules" {
    for_each = var.rules

    content {
      action = rules.value.action
      dynamic "action_parameters" {
        for_each = rules.value.action_parameters[*]
        content {
          # http_request_origin
          host_header = action_parameters.value.host_header
          dynamic "origin" {
            for_each = rules.value.action_parameters.origin[*]
            content {
              host = origin.value.host
              port = origin.value.port
            }
          }

          # http_config_settings
          polish = action_parameters.value.polish

          # http_request_dynamic_redirect
          dynamic "from_value" {
            for_each = rules.value.action_parameters.from_value[*]
            content {
              preserve_query_string = from_value.value.preserve_query_string
              status_code           = from_value.value.status_code
              target_url {
                value = from_value.value.target_url.value
              }
            }
          }

          # http_request_firewall_custom
          phases   = action_parameters.value.phases
          ruleset  = action_parameters.value.ruleset
          products = action_parameters.value.products

          # http_log_custom_fields
          cookie_fields   = action_parameters.value.cookie_fields
          request_fields  = action_parameters.value.request_fields
          response_fields = action_parameters.value.response_fields

          # http_request_firewall_managed
          id      = action_parameters.value.id
          version = action_parameters.value.version
          dynamic "overrides" {
            for_each = rules.value.action_parameters.overrides[*]
            content {
              action = overrides.value.action
              dynamic "categories" {
                for_each = overrides.value.categories
                content {
                  action   = categories.value.action
                  category = categories.value.category
                  enabled  = categories.value.enabled
                }
              }
              enabled = overrides.value.enabled
              dynamic "rules" {
                for_each = overrides.value.rules
                iterator = override_rule
                content {
                  id              = override_rule.value.id
                  action          = override_rule.value.action
                  enabled         = override_rule.value.enabled
                  score_threshold = override_rule.value.score_threshold
                }
              }
            }
          }
        }
      }
      description = rules.value.description
      enabled     = rules.value.enabled
      expression  = rules.value.expression
      dynamic "logging" {
        for_each = rules.value.logging[*]
        content {
          enabled = logging.value.enabled
        }
      }
    }
  }
}
