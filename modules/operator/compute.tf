# Copyright (c) 2017, 2023 Oracle Corporation and/or its affiliates.
# Licensed under the Universal Permissive License v 1.0 as shown at https://oss.oracle.com/licenses/upl

locals {
  shape    = lookup(var.operator_shape, "shape", "VM.Standard.E4.Flex")
  memory   = lookup(var.operator_shape, "memory", 4)
  ocpus    = max(1, lookup(var.operator_shape, "ocpus", 1))
  image_id = var.operator_image_id == "Oracle" ? data.oci_core_images.oracle_images[0].images.0.id : var.operator_image_id
}

resource "oci_core_instance" "operator" {
  availability_domain                 = data.oci_identity_availability_domain.ad.name
  compartment_id                      = local.compartment_id
  display_name                        = "operator-${var.state_id}"
  is_pv_encryption_in_transit_enabled = var.enable_pv_encryption_in_transit
  defined_tags                        = var.defined_tags
  freeform_tags                       = var.freeform_tags

  agent_config {
    are_all_plugins_disabled = false
    is_management_disabled   = false
    is_monitoring_disabled   = false

    plugins_config {
      desired_state = "ENABLED"
      name          = "Bastion"
    }
    plugins_config {
      desired_state = "DISABLED"
      name          = "OS Management Service Agent"
    }
  }

  create_vnic_details {
    assign_public_ip = false
    display_name     = "operator-${var.state_id}"
    hostname_label   = var.assign_dns ? "operator-${var.state_id}" : null
    nsg_ids          = var.operator_nsg_ids
    subnet_id        = var.operator_subnet_id
  }

  launch_options {
    boot_volume_type = "PARAVIRTUALIZED"
    network_type     = "PARAVIRTUALIZED"
  }

  metadata = {
    ssh_authorized_keys = local.ssh_public_key
    user_data           = data.cloudinit_config.operator.rendered
  }

  shape = local.shape

  dynamic "shape_config" {
    for_each = length(regexall("Flex", local.shape)) > 0 ? [1] : []
    content {
      ocpus         = local.ocpus
      memory_in_gbs = (local.memory / local.ocpus) > 64 ? (local.ocpus * 4) : local.memory
    }
  }

  source_details {
    source_type = "image"
    source_id   = local.image_id
    kms_key_id  = var.boot_volume_encryption_key
  }

  lifecycle {
    ignore_changes = [
      availability_domain,
      defined_tags, freeform_tags,
      metadata, source_details
    ]
  }

  timeouts {
    create = "60m"
  }
}
