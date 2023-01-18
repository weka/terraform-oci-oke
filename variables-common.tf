# Copyright (c) 2023 Oracle Corporation and/or its affiliates.
# Licensed under the Universal Permissive License v 1.0 as shown at https://oss.oracle.com/licenses/upl

variable "label_prefix" {
  default     = "none"
  description = "DEPRECATED - A string that will be prepended to all resources. Will be removed in next major version."
  type        = string
}

variable "state_id" {
  default     = "none"
  description = "A string that uniquely identifies the current Terraform state for naming resources."
  type        = string
}

variable "debug_mode" {
  default     = false
  description = "Whether to turn on debug mode."
  type        = bool
}

variable "enable_beta" {
  default     = false
  description = "Whether to use new implementations that may result in replacement of resources."
  type        = bool
}
