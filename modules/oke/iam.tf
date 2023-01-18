# Copyright (c) 2017, 2023 Oracle Corporation and/or its affiliates.
# Licensed under the Universal Permissive License v 1.0 as shown at https://oss.oracle.com/licenses/upl

resource "oci_identity_dynamic_group" "oke_kms_cluster" { # TODO Deprecated - move to IAM sub-module
  provider       = oci.home
  compartment_id = var.tenancy_id
  description    = "dynamic group to allow cluster to use KMS to encrypt etcd"
  matching_rule  = local.dynamic_group_rule_all_clusters
  name           = var.label_prefix == "none" ? "oke-kms-cluster" : "${var.label_prefix}-oke-kms-cluster"
  count          = coalesce(var.cluster_kms_key_id, "none") != "none" && var.create_policies ? 1 : 0


  lifecycle {
    ignore_changes = [matching_rule]
  }
}

resource "oci_identity_policy" "oke_kms" { # TODO Deprecated - move to IAM sub-module
  provider       = oci.home
  compartment_id = local.compartment_id
  description    = "policy to allow dynamic group ${var.label_prefix}-oke-kms-cluster to use KMS to encrypt etcd"
  depends_on     = [oci_identity_dynamic_group.oke_kms_cluster]
  name           = var.label_prefix == "none" ? "oke-kms" : "${var.label_prefix}-oke-kms"


  statements = [local.cluster_kms_policy_statement]

  count = coalesce(var.cluster_kms_key_id, "none") != "none" && var.create_policies ? 1 : 0

}

resource "oci_identity_policy" "oke_volume_kms" { # TODO Deprecated - move to IAM sub-module
  provider       = oci.home
  compartment_id = local.compartment_id
  description    = "Policies for block volumes to access kms key"
  name           = var.label_prefix == "none" ? "oke-volume-kms" : "${var.label_prefix}-oke-volume-kms"
  statements     = local.oke_volume_kms_policy_statements

  count = coalesce(var.node_pool_volume_kms_key_id, "none") != "none" && var.create_policies ? 1 : 0

}
