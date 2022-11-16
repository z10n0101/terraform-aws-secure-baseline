config {
  module = false
  force = false
  disabled_by_default = false
}

rule "terraform_deprecated_interpolation" {
  enabled = true
}

rule "terraform_deprecated_index" {
  enabled = true
}

rule "terraform_unused_declarations" {
  enabled = true
}

rule "terraform_comment_syntax" {
  enabled = true
}

rule "terraform_documented_outputs" {
  enabled = true
}

rule "terraform_documented_variables" {
  enabled = true
}

rule "terraform_typed_variables" {
  enabled = true
}

rule "terraform_module_pinned_source" {
  enabled = true
}

rule "terraform_required_version" {
  enabled = true
}

rule "terraform_required_providers" {
  enabled = true
}

rule "terraform_standard_module_structure" {
  enabled = true
}

rule "terraform_workspace_remote" {
  enabled = true
}

rule "aws_cloudwatch_log_group_invalid_name" {
  enabled = false
}

rule "aws_iam_role_invalid_permissions_boundary" {
  enabled = false
}

plugin "aws" {
  enabled = true
  version = "0.19.0"
  source  = "github.com/terraform-linters/tflint-ruleset-aws"
}
