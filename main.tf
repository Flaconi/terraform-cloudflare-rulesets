resource "cloudflare_ruleset" "this" {
  zone_id     = lookup(data.cloudflare_zones.this.result[0], "id")
  name        = var.name
  kind        = var.kind
  phase       = var.phase
  description = var.description

  rules = [
    for rule in var.rules : {
      action = rule.action
      action_parameters = rule.action_parameters == null ? null : {
        # http_config_settings
        polish = rule.action_parameters.polish

        # http_log_custom_fields
        cookie_fields   = rule.action_parameters.cookie_fields
        request_fields  = rule.action_parameters.request_fields
        response_fields = rule.action_parameters.response_fields

        # http_request_cache_settings
        cache = rule.action_parameters.cache
        edge_ttl = rule.action_parameters.edge_ttl == null ? null : {
          default = rule.action_parameters.edge_ttl.default
          mode    = rule.action_parameters.edge_ttl.mode
          status_code_ttl = rule.action_parameters.edge_ttl.status_code_ttl == null ? null : [
            for sct in rule.action_parameters.edge_ttl.status_code_ttl : {
              value       = sct.value
              status_code = sct.status_code
              status_code_range = sct.status_code_range == null ? null : {
                from = sct.status_code_range.from
                to   = sct.status_code_range.to
              }
            }
          ]
        }

        # http_request_dynamic_redirect
        from_value = rule.action_parameters.from_value == null ? null : {
          preserve_query_string = rule.action_parameters.from_value.preserve_query_string
          status_code           = rule.action_parameters.from_value.status_code
          target_url = {
            value      = rule.action_parameters.from_value.target_url.value
            expression = rule.action_parameters.from_value.target_url.expression
          }
        }

        # http_request_firewall_custom
        phases   = rule.action_parameters.phases
        ruleset  = rule.action_parameters.ruleset
        products = rule.action_parameters.products

        # http_request_firewall_managed
        id = rule.action_parameters.id
        overrides = rule.action_parameters.overrides == null ? null : {
          action = rule.action_parameters.overrides.action
          categories = rule.action_parameters.overrides.categories == null ? null : [
            for cat in rule.action_parameters.overrides.categories : {
              action   = cat.action
              category = cat.category
              enabled  = cat.enabled
            }
          ]
          enabled = rule.action_parameters.overrides.enabled
          rules = rule.action_parameters.overrides.rules == null ? null : [
            for o_rule in rule.action_parameters.overrides.rules : {
              id              = o_rule.id
              action          = o_rule.action
              enabled         = o_rule.enabled
              score_threshold = o_rule.score_threshold
            }
          ]
        }

        # http_request_origin
        host_header = rule.action_parameters.host_header
        origin = rule.action_parameters.origin == null ? null : {
          host = rule.action_parameters.origin.host
          port = rule.action_parameters.origin.port
        }

        # http_request_transform
        uri = rule.action_parameters.uri == null ? null : {
          path = rule.action_parameters.uri.path == null ? null : {
            expression = rule.action_parameters.uri.path.expression
            value      = rule.action_parameters.uri.path.value
          }
          query = rule.action_parameters.uri.query == null ? null : {
            expression = rule.action_parameters.uri.query.expression
            value      = rule.action_parameters.uri.query.value
          }
        }
      }
      description = rule.description
      enabled     = rule.enabled
      expression  = rule.expression

      logging = rule.logging == null ? null : {
        enabled = rule.logging.enabled
      }

      # http_ratelimit
      ratelimit = rule.ratelimit == null ? null : {
        characteristics            = rule.ratelimit.characteristics
        counting_expression        = rule.ratelimit.counting_expression
        mitigation_timeout         = rule.ratelimit.mitigation_timeout
        period                     = rule.ratelimit.period
        requests_per_period        = rule.ratelimit.requests_per_period
        requests_to_origin         = rule.ratelimit.requests_to_origin
        score_per_period           = rule.ratelimit.score_per_period
        score_response_header_name = rule.ratelimit.score_response_header_name
      }

      ref = coalesce(rule.ref, random_uuid.rule_ref[rule.description].result)
    }
  ]
}

resource "random_uuid" "rule_ref" {
  for_each = toset([for r in var.rules : r.description])
}
