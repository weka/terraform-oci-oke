# Copyright (c) 2017, 2023 Oracle Corporation and/or its affiliates.
# Licensed under the Universal Permissive License v 1.0 as shown at https://oss.oracle.com/licenses/upl

locals {
  vcn_id       = var.create_vcn ? module.vcn[0].vcn_id : coalesce(var.vcn_id, try(data.oci_core_vcns.vcns[0].virtual_networks[0].id, ""))
  ig_route_id  = var.create_vcn ? module.vcn[0].ig_route_id : coalesce(var.ig_route_id, try(data.oci_core_route_tables.ig[0].route_tables[0].id, ""))
  nat_route_id = var.create_vcn ? module.vcn[0].nat_route_id : coalesce(var.nat_route_id, try(data.oci_core_route_tables.nat[0].route_tables[0].id, ""))
}

module "vcn" {
  count          = var.create_vcn ? 1 : 0
  source         = "oracle-terraform-modules/vcn/oci"
  version        = "3.5.3"
  compartment_id = local.compartment_id
  label_prefix   = var.label_prefix # TODO Deprecated
  # label_prefix   =  "oke-${var.state_id}"

  create_internet_gateway  = !(var.load_balancers == "internal" && !var.create_bastion_host && var.control_plane_type == "private")
  create_nat_gateway       = var.worker_type == "private" || var.create_operator == true || var.load_balancers == "internal" || var.load_balancers == "both"
  create_service_gateway   = true
  nat_gateway_public_ip_id = var.nat_gateway_public_ip_id
  attached_drg_id          = var.drg_id != null ? var.drg_id : (var.create_drg ? module.drg[0].drg_id : null)
  local_peering_gateways   = var.local_peering_gateways

  freeform_tags = var.freeform_tags["vcn"]
  defined_tags  = var.defined_tags["vcn"]

  vcn_cidrs                    = var.vcn_cidrs
  vcn_dns_label                = var.assign_dns ? var.vcn_dns_label : null
  vcn_name                     = var.vcn_name
  lockdown_default_seclist     = var.lockdown_default_seclist
  internet_gateway_route_rules = var.internet_gateway_route_rules
  nat_gateway_route_rules      = var.nat_gateway_route_rules
}

module "drg" {
  count          = var.create_drg || var.drg_id != null ? 1 : 0
  source         = "oracle-terraform-modules/drg/oci"
  version        = "1.0.3"
  compartment_id = local.compartment_id
  label_prefix   = var.label_prefix # TODO Deprecated
  # label_prefix   = "oke-${var.state_id}"

  drg_id           = var.drg_id # existing DRG ID or null
  drg_display_name = var.drg_display_name
  drg_vcn_attachments = { for k, v in module.vcn : k => {
    vcn_id : v.vcn_id
    vcn_transit_routing_rt_id : null
    drg_route_table_id : null
    }
  }
}

module "network" {
  source         = "./modules/network"
  state_id       = random_id.state_id.id
  compartment_id = local.compartment_id
  label_prefix   = var.label_prefix # TODO Deprecated

  assign_dns   = var.assign_dns
  ig_route_id  = local.ig_route_id
  nat_route_id = local.nat_route_id
  subnets      = var.subnets
  vcn_id       = local.vcn_id

  cni_type                     = var.cni_type
  control_plane_type           = var.control_plane_type
  control_plane_allowed_cidrs  = var.control_plane_allowed_cidrs
  allow_node_port_access       = var.allow_node_port_access
  allow_worker_internet_access = var.allow_worker_internet_access
  allow_pod_internet_access    = var.allow_pod_internet_access
  allow_worker_ssh_access      = var.allow_worker_ssh_access
  worker_type                  = var.worker_type

  load_balancers            = var.load_balancers
  internal_lb_allowed_cidrs = var.internal_lb_allowed_cidrs
  internal_lb_allowed_ports = var.internal_lb_allowed_ports
  public_lb_allowed_cidrs   = var.public_lb_allowed_cidrs
  public_lb_allowed_ports   = var.public_lb_allowed_ports

  enable_waf      = var.enable_waf
  create_fss      = var.create_fss
  create_operator = var.create_operator

  providers = {
    oci.home = oci.home
  }

  depends_on = [
    module.vcn
  ]
}
