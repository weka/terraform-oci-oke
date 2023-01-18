# Copyright (c) 2017, 2023 Oracle Corporation and/or its affiliates.
# Licensed under the Universal Permissive License v 1.0 as shown at https://oss.oracle.com/licenses/upl

# variable "enable_operator_instance_principal" {
#   type = bool
# }

variable "cluster_id" {}
variable "cluster_kms_key_id" {}           # TODO Deprecated - move to IAM sub-module
variable "cluster_kms_dynamic_group_id" {} # TODO Deprecated - move to IAM sub-module
variable "operator_dynamic_group" {}       # TODO Deprecated - move to IAM sub-module

variable "pods_cidr" {}

variable "cni_type" {}

variable "expected_node_count" {
  default     = 0
  description = "# of expected worker nodes, used to block until cluster is ready to schedule workloads when check_node_active != 'none'."
  type        = number
}
