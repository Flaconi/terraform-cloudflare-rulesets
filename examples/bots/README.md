# Example

This example will create multiple rulesets for `http_request_firewall_custom` phase.

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | ~> 1.8 |
| <a name="requirement_cloudflare"></a> [cloudflare](#requirement\_cloudflare) | ~> 5.10 |
| <a name="requirement_random"></a> [random](#requirement\_random) | 3.7.2 |

## Providers

No providers.

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_rulesets"></a> [rulesets](#module\_rulesets) | ./../../ | n/a |

## Resources

No resources.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_api_token"></a> [api\_token](#input\_api\_token) | The Cloudflare API token. | `string` | n/a | yes |
| <a name="input_domain"></a> [domain](#input\_domain) | Cloudflare domain name to create | `string` | `"example.com"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_records"></a> [records](#output\_records) | Cloudflare Zone DNS Records |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

Copyright (c) 2024 **[Flaconi GmbH](https://github.com/flaconi)**
