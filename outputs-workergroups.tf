# Copyright (c) 2022, 2023 Oracle Corporation and/or its affiliates.
# Licensed under the Universal Permissive License v 1.0 as shown at https://oss.oracle.com/licenses/upl

output "worker_groups_enabled" {
  description = "Desired worker group state to be applied"
  value       = length(module.workergroup.worker_groups_enabled) > 0 ? module.workergroup.worker_groups_enabled : null
}

output "worker_group_ids" {
  description = "All active worker group OCIDs"
  value       = length(module.workergroup.worker_group_ids) > 0 ? module.workergroup.worker_group_ids : null
}

output "worker_availability_domains" {
  description = "All worker group ADs"
  value       = length(module.workergroup.worker_group_ids) > 0 ? module.workergroup.worker_availability_domains : null
}

output "worker_np_options" {
  description = "OKE node pool options (when debug_mode==true)"
  value       = var.debug_mode ? (length(module.workergroup.np_options) > 0 ? module.workergroup.np_options : null) : null
}
