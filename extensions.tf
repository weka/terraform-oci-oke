# Copyright (c) 2017, 2023 Oracle Corporation and/or its affiliates.
# Licensed under the Universal Permissive License v 1.0 as shown at https://oss.oracle.com/licenses/upl

module "extensions" {
  count          = local.operator_enabled ? 1 : 0
  source         = "./modules/extensions"
  state_id       = random_id.state_id.id
  tenancy_id     = local.tenancy_id
  compartment_id = local.compartment_id
  region         = var.region
  label_prefix   = var.label_prefix # TODO Deprecated
  debug_mode     = var.debug_mode

  ssh_private_key      = var.ssh_private_key
  ssh_private_key_path = var.ssh_private_key_path
  ssh_public_key       = var.ssh_public_key
  ssh_public_key_path  = var.ssh_public_key_path

  bastion_public_ip = local.bastion_public_ip
  bastion_user      = var.bastion_user

  operator_private_ip                = local.operator_private_ip
  operator_user                      = var.operator_user
  operator_dynamic_group             = local.operator_instance_principal_group_name
  enable_operator_instance_principal = var.enable_operator_instance_principal

  # OKE cluster
  cluster_id                   = one(module.oke[*].cluster_id)
  pods_cidr                    = var.pods_cidr
  cluster_kms_key_id           = var.cluster_kms_key_id
  cluster_kms_dynamic_group_id = one(module.oke[*].cluster_kms_dynamic_group_id)
  create_policies              = var.create_policies

  # OCIR
  email_address    = var.email_address
  secret_id        = var.secret_id
  secret_name      = var.secret_name
  secret_namespace = var.secret_namespace
  username         = var.username

  # Calico
  enable_calico            = var.enable_calico
  calico_version           = var.calico_version
  calico_mode              = var.calico_mode
  cni_type                 = var.cni_type
  calico_mtu               = var.calico_mtu
  calico_url               = var.calico_url
  calico_apiserver_enabled = var.calico_apiserver_enabled
  calico_staging_dir       = var.calico_staging_dir
  typha_enabled            = var.typha_enabled
  typha_replicas           = var.typha_replicas

  # Metric server
  enable_metric_server = var.enable_metric_server
  enable_vpa           = var.enable_vpa
  vpa_version          = var.vpa_version

  # Gatekeeper
  enable_gatekeeper  = var.enable_gatekeeper
  gatekeeper_version = var.gatekeeper_version

  # Service account
  create_service_account               = var.create_service_account
  service_account_name                 = var.service_account_name
  service_account_namespace            = var.service_account_namespace
  service_account_cluster_role_binding = var.service_account_cluster_role_binding

  # Worker node readiness
  check_node_active   = var.check_node_active
  expected_node_count = module.workergroup.expected_node_count + sum(coalescelist(module.oke[*].expected_node_count, [0]))

  # OKE upgrade
  upgrade_nodepool        = var.upgrade_nodepool
  nodepool_upgrade_method = var.nodepool_upgrade_method
  node_pools_to_drain     = var.node_pools_to_drain

  # Cluster autoscaler
  deploy_cluster_autoscaler = var.deploy_cluster_autoscaler
  autoscaling_groups        = module.workergroup.autoscaling_groups

  depends_on = [
    module.bastion,
    module.network,
    module.operator,
    module.oke,
    module.workergroup
  ]

  providers = {
    oci.home = oci.home
  }
}

module "storage" {
  count               = var.create_fss ? 1 : 0
  source              = "./modules/storage"
  tenancy_id          = local.tenancy_id
  compartment_id      = local.compartment_id
  availability_domain = var.availability_domains["fss"]
  label_prefix        = var.label_prefix # TODO Deprecated

  # Networking
  subnets      = var.subnets
  assign_dns   = var.assign_dns
  vcn_id       = local.vcn_id
  nat_route_id = local.nat_route_id

  # Filesystem
  fss_mount_path    = var.fss_mount_path
  max_fs_stat_bytes = var.max_fs_stat_bytes
  max_fs_stat_files = var.max_fs_stat_files

  providers = {
    oci.home = oci.home
  }
}
