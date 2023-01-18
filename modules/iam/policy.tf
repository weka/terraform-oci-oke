# Copyright (c) 2022, 2023 Oracle Corporation and/or its affiliates.
# Licensed under the Universal Permissive License v 1.0 as shown at https://oss.oracle.com/licenses/upl

locals {
  group_policy_statements = distinct(compact(flatten([
    coalesce(var.cluster_kms_key_id, "none") != "none" ? [local.cluster_kms_policy_statements] : [],
    local.volume_kms_policy_statements,
    var.create_operator_policy ? [local.operator_policy_statement] : [],
  ])))

  has_any_policy = anytrue([
    local.has_cluster_kms_policy,
    local.has_volume_kms_policy,
    var.create_operator_policy,
  ])
}

resource "oci_identity_policy" "oke_iam_policy" {
  provider       = oci.home
  count          = var.create_policies && local.has_any_policy ? 1 : 0
  compartment_id = local.compartment_id
  description    = "Policies for OKE Terraform state ${var.state_id}"
  name           = local.cluster_group_name
  statements     = local.group_policy_statements
}

resource "time_sleep" "await_iam_policy" { # Allow policies to take effect globally before continuing
  count            = var.create_policies && local.has_any_policy ? 1 : 0
  create_duration  = "30s"
  destroy_duration = "0s"
  depends_on       = [oci_identity_policy.oke_iam_policy]
}
