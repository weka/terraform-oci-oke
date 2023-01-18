# Copyright (c) 2017, 2023 Oracle Corporation and/or its affiliates.
# Licensed under the Universal Permissive License v 1.0 as shown at https://oss.oracle.com/licenses/upl

variable "cluster_options_add_ons_is_kubernetes_dashboard_enabled" {
  type = bool
}

variable "cluster_options_kubernetes_network_config_pods_cidr" {}

variable "cluster_options_kubernetes_network_config_services_cidr" {}

variable "cluster_subnets" {
  type = map(any)
}

variable "vcn_id" {}

variable "freeform_tags" {
  type = map(any)
}

variable "defined_tags" {
  type = map(any)
}
