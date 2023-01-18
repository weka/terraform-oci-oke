# Copyright (c) 2017, 2023 Oracle Corporation and/or its affiliates.
# Licensed under the Universal Permissive License v 1.0 as shown at https://oss.oracle.com/licenses/upl

resource "random_id" "state_id" {
  byte_length = 6
}

module "oke" {
  count          = var.cluster_enabled ? 1 : 0
  source         = "./modules/oke"
  state_id       = random_id.state_id.id
  tenancy_id     = local.tenancy_id
  compartment_id = local.compartment_id
  label_prefix   = var.label_prefix # TODO Deprecated

  # SSH
  ssh_public_key      = var.ssh_public_key
  ssh_public_key_path = var.ssh_public_key_path

  # OKE cluster
  kubernetes_version                                      = var.kubernetes_version
  control_plane_type                                      = var.control_plane_type
  control_plane_nsgs                                      = concat(var.control_plane_nsgs, [module.network.control_plane_nsg_id])
  cluster_name                                            = var.cluster_name
  cluster_options_add_ons_is_kubernetes_dashboard_enabled = var.dashboard_enabled
  cluster_options_kubernetes_network_config_pods_cidr     = var.pods_cidr
  cluster_options_kubernetes_network_config_services_cidr = var.services_cidr
  cluster_subnets                                         = module.network.subnet_ids
  cni_type                                                = var.cni_type
  vcn_id                                                  = local.vcn_id
  cluster_kms_key_id                                      = var.cluster_kms_key_id
  create_policies                                         = var.create_policies
  use_signed_images                                       = var.use_signed_images
  image_signing_keys                                      = var.image_signing_keys
  admission_controller_options                            = var.admission_controller_options

  # OKE node pools
  kubeproxy_mode                  = var.kubeproxy_mode
  max_pods_per_node               = var.max_pods_per_node
  node_pools                      = var.node_pools
  node_pool_name_prefix           = var.node_pool_name_prefix
  node_pool_image_id              = var.node_pool_image_id
  node_pool_image_type            = var.node_pool_image_type
  node_pool_os                    = var.node_pool_os
  node_pool_os_version            = var.node_pool_os_version
  node_pool_timezone              = var.node_pool_timezone
  enable_pv_encryption_in_transit = var.enable_pv_encryption_in_transit
  node_pool_volume_kms_key_id     = var.node_pool_volume_kms_key_id
  cloudinit_nodepool              = var.cloudinit_nodepool
  cloudinit_nodepool_common       = var.cloudinit_nodepool_common

  # OKE load balancer
  preferred_load_balancer = var.preferred_load_balancer

  # Networking
  pod_nsgs    = module.network.pod_nsg_id
  worker_nsgs = concat(var.worker_nsgs, [module.network.worker_nsg_id])

  # Tags
  freeform_tags = var.freeform_tags["oke"]
  defined_tags  = var.defined_tags["oke"]

  depends_on = [
    module.network
  ]

  providers = {
    oci.home = oci.home
  }
}

# Backwards compatibility for new cluster_enabled var; remove `moved` blocks with next major version
moved {
  from = module.oke.oci_containerengine_cluster.k8s_cluster
  to   = module.oke[0].oci_containerengine_cluster.k8s_cluster
}

moved {
  from = module.oke.oci_identity_dynamic_group.oke_kms_cluster
  to   = module.oke[0].oci_identity_dynamic_group.oke_kms_cluster
}

moved {
  from = module.oke.oci_identity_policy.oke_kms
  to   = module.oke[0].oci_identity_policy.oke_kms
}

moved {
  from = module.oke.oci_identity_policy.oke_volume_kms
  to   = module.oke[0].oci_identity_policy.oke_volume_kms
}

moved {
  from = module.oke.oci_containerengine_node_pool.nodepools
  to   = module.oke[0].oci_containerengine_node_pool.nodepools
}

moved {
  from = module.oke.time_sleep.wait_30_seconds
  to   = module.oke[0].time_sleep.wait_30_seconds
}
