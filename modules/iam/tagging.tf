# Copyright (c) 2022, 2023 Oracle Corporation and/or its affiliates.
# Licensed under the Universal Permissive License v 1.0 as shown at https://oss.oracle.com/licenses/upl

data "oci_identity_tag_namespaces" "tag_oke_ns" {
  provider       = oci.home
  count          = local.create_tags ? 1 : 0
  compartment_id = local.compartment_id
  state          = "ACTIVE" // TODO Support reactivation of retired namespace w/ update
}

data "oci_identity_tag" "tag_oke_pool" {
  provider         = oci.home
  count            = local.create_tags ? 1 : 0
  tag_name         = "pool"
  tag_namespace_id = local.tag_oke_ns_id
}

data "oci_identity_tag" "tag_oke_state_id" {
  provider         = oci.home
  count            = local.create_tags ? 1 : 0
  tag_name         = "state_id"
  tag_namespace_id = local.tag_oke_ns_id
}

data "oci_identity_tag" "tag_oke_role" {
  provider         = oci.home
  count            = local.create_tags ? 1 : 0
  tag_name         = "role"
  tag_namespace_id = local.tag_oke_ns_id
}

locals {
  create_tags             = var.create_tags && coalesce(var.tag_namespace, "none") != "none"
  found_tag_oke_ns        = one([for n in flatten(data.oci_identity_tag_namespaces.tag_oke_ns[*].tag_namespaces) : n.id if n.name == var.tag_namespace])
  found_tag_oke_pool      = local.found_tag_oke_ns != null ? one(data.oci_identity_tag.tag_oke_pool[*].id) : null
  found_tag_oke_state_id  = local.found_tag_oke_ns != null ? one(data.oci_identity_tag.tag_oke_state_id[*].id) : null
  found_tag_oke_role = local.found_tag_oke_ns != null ? one(data.oci_identity_tag.tag_oke_role[*].id) : null

  tag_oke_ns_id     = local.found_tag_oke_ns != null ? local.found_tag_oke_ns : one(oci_identity_tag_namespace.tag_oke_ns[*].id)
  tag_oke_pool      = local.found_tag_oke_pool != null ? local.found_tag_oke_pool : one(oci_identity_tag.tag_oke_pool[*].id)
  tag_oke_state_id  = local.found_tag_oke_state_id != null ? local.found_tag_oke_state_id : one(oci_identity_tag.tag_oke_pool[*].id)
  tag_oke_role = local.found_tag_oke_role != null ? local.found_tag_oke_role : one(oci_identity_tag.tag_oke_role[*].id)
}

resource "oci_identity_tag_namespace" "tag_oke_ns" {
  provider       = oci.home
  count          = local.create_tags && local.found_tag_oke_ns == null ? 1 : 0
  compartment_id = local.compartment_id
  description    = "Tag namespace for OKE resources"
  name           = var.tag_namespace
  defined_tags   = var.defined_tags
  freeform_tags  = var.freeform_tags
  lifecycle {
    ignore_changes = [defined_tags, freeform_tags]
  }
}

resource "oci_identity_tag" "tag_oke_pool" {
  provider         = oci.home
  count            = local.create_tags && local.found_tag_oke_pool == null ? 1 : 0
  description      = "Tag to indicate group membership of a worker node"
  name             = "pool"
  tag_namespace_id = local.tag_oke_ns_id
  defined_tags     = var.defined_tags
  freeform_tags    = var.freeform_tags
  lifecycle {
    ignore_changes = [defined_tags, freeform_tags]
  }
}

resource "oci_identity_tag" "tag_oke_state_id" {
  provider         = oci.home
  count            = local.create_tags && local.found_tag_oke_state_id == null ? 1 : 0
  description      = "Tag to indicate Terraform state ID of a resource"
  name             = "state_id"
  tag_namespace_id = local.tag_oke_ns_id
  defined_tags     = var.defined_tags
  freeform_tags    = var.freeform_tags
  lifecycle {
    ignore_changes = [defined_tags, freeform_tags]
  }
}

resource "oci_identity_tag" "tag_oke_role" {
  provider         = oci.home
  count            = local.create_tags && local.found_tag_oke_role == null ? 1 : 0
  description      = "Tag to indicate functional role of a particular resource"
  name             = "role"
  tag_namespace_id = local.tag_oke_ns_id
  defined_tags     = var.defined_tags
  freeform_tags    = var.freeform_tags
  lifecycle {
    ignore_changes = [defined_tags, freeform_tags]
  }
}
