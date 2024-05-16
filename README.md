# Terraform module: Cloudflare Rulesets

This Terraform module manages Cloudflare Rulesets.

[![lint](https://github.com/flaconi/terraform-cloudflare-rulesets/workflows/lint/badge.svg)](https://github.com/flaconi/terraform-cloudflare-rulesets/actions?query=workflow%3Alint)
[![test](https://github.com/flaconi/terraform-cloudflare-rulesets/workflows/test/badge.svg)](https://github.com/flaconi/terraform-cloudflare-rulesets/actions?query=workflow%3Atest)
[![Tag](https://img.shields.io/github/tag/flaconi/terraform-cloudflare-rulesets.svg)](https://github.com/flaconi/terraform-cloudflare-rulesets/releases)
[![Terraform](https://img.shields.io/badge/Terraform--registry-cloudflare--rulesets-brightgreen.svg)](https://registry.terraform.io/modules/flaconi/rulesets/cloudflare/)
[![License](https://img.shields.io/badge/license-MIT-blue.svg)](https://opensource.org/licenses/MIT)

<!-- TFDOCS_HEADER_START -->


<!-- TFDOCS_HEADER_END -->

<!-- TFDOCS_PROVIDER_START -->
## Providers

| Name | Version |
|------|---------|
| <a name="provider_cloudflare"></a> [cloudflare](#provider\_cloudflare) | ~> 4.20 |

<!-- TFDOCS_PROVIDER_END -->

<!-- TFDOCS_REQUIREMENTS_START -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | ~> 1.3 |
| <a name="requirement_cloudflare"></a> [cloudflare](#requirement\_cloudflare) | ~> 4.20 |

<!-- TFDOCS_REQUIREMENTS_END -->

<!-- TFDOCS_INPUTS_START -->
## Required Inputs

The following input variables are required:

### <a name="input_api_token"></a> [api\_token](#input\_api\_token)

Description: The Cloudflare API token.

Type: `string`

### <a name="input_domain"></a> [domain](#input\_domain)

Description: Cloudflare domain to apply rules for.

Type: `string`

### <a name="input_name"></a> [name](#input\_name)

Description: Name of the ruleset.

Type: `string`

### <a name="input_kind"></a> [kind](#input\_kind)

Description: Type of Ruleset to create.

Type: `string`

### <a name="input_phase"></a> [phase](#input\_phase)

Description: Point in the request/response lifecycle where the ruleset will be created.

Type: `string`

## Optional Inputs

The following input variables are optional (have default values):

### <a name="input_description"></a> [description](#input\_description)

Description: Brief summary of the ruleset and its intended use.

Type: `string`

Default: `null`

### <a name="input_rules"></a> [rules](#input\_rules)

Description: List of Cloudflare rule objects.

Type:

```hcl
list(object({
    expression = string
    action     = string
    action_parameters = optional(object({
      # phase: http_request_origin, action: route
      host_header = optional(string)

      # phase: http_config_settings, action: set_config
      polish = optional(string)

      # phase: http_request_dynamic_redirect, action: redirect
      from_value = optional(object({
        preserve_query_string = optional(bool)
        status_code           = number
        target_url = object({
          value = string
        })
      }), null)

      # phase: http_request_firewall_custom, action: block, challenge, js_challenge, log, managed_challenge, skip
      phases   = optional(list(string))
      products = optional(list(string))
      ruleset  = optional(string)

      # phase: http_log_custom_fields, action: log_custom_field
      cookie_fields   = optional(list(string))
      request_fields  = optional(list(string))
      response_fields = optional(list(string))
    }), null)
    description = optional(string)
    enabled     = optional(bool, true)
    logging = optional(object({
      enabled = bool
    }), null)
  }))
```

Default: `[]`

<!-- TFDOCS_INPUTS_END -->

<!-- TFDOCS_OUTPUTS_START -->
## Outputs

| Name | Description |
|------|-------------|
| <a name="output_domain"></a> [domain](#output\_domain) | Current zone information. |
| <a name="output_rules"></a> [rules](#output\_rules) | Created Cloudflare rules for the current zone. |

<!-- TFDOCS_OUTPUTS_END -->

## License

**[MIT License](LICENSE)**

Copyright (c) 2024 **[Flaconi GmbH](https://github.com/flaconi)**
