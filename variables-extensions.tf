# Copyright (c) 2017, 2023 Oracle Corporation and/or its affiliates.
# Licensed under the Universal Permissive License v 1.0 as shown at https://oss.oracle.com/licenses/upl

variable "check_node_active" {
  description = "check worker node is active"
  type        = string
  default     = "none"

  validation {
    condition     = contains(["none", "one", "all"], var.check_node_active)
    error_message = "Accepted values are none, one or all."
  }
}

# Upgrade existing node pools
variable "upgrade_nodepool" {
  default     = false
  description = "Whether to upgrade the Kubernetes version of the node pools."
  type        = bool
}

variable "node_pools_to_drain" {
  default     = ["none"]
  description = "List of node pool names to drain during an upgrade. This list is used to determine the worker nodes to drain."
  type        = list(string)
}

variable "nodepool_upgrade_method" {
  default     = "out_of_place"
  description = "The upgrade method to use when upgrading to a new version. Only out-of-place supported at the moment."
  type        = string
}

# File Storage Service (FSS)
variable "create_fss" {
  description = "Whether to enable provisioning for FSS"
  default     = false
  type        = bool
}

# FSS mount path
variable "fss_mount_path" {
  description = "FSS mount path to be associated"
  default     = "/oke_fss"
  type        = string
}

# Controls the maximum tbytes, fbytes, and abytes, values reported by NFS FSSTAT calls through any associated mount targets.
variable "max_fs_stat_bytes" {
  description = "Maximum tbytes, fbytes, and abytes, values reported by NFS FSSTAT calls through any associated mount targets"
  default     = 23843202333
  type        = number
}

# Controls the maximum tfiles, ffiles, and afiles values reported by NFS FSSTAT calls through any associated mount targets.
variable "max_fs_stat_files" {
  description = "Maximum tfiles, ffiles, and afiles values reported by NFS FSSTAT"
  default     = 223442
  type        = number
}

# Oracle Container Image Registry (OCIR)
variable "email_address" {
  default     = "none"
  description = "The email address used for OCIR."
  type        = string
}

variable "secret_id" {
  description = "The OCID of the Secret on OCI Vault which holds the authentication token."
  type        = string
  default     = "none"
}

variable "secret_name" {
  description = "The name of the Kubernetes secret that will hold the authentication token"
  type        = string
  default     = "ocirsecret"
}

variable "secret_namespace" {
  default     = "default"
  description = "The Kubernetes namespace for where the OCIR secret will be created."
  type        = string
}

variable "username" {
  default     = "none"
  description = "The username that can login to the selected tenancy. This is different from tenancy_id. *Required* if secret_id is set."
  type        = string
}

# Calico
variable "enable_calico" {
  description = "Whether to install calico for network pod security policy"
  default     = false
  type        = bool
}

variable "calico_version" {
  description = "The version of Calico to install"
  default     = "3.24.1"
  type        = string
}

variable "calico_mode" {
  description = "The type of Calico manifest to install"
  default     = "policy-only"
  validation {
    condition     = contains(["policy-only", "canal", "vxlan", "ipip", "flannel-migration"], var.calico_mode)
    error_message = "Accepted values are policy-only, canal, vxlan, ipip, or flannel-migration."
  }
}

variable "calico_mtu" {
  description = "Interface MTU for Calico device(s) (0 = auto)"
  default     = 0
  type        = number
}

variable "calico_url" {
  description = "Optionally override the Calico manifest URL (empty string = auto)"
  default     = ""
  type        = string
}

variable "calico_apiserver_enabled" {
  description = "Whether to enable the Calico apiserver"
  default     = false
  type        = bool
}

variable "typha_enabled" {
  description = "Whether to enable Typha (automatically enabled for > 50 nodes)"
  default     = false
  type        = bool
}

variable "typha_replicas" {
  description = "The number of replicas for the Typha deployment (0 = auto)"
  default     = 0
  type        = number
}

variable "calico_staging_dir" {
  description = "Directory on the operator instance to stage Calico install files"
  default     = "/tmp/calico_install"
  type        = string
}

# Horizontal and vertical pod autoscaling
variable "enable_metric_server" {
  description = "Whether to install metricserver for collecting metrics and for HPA"
  default     = false
  type        = bool
}

variable "enable_vpa" {
  description = "Whether to install vertical pod autoscaler"
  default     = false
  type        = bool
}

variable "vpa_version" {
  description = "The version of vertical pod autoscaler to install"
  default     = "0.8"
}

# Gatekeeper
variable "enable_gatekeeper" {
  type        = bool
  default     = false
  description = "Whether to install Gatekeeper"
}

variable "gatekeeper_version" {
  type        = string
  default     = "3.7"
  description = "The version of Gatekeeper to install"
}

# Service account
variable "create_service_account" {
  description = "Whether to create a service account. A service account is required for CI/CD. see https://docs.cloud.oracle.com/iaas/Content/ContEng/Tasks/contengaddingserviceaccttoken.htm"
  default     = false
  type        = bool
}

variable "service_account_name" {
  description = "The name of service account to create"
  default     = "kubeconfigsa"
  type        = string
}

variable "service_account_namespace" {
  description = "The Kubernetes namespace where to create the service account"
  default     = "kube-system"
  type        = string
}

variable "service_account_cluster_role_binding" {
  description = "The cluster role binding name"
  default     = "cluster-admin"
  type        = string
}

variable "autoscaling_groups" {
  default     = {}
  description = "Worker groups compatible with and enabled for Cluster Autoscaler management."
  type        = any
}

variable "deploy_cluster_autoscaler" {
  default     = false
  description = "Whether to deploy the cluster autoscaler."
  type        = bool
}
