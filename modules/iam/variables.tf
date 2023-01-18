# Copyright (c) 2022, 2023 Oracle Corporation and/or its affiliates.
# Licensed under the Universal Permissive License v 1.0 as shown at https://oss.oracle.com/licenses/upl

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

variable "autoscaler_compartments" {
  default     = []
  description = "Compartment IDs with Cluster Autoscaler-enabled worker groups"
  type        = list(string)
}

variable "worker_compartments" {
  default     = []
  description = "Compartment IDS with enabled worker groups"
  type        = list(string)
}
