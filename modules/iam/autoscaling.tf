# Copyright (c) 2022, 2023 Oracle Corporation and/or its affiliates.
# Licensed under the Universal Permissive License v 1.0 as shown at https://oss.oracle.com/licenses/upl

locals {
  autoscaler_group_name = "oke-autoscaler-${var.state_id}"

  # TODO Use all autoscaler compartments for fallback when !var.create_tags
  autoscaler_rules = var.create_tags ? format("ALL {%s}", join(", ", [
    "tag.${var.tag_namespace}.role.value='worker'",
    "tag.${var.tag_namespace}.pool.value='autoscaler'",
    "tag.${var.tag_namespace}.state_id.value='${var.state_id}'",
  ])) : "ALL {instance.compartment.id = '${local.compartment_id}'}"

  autoscaler_policy_statements = distinct(flatten([
    for c in var.autoscaler_compartments : [for s in [
      "Allow dynamic-group %s to manage cluster-node-pools in compartment id %s",
      "Allow dynamic-group %s to manage instance-family in compartment id %s",
      "Allow dynamic-group %s to use subnets in compartment id %s",
      "Allow dynamic-group %s to read virtual-network-family in compartment id %s",
      "Allow dynamic-group %s to use vnics in compartment id %s",
      "Allow dynamic-group %s to inspect compartments in compartment id %s",
    ] : format(s, local.autoscaler_group_name, c)]
  ]))
}

resource "oci_identity_dynamic_group" "oke_autoscaler_dynamic_group" {
  provider       = oci.home
  count          = var.create_policies && length(var.autoscaler_compartments) > 0 ? 1 : 0
  compartment_id = local.tenancy_id # dynamic groups exist in root compartment (tenancy)
  description    = "Dynamic group of Cluster Autoscaler-ready worker nodes for OKE Terraform state ${var.state_id}"
  matching_rule  = local.autoscaler_rules
  name           = local.autoscaler_group_name
}
