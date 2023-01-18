# Copyright (c) 2017, 2023 Oracle Corporation and/or its affiliates.
# Licensed under the Universal Permissive License v 1.0 as shown at https://oss.oracle.com/licenses/upl

data "oci_core_services" "all_oci_services" {
  filter {
    name   = "name"
    values = ["All .* Services In Oracle Services Network"]
    regex  = true
  }
}

data "oci_core_subnets" "oke_subnets" {
  compartment_id = local.compartment_id
  vcn_id         = var.vcn_id

  filter {
    name   = "state"
    values = ["AVAILABLE"]
  }
}

data "oci_core_vcn" "vcn" {
  vcn_id = var.vcn_id
}

data "oci_waas_edge_subnets" "waf_cidr_blocks" {
  count = var.enable_waf == true ? 1 : 0
}
