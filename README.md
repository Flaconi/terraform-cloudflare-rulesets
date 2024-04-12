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

## Optional Inputs

The following input variables are optional (have default values):

### <a name="input_rules"></a> [rules](#input\_rules)

Description: List of Cloudflare firewall rule objects.

Type:

```hcl
list(object({
    description = string
    enabled     = bool
    action      = string
    expression  = string
    products    = list(string)
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
