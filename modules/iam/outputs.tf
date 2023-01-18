# Copyright (c) 2022, 2023 Oracle Corporation and/or its affiliates.
# Licensed under the Universal Permissive License v 1.0 as shown at https://oss.oracle.com/licenses/upl

output "group_policy_statements" {
  description = "Cluster IAM policy statements"
  value       = local.group_policy_statements
}
