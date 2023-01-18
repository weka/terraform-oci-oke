# Copyright (c) 2022, 2023 Oracle Corporation and/or its affiliates.
# Licensed under the Universal Permissive License v 1.0 as shown at https://oss.oracle.com/licenses/upl

locals {
  operator_group_name = "oke-operator-${var.state_id}"

  operator_rules = var.create_tags ? format("ALL {%s}", join(", ", [
    "tag.${var.tag_namespace}.role.value='operator'",
    "tag.${var.tag_namespace}.state_id.value='${var.state_id}'",
  ])) : "ALL {instance.compartment.id = '${local.compartment_id}'}"

  operator_policy_statement = format(
    "Allow dynamic-group %s to use clusters in compartment id %s",
    local.operator_group_name, local.compartment_id,
  )
}

resource "oci_identity_dynamic_group" "oke_operator_dynamic_group" {
  provider       = oci.home
  count          = var.create_policies && var.create_operator_policy ? 1 : 0
  compartment_id = local.tenancy_id # dynamic groups exist in root compartment (tenancy)
  description    = "Dynamic group of operator instance(s) for OKE Terraform state_id ${var.state_id}"
  matching_rule  = local.operator_rules
  name           = local.operator_group_name
}
