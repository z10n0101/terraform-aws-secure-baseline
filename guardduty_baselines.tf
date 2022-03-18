# --------------------------------------------------------------------------------------------------
# GuardDuty Baseline
# Needs to be set up in each region.
# This is an extra configuration which is not included in CIS benchmark.
# --------------------------------------------------------------------------------------------------

locals {
  guardduty_master_account_id = var.delegated_admin_account_id != "" ? var.delegated_admin_account_id : var.master_account_id
  guardduty_member_accounts   = var.delegated_admin_account_id != "" ? [] : var.member_accounts
}

module "guardduty_baseline" {
  count  = var.guardduty_enabled ? 1 : 0
  source = "./modules/guardduty-baseline"

  delegated_admin_account_id   = var.delegated_admin_account_id
  disable_email_notification   = var.guardduty_disable_email_notification
  finding_publishing_frequency = var.guardduty_finding_publishing_frequency
  invitation_message           = var.guardduty_invitation_message
  master_account_id            = local.guardduty_master_account_id
  member_accounts              = local.guardduty_member_accounts

  tags = var.tags
}
