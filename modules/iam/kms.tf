# Copyright (c) 2022, 2023 Oracle Corporation and/or its affiliates.
# Licensed under the Universal Permissive License v 1.0 as shown at https://oss.oracle.com/licenses/upl

locals {
  cluster_group_name       = "oke-cluster-${var.state_id}"
  cluster_compartment_rule = "resource.type = 'cluster', resource.compartment.id = '${local.compartment_id}'"
  cluster_tag_rule         = var.create_tags ? ", tag.${var.tag_namespace}.state_id.value='${var.state_id}'" : ""
  cluster_rule             = "ALL {${local.cluster_compartment_rule}${local.cluster_tag_rule}}"

  # Cluster secrets encryption using OCI Key Management System (KMS)
  cluster_kms_policy_statements = coalesce(var.cluster_kms_key_id, "none") != "none" ? format(
    "Allow dynamic-group %s to use keys in compartment id %s where target.key.id = '%s'",
  local.cluster_group_name, local.compartment_id, var.cluster_kms_key_id) : null

  has_cluster_kms_policy = coalesce(var.cluster_kms_key_id, "none") != "none"

  # Block volume encryption using OCI Key Management System (KMS)
  # TODO support worker compartments/volume keys defined at worker group level
  volume_kms_policy_statements = distinct(compact(flatten([
    coalesce(var.node_pool_volume_kms_key_id, "none") != "none" ? [for s in [
      "Allow service oke to use key-delegates in compartment id %s where target.key.id = '%s'",
      "Allow service blockstorage to use keys in compartment id %s where target.key.id = '%s'",
    ] : format(s, local.compartment_id, var.node_pool_volume_kms_key_id)] : [],
  ])))

  has_volume_kms_policy = coalesce(var.cluster_kms_key_id, "none") != "none"
}

resource "oci_identity_dynamic_group" "oke_cluster_dynamic_group" {
  provider       = oci.home
  count          = var.create_policies && local.has_cluster_kms_policy ? 1 : 0
  compartment_id = local.tenancy_id # dynamic groups exist in root compartment (tenancy)
  description    = "Dynamic group with cluster for OKE Terraform state ${var.state_id}"
  matching_rule  = local.cluster_compartment_rule
  name           = local.cluster_group_name
}
