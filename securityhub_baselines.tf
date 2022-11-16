# --------------------------------------------------------------------------------------------------
# SecurityHub Baseline
# --------------------------------------------------------------------------------------------------

locals {
  securityhub_master_account_id = var.master_account_id
  securityhub_member_accounts   = var.member_accounts
}

module "securityhub_baseline" {
  count  = var.securityhub_enabled ? 1 : 0
  source = "./modules/securityhub-baseline"

  aggregate_findings               = var.region == "ap-northeast-1"
  enable_cis_standard              = var.securityhub_enable_cis_standard
  enable_pci_dss_standard          = var.securityhub_enable_pci_dss_standard
  enable_aws_foundational_standard = var.securityhub_enable_aws_foundational_standard
  master_account_id                = local.securityhub_master_account_id
  member_accounts                  = local.securityhub_member_accounts
  enable_product_arns              = var.securityhub_enable_product_arns
}
