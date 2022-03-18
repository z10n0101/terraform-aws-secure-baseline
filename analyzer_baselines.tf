locals {
  is_analyzer_enabled = var.analyzer_baseline_enabled && (local.is_individual_account || local.is_master_account || local.is_delegated_admin_account)
}

# --------------------------------------------------------------------------------------------------
# Analyzer Baseline
# --------------------------------------------------------------------------------------------------

module "analyzer_baseline" {
  count  = local.is_analyzer_enabled ? 1 : 0
  source = "./modules/analyzer-baseline"

  analyzer_name   = var.analyzer_name
  is_organization = local.is_master_account || local.is_delegated_admin_account

  tags = var.tags
}
