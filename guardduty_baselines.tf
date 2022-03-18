# --------------------------------------------------------------------------------------------------
# GuardDuty Baseline
# Needs to be set up in each region.
# This is an extra configuration which is not included in CIS benchmark.
# --------------------------------------------------------------------------------------------------

locals {
  guardduty_master_account_id = local.is_delegated_admin_account ? "" : var.master_account_id
  guardduty_delegated_admin   = local.is_delegated_admin_account ? "" : var.delegated_admin_account_id
  guardduty_member_accounts   = var.member_accounts
}

module "guardduty_baseline" {
  count  = var.guardduty_enabled ? 1 : 0
  source = "./modules/guardduty-baseline"

  disable_email_notification   = var.guardduty_disable_email_notification
  finding_publishing_frequency = var.guardduty_finding_publishing_frequency
  invitation_message           = var.guardduty_invitation_message
  master_account_id            = local.guardduty_master_account_id
  member_accounts              = local.guardduty_member_accounts
  delegated_admin_account_id   = local.guardduty_delegated_admin

  tags = var.tags
}
