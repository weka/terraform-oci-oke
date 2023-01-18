# Copyright (c) 2017, 2023 Oracle Corporation and/or its affiliates.
# Licensed under the Universal Permissive License v 1.0 as shown at https://oss.oracle.com/licenses/upl

locals {
  bastion_public_ip = var.create_bastion_host ? module.bastion[0].bastion_public_ip : var.bastion_public_ip
}

module "bastion" {
  count          = var.create_bastion_host ? 1 : 0
  source         = "oracle-terraform-modules/bastion/oci"
  version        = "3.1.5"
  tenancy_id     = local.tenancy_id
  compartment_id = local.compartment_id
  label_prefix   = var.label_prefix # TODO Deprecated

  freeform_tags = var.freeform_tags["bastion"]

  # Networking
  assign_dns          = var.assign_dns
  availability_domain = var.availability_domains["bastion"]
  bastion_access      = var.bastion_access
  ig_route_id         = local.ig_route_id
  netnum              = lookup(var.subnets["bastion"], "netnum")
  newbits             = lookup(var.subnets["bastion"], "newbits")
  vcn_id              = local.vcn_id

  # Host parameters
  bastion_image_id   = var.bastion_image_id
  bastion_os_version = var.bastion_os_version
  bastion_shape      = var.bastion_shape
  bastion_state      = var.bastion_state
  bastion_timezone   = var.bastion_timezone
  bastion_type       = var.bastion_type

  ssh_public_key      = var.ssh_public_key
  ssh_public_key_path = var.ssh_public_key_path
  upgrade_bastion     = var.upgrade_bastion

  # Notifications
  enable_bastion_notification   = var.enable_bastion_notification && var.create_policies
  bastion_notification_endpoint = var.bastion_notification_endpoint
  bastion_notification_protocol = var.bastion_notification_protocol
  bastion_notification_topic    = var.bastion_notification_topic

  providers = {
    oci.home = oci.home
  }

  depends_on = [
    module.vcn
  ]
}

module "bastionsvc" {
  count          = var.create_bastion_service ? 1 : 0
  source         = "./modules/bastionsvc"
  state_id       = random_id.state_id.id
  compartment_id = local.compartment_id
  label_prefix   = var.label_prefix # TODO Deprecated

  # Service parameters
  bastion_service_access        = var.bastion_service_access
  bastion_service_name          = var.bastion_service_name
  bastion_service_target_subnet = var.bastion_service_target_subnet
  vcn_id                        = local.vcn_id

  depends_on = [
    module.operator
  ]
}
