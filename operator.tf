# Copyright (c) 2017, 2023 Oracle Corporation and/or its affiliates.
# Licensed under the Universal Permissive License v 1.0 as shown at https://oss.oracle.com/licenses/upl

locals {
  operator_private_ip = (var.cluster_enabled && var.create_operator
    ? module.operator[0].operator_private_ip
    : var.operator_private_ip
  )

  operator_enabled                       = var.cluster_enabled && (length(module.operator) > 0 || length(var.operator_private_ip) > 0)
  operator_instance_principal_group_name = var.create_operator == true ? module.operator[0].operator_instance_principal_group_name : ""
}

module "operator-beta" {
  count               = var.create_operator && var.enable_beta ? 1 : 0
  source              = "./modules/operator"
  state_id            = random_id.state_id.id
  label_prefix        = var.label_prefix # TODO Deprecated
  config_file_profile = var.config_file_profile
  tenancy_id          = local.tenancy_id
  compartment_id      = local.compartment_id

  defined_tags = merge(lookup(var.defined_tags, "operator", {}), var.tag_namespace != "" ? {
    "${var.tag_namespace}.state_id" : var.state_id,
    "${var.tag_namespace}.role" : "operator",
  } : {})
  freeform_tags = lookup(var.freeform_tags, "operator", {})

  # Networking
  assign_dns          = var.assign_dns
  availability_domain = var.availability_domains["operator"]
  operator_nsg_ids    = concat(var.operator_nsg_ids, lookup(module.network.nsg_ids, "operator", []))
  operator_subnet_id  = lookup(module.network.subnet_ids, "operator")
  ssh_public_key      = var.ssh_public_key
  ssh_public_key_path = var.ssh_public_key_path
  vcn_id              = local.vcn_id

  # Host parameters
  operator_image_id               = var.operator_image_id
  enable_pv_encryption_in_transit = var.enable_operator_pv_encryption_in_transit
  operator_os_version             = var.operator_os_version
  operator_shape                  = var.operator_shape
  operator_timezone               = var.operator_timezone
  upgrade_operator                = var.upgrade_operator
  boot_volume_encryption_key      = var.operator_volume_kms_id

  # Notifications
  enable_operator_notification   = var.enable_operator_notification
  operator_notification_endpoint = var.operator_notification_endpoint
  operator_notification_protocol = var.operator_notification_protocol
  operator_notification_topic    = var.operator_notification_topic

  providers = {
    oci.home = oci.home,
  }

  depends_on = [
    module.vcn,
    module.network,
  ]
}

module "operator" { # TODO Deprecated
  count          = var.create_operator && !var.enable_beta ? 1 : 0
  source         = "oracle-terraform-modules/operator/oci"
  version        = "3.1.5"
  tenancy_id     = local.tenancy_id
  compartment_id = local.compartment_id
  label_prefix   = var.label_prefix # TODO Deprecated

  freeform_tags = var.freeform_tags["operator"]

  # Networking
  assign_dns          = var.assign_dns
  availability_domain = var.availability_domains["operator"]
  nat_route_id        = local.nat_route_id
  netnum              = lookup(var.subnets["operator"], "netnum")
  newbits             = lookup(var.subnets["operator"], "newbits")
  nsg_ids             = var.operator_nsg_ids
  vcn_id              = local.vcn_id

  # Host parameters
  operator_image_id                  = var.operator_image_id
  enable_operator_instance_principal = var.enable_operator_instance_principal && var.create_policies
  enable_pv_encryption_in_transit    = var.enable_operator_pv_encryption_in_transit
  operator_os_version                = var.operator_os_version
  operator_shape                     = var.operator_shape
  operator_state                     = var.operator_state
  operator_timezone                  = var.operator_timezone
  ssh_public_key                     = var.ssh_public_key
  ssh_public_key_path                = var.ssh_public_key_path
  upgrade_operator                   = var.upgrade_operator
  boot_volume_encryption_key         = var.operator_volume_kms_id

  # Notifications
  enable_operator_notification   = var.enable_operator_notification
  operator_notification_endpoint = var.operator_notification_endpoint
  operator_notification_protocol = var.operator_notification_protocol
  operator_notification_topic    = var.operator_notification_topic

  providers = {
    oci.home = oci.home
  }

  depends_on = [
    module.vcn
  ]
}
