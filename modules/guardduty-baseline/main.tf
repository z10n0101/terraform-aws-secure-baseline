locals {
  is_admin_account = var.master_account_id == "" && var.delegated_admin_account_id == ""
  accounts         = local.is_admin_account ? var.member_accounts : []
}
resource "aws_guardduty_detector" "default" {
  enable                       = true
  finding_publishing_frequency = var.finding_publishing_frequency

  # datasources can't be individually managed in each member account.
  dynamic "datasources" {
    for_each = local.is_admin_account ? [1] : []

    content {
      s3_logs {
        enable = true
      }
    }
  }

  tags = var.tags
}

resource "aws_guardduty_member" "members" {
  for_each = {
    for account in local.accounts : account.account_id => account
  }

  detector_id                = aws_guardduty_detector.default.id
  invite                     = true
  disable_email_notification = var.disable_email_notification
  invitation_message         = var.invitation_message
  account_id                 = each.value.account_id
  email                      = var.disable_email_notification ? "" : each.value.email
}

# Disable invitation auto-accepter
#
#resource "aws_guardduty_invite_accepter" "master" {
#  count = var.master_account_id != "" ? 1 : 0
#
#  detector_id       = aws_guardduty_detector.default.id
#  master_account_id = var.master_account_id
#}

resource "aws_guardduty_organization_configuration" "admin" {
  count = local.is_admin_account ? 1 : 0

  detector_id = aws_guardduty_detector.default.id

  auto_enable = false

  datasources {
    s3_logs {
      auto_enable = true
    }
  }
}
