# Copyright (c) 2022, 2023 Oracle Corporation and/or its affiliates.
# Licensed under the Universal Permissive License v 1.0 as shown at https://oss.oracle.com/licenses/upl

locals {
  worker_group_name = "oke-workers-${var.state_id}"

  # TODO Use all worker compartments for fallback when !var.create_tags
  worker_rules = var.create_tags ? format("ALL {%s}", join(", ", [
    "tag.${var.tag_namespace}.role.value='worker'",
    "tag.${var.tag_namespace}.state_id.value='${var.state_id}'",
  ])) : "ALL {instance.compartment.id = '${local.compartment_id}'}"

  # "Allow dynamic-group %s to {CLUSTER_JOIN} in compartment id %s where target.cluster.id = '%s'",
  cluster_join_policy_statement = format(
    "Allow dynamic-group %s to {CLUSTER_JOIN} in compartment id %s",
    local.worker_group_name, local.compartment_id, # var.cluster_id, # TODO cluster specific with tags?
  )
}

resource "oci_identity_dynamic_group" "oke_worker_dynamic_group" {
  provider       = oci.home
  count          = var.create_policies && var.create_self_managed_policy ? 1 : 0
  compartment_id = local.tenancy_id # dynamic groups exist in root compartment (tenancy)
  description    = "Dynamic group of worker nodes for OKE Terraform state ${var.state_id}"
  matching_rule  = local.worker_rules
  name           = local.worker_group_name
}
