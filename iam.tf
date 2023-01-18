# Copyright (c) 2022, 2023 Oracle Corporation and/or its affiliates.
# Licensed under the Universal Permissive License v 1.0 as shown at https://oss.oracle.com/licenses/upl

# Default IAM sub-module implementation for OKE cluster
module "iam" {
  count                       = var.enable_beta && (var.create_policies || length(var.tag_namespace) > 0) ? 1 : 0
  source                      = "./modules/iam"
  state_id                    = random_id.state_id.id
  config_file_profile         = var.config_file_profile
  tenancy_id                  = local.tenancy_id
  compartment_id              = local.compartment_id
  cluster_kms_key_id          = var.cluster_kms_key_id
  node_pool_volume_kms_key_id = var.node_pool_volume_kms_key_id
  defined_tags                = lookup(var.defined_tags, "iam", {})
  freeform_tags               = lookup(var.freeform_tags, "iam", {})

  create_tags   = var.create_tags
  tag_namespace = var.tag_namespace
  create_self_managed_policy = var.create_policies && var.create_self_managed_policy && anytrue([
    for k, v in var.worker_groups :
    lookup(v, "enabled", var.worker_group_enabled) == true &&
    lookup(v, "mode", var.worker_group_mode) != "node-pool"
  ])

  worker_compartments = distinct(compact([
    for k, v in var.worker_groups : lookup(v, "compartment_id", local.compartment_id)
    if lookup(v, "enabled", var.worker_group_enabled) == true
  ]))

  create_autoscaler_policy = var.create_policies && var.create_autoscaler_policy && anytrue([
    for k, v in var.worker_groups :
    lookup(v, "enabled", var.worker_group_enabled) == true &&
    lookup(v, "allow_autoscaler", var.allow_autoscaler) == true
  ])

  autoscaler_compartments = distinct([
    for k, v in var.worker_groups : lookup(v, "compartment_id", local.compartment_id)
    if lookup(v, "enabled", var.worker_group_enabled) == true &&
    lookup(v, "allow_autoscaler", var.allow_autoscaler) == true
  ])

  create_operator_policy = var.create_policies && var.create_operator && var.create_operator_policy
  create_kms_policy = var.create_policies && var.create_kms_policy && anytrue([
    coalesce(var.node_pool_volume_kms_key_id, "none") != "none",
    coalesce(var.cluster_kms_key_id, "none") != "none"
  ])

  providers = {
    oci.home = oci.home
  }
}
