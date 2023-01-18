# Copyright (c) 2022, 2023 Oracle Corporation and/or its affiliates.
# Licensed under the Universal Permissive License v 1.0 as shown at https://oss.oracle.com/licenses/upl

output "worker_availability_domains" {
  description = "Worker availability domains"
  value       = local.ad_number_to_name
}

output "worker_groups_enabled" {
  description = "Worker groups enabled in configuration"
  value       = local.worker_groups_enabled_out
}

output "worker_groups_active" {
  description = "Worker groups provisioned in Terraform state"
  value       = local.worker_groups_active
}

output "expected_node_count" {
  description = "# of nodes expected from enabled worker groups"
  value       = local.expected_node_count
}

output "worker_group_ids" {
  description = "OKE worker group OCIDs"
  value       = { for k, v in local.worker_groups_active : k => v.id }
}

output "worker_node_pools" {
  description = "OKE-managed Node Pools"
  value       = local.worker_node_pools
}

output "worker_instance_pools" {
  description = "Self-managed Instance Pools"
  value       = local.worker_instance_pools
}

output "worker_cluster_networks" {
  description = "Self-managed Cluster Networks"
  value       = local.worker_cluster_networks
}

output "autoscaling_groups" {
  description = "Worker groups compatible with and enabled for Cluster Autoscaler management"
  value = { for k, v in merge(
    local.worker_node_pools,
    local.worker_instance_pools,
  ) : k => v if lookup(v, "autoscale", false) == true }
}

output "np_options" {
  description = "OKE node pool options"
  value       = data.oci_containerengine_node_pool_option.np_options
}
