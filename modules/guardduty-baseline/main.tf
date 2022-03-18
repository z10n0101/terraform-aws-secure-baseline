locals {
  is_admin_account = var.master_account_id == "" && var.delegated_admin_account_id == ""
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
  count = local.is_admin_account ? length(var.member_accounts) : 0

  detector_id                = aws_guardduty_detector.default.id
  invite                     = true
  account_id                 = var.member_accounts[count.index].account_id
  disable_email_notification = var.disable_email_notification
  email                      = var.member_accounts[count.index].email
  invitation_message         = var.invitation_message
}

# Disable invitation auto-accepter
#
#resource "aws_guardduty_invite_accepter" "master" {
#  count = var.master_account_id != "" ? 1 : 0
#
#  detector_id       = aws_guardduty_detector.default.id
#  master_account_id = var.master_account_id
#}

# Only master account can create delegated admin
resource "aws_guardduty_organization_admin_account" "master" {
  count = var.master_account_id == "" && var.delegated_admin_account_id != "" ? 1 : 0

  admin_account_id = var.delegated_admin_account_id
}

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
