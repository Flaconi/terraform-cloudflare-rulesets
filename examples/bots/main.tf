module "rulesets" {
  source    = "./../../"
  api_token = var.api_token
  domain    = var.domain
  name      = "default"
  kind      = "zone"
  phase     = "http_request_firewall_custom"
  rules = [
    {
      description = "User-Agent: skip"
      enabled     = true
      action      = "skip"
      expression  = <<-EOT
      (http.user_agent contains "Bot/" and http.request.uri.path eq "/api/v1")
      EOT
      products    = ["waf"]
    },
    {
      description = "User-Agent: log"
      enabled     = false
      action      = "log"
      expression  = <<-EOT
      (http.user_agent contains "Bot/" and http.request.uri.path eq "/api/v1")
      EOT
      products    = []
    },
    {
      description = "Bots: log"
      action      = "log"
      expression  = <<-EOT
      (cf.bot_management.score eq 2)
      EOT
    },
    {
      description = "Bots: challenge"
      enabled     = false
      action      = "managed_challenge"
      expression  = <<-EOT
      (cf.bot_management.score eq 9)
      EOT
    },
  ]
}
