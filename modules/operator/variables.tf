# Copyright (c) 2019, 2023 Oracle Corporation and/or its affiliates.
# Licensed under the Universal Permissive License v 1.0 as shown at https://oss.oracle.com/licenses/upl

variable "assign_dns" {
  default     = true
  description = "Whether to assign DNS records for operator subnet"
  type        = bool
}

variable "availability_domain" {
  description = "the AD to place the operator host"
  default     = 1
  type        = number
}

variable "vcn_id" {
  description = "The id of the VCN to use when creating the operator resources."
  type        = string
}

variable "enable_pv_encryption_in_transit" {
  description = "Whether to enable in-transit encryption for the data volume's paravirtualized attachment. The default value is false"
  default     = false
  type        = bool
}

variable "boot_volume_encryption_key" {
  description = "The OCID of the OCI KMS key to assign as the master encryption key for the boot volume."
  default     = ""
  type        = string
}

variable "defined_tags" {
  default     = {}
  description = "Tags to apply to created resources"
  type        = map(string)
}

variable "freeform_tags" {
  default     = {}
  description = "Tags to apply to created resources"
  type        = map(string)
}
