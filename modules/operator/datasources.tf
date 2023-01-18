# Copyright (c) 2017, 2023 Oracle Corporation and/or its affiliates.
# Licensed under the Universal Permissive License v 1.0 as shown at https://oss.oracle.com/licenses/upl

data "oci_identity_availability_domain" "ad" {
  compartment_id = local.compartment_id
  ad_number      = var.availability_domain
}

data "oci_identity_tenancy" "tenancy" {
  tenancy_id = local.tenancy_id
}

data "oci_core_images" "oracle_images" {
  count                    = var.operator_image_id == "Oracle" ? 1 : 0
  compartment_id           = local.compartment_id
  operating_system         = "Oracle Linux"
  operating_system_version = var.operator_os_version
  shape                    = lookup(var.operator_shape, "shape", "VM.Standard.E4.Flex")
  sort_by                  = "TIMECREATED"
}

data "cloudinit_config" "operator" {
  gzip          = true
  base64_encode = true

  part {
    filename     = "operator.yaml"
    content_type = "text/cloud-config"
    content = templatefile(
      "${path.module}/cloudinit/operator.template.yaml", {
        operator_timezone = var.operator_timezone,
        upgrade_operator  = var.upgrade_operator,
      }
    )
  }
}
