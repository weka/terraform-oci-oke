# Copyright (c) 2017, 2023 Oracle Corporation and/or its affiliates.
# Licensed under the Universal Permissive License v 1.0 as shown at https://oss.oracle.com/licenses/upl

variable "create_operator" {
  default     = true
  description = "Whether to create an operator server in a private subnet."
  type        = bool
}

variable "operator_image_id" {
  default     = "Oracle"
  description = "The image id to use for operator server. Set either an image id or to Oracle. If value is set to Oracle, the default Oracle Linux platform image will be used."
  type        = string
}

variable "operator_volume_kms_id" {
  default     = ""
  description = "The OCID of the OCI KMS key to assign as the master encryption key for the boot volume."
  type        = string
}

variable "enable_operator_pv_encryption_in_transit" {
  default     = false
  description = "Whether to enable in-transit encryption for the data volume's paravirtualized attachment."
  type        = bool
}

variable "operator_subnet_id" {
  default     = ""
  description = "The OCID of a subnet in the VCN for the operator instance."
  type        = string
}

variable "operator_nsg_ids" {
  description = "An optional and updatable list of network security groups that the operator will be part of."
  type        = list(string)
  default     = []
}

variable "operator_os_version" {
  default     = "8"
  description = "The Oracle Linux version to use for the operator host"
  type        = string
}

variable "operator_user" {
  default     = "opc"
  description = "User for SSH access to operator host."
  type        = string
}

variable "operator_shape" {
  default = {
    shape            = "VM.Standard.E4.Flex",
    ocpus            = 1,
    memory           = 4,
    boot_volume_size = 50
  }
  description = "The shape of operator instance."
  type        = map(any)
}

variable "operator_state" {
  description = "DEPRECATED - The target state for the operator instance. Could be set to RUNNING or STOPPED. Will be removed in next major version."
  default     = "RUNNING"
  type        = string
  validation {
    condition     = contains(["RUNNING", "STOPPED"], var.operator_state)
    error_message = "Accepted values are RUNNING or STOPPED."
  }
}

variable "operator_timezone" {
  default     = "Etc/UTC"
  description = "The preferred timezone for the operator host."
  type        = string
}

variable "upgrade_operator" {
  default     = true
  description = "Whether to upgrade the operator packages after provisioning. It’s useful to set this to false during development so the operator is provisioned faster."
  type        = bool
}

variable "operator_private_ip" {
  default     = ""
  description = "The IP address of an existing operator host, if create_operator: false."
  type        = string
}

variable "enable_operator_notification" {
  default     = false
  description = "Whether to enable notification on the operator host."
  type        = bool
}

variable "operator_notification_endpoint" {
  default     = "none"
  description = "The subscription notification endpoint for the operator. Email address to be notified."
  type        = string
}

variable "operator_notification_protocol" {
  default     = "EMAIL"
  description = "The notification protocol used."
  type        = string
}

variable "operator_notification_topic" {
  description = "The name of the notification topic."
  default     = "operator"
  type        = string
}

variable "enable_operator_instance_principal" {
  default     = true
  description = "DEPRECATED - Whether to enable the operator to call OCI API services without requiring api key. Will be removed in the next major version."
  type        = bool
}
