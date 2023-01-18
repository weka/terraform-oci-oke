# Copyright (c) 2017, 2023 Oracle Corporation and/or its affiliates.
# Licensed under the Universal Permissive License v 1.0 as shown at https://oss.oracle.com/licenses/upl

variable "admission_controller_options" {
  default = {
    PodSecurityPolicy = false
  }
  description = "various Admission Controller options"
  type        = map(bool)
}

variable "cluster_enabled" {
  default     = true
  description = "Whether to create the OKE cluster and dependent resources."
  type        = bool
}

variable "cluster_name" {
  default     = "oke"
  description = "The name of oke cluster."
  type        = string
}

variable "control_plane_type" {
  default     = "public"
  description = "Whether to allow public or private access to the control plane endpoint"
  type        = string

  validation {
    condition     = contains(["public", "private"], var.control_plane_type)
    error_message = "Accepted values are public, or private."
  }
}

variable "apiserver_private_host" {
  default     = ""
  description = "Cluster private apiserver IP address. Resolved automatically when OKE cluster is found using cluster_id."
  type        = string
}

variable "apiserver_public_host" {
  default     = ""
  description = "Cluster public apiserver IP address, when enabled. Resolved automatically when OKE cluster is found using cluster_id."
  type        = string
}

variable "cni_type" {
  default     = "flannel"
  description = "The CNI for the cluster. Choose between flannel or npn"
  type        = string
  validation {
    condition     = contains(["flannel", "npn"], var.cni_type)
    error_message = "Accepted values are flannel or npn"
  }
}

variable "dashboard_enabled" {
  default     = false
  description = "Whether to enable kubernetes dashboard."
  type        = bool
}

variable "kubernetes_version" {
  default     = "v1.24.1"
  description = "The version of kubernetes to use when provisioning OKE or to upgrade an existing OKE cluster to."
  type        = string
}

variable "max_pods_per_node" {
  default     = 31
  description = "The maximum number of pods to deploy per node. Absolute maximum is 110. Applies only when CNI type is npn."
  type        = number
}

variable "cluster_kms_key_id" {
  default     = ""
  description = "The id of the OCI KMS key to be used as the master encryption key for Kubernetes secrets encryption."
  type        = string
}

variable "node_pool_volume_kms_key_id" {
  default     = ""
  description = "The id of the OCI KMS key to be used as the master encryption key for Boot Volume and Block Volume encryption."
  type        = string
}

# oke cluster container image policy and keys
variable "use_signed_images" {
  description = "Whether to enforce the use of signed images. If set to true, at least 1 RSA key must be provided through image_signing_keys."
  default     = false
  type        = bool
}

variable "image_signing_keys" {
  description = "A list of KMS key ids used by the worker nodes to verify signed images. The keys must use RSA algorithm."
  type        = list(string)
  default     = []
}

# node pools
variable "enable_pv_encryption_in_transit" {
  description = "Whether to enable in-transit encryption for the data volume's paravirtualized attachment. This field applies to both block volumes and boot volumes. The default value is false"
  type        = bool
  default     = false
}

variable "cloudinit_nodepool" {
  description = "Cloudinit script specific to nodepool"
  type        = map(any)
  default     = {}
}

variable "cloudinit_nodepool_common" {
  description = "Cloudinit script common to all nodepool when cloudinit_nodepool  is not provided"
  type        = string
  default     = ""
}

variable "kubeproxy_mode" {
  default     = "iptables"
  description = "The mode in which to run kube-proxy."
  type        = string

  validation {
    condition     = contains(["iptables", "ipvs"], var.kubeproxy_mode)
    error_message = "Accepted values are iptables or ipvs."
  }
}
variable "node_pools" {
  default     = {}
  description = "Tuple of node pools. Each key maps to a node pool. Each value is a tuple of shape (string),ocpus(number) , node_pool_size(number) and boot_volume_size(number)"
  type        = any
}

variable "node_pool_image_id" {
  default     = "none"
  description = "The ocid of a custom image to use for worker node."
  type        = string
}

variable "node_pool_image_type" {
  default     = "oke"
  description = "Whether to use a Platform, OKE or custom image. When custom is set, the node_pool_image_id must be specified."
  type        = string
  validation {
    condition     = contains(["custom", "oke", "platform"], var.node_pool_image_type)
    error_message = "Accepted values are custom, oke, platform."
  }
}

variable "node_pool_name_prefix" {
  default     = "np"
  description = "The prefix of the node pool name."
  type        = string
}

variable "node_pool_os" {
  default     = "Oracle Linux"
  description = "The name of image to use."
  type        = string
}

variable "node_pool_os_version" {
  default     = "7.9"
  description = "The version of operating system to use for the worker nodes."
  type        = string
}

variable "node_pool_timezone" {
  default     = "Etc/UTC"
  description = "The preferred timezone for the worker nodes."
  type        = string
}

variable "control_plane_nsgs" {
  default     = []
  description = "An additional list of network security groups (NSG) ids for the cluster endpoint that can be created subsequently."
  type        = list(string)
}

variable "pod_nsgs" {
  default     = []
  description = "An additional list of network security group (NSG) ids for pods."
  type        = list(string)
}

variable "worker_nsgs" {
  default     = []
  description = "An additional list of network security group (NSG) ids for worker nodes."
  type        = list(string)
}

variable "load_balancers" {
  # values: both, internal, public
  default     = "public"
  description = "The type of subnets to create for load balancers."
  type        = string
  validation {
    condition     = contains(["public", "internal", "both"], var.load_balancers)
    error_message = "Accepted values are public, internal or both."
  }
}

variable "preferred_load_balancer" {
  # values: public, internal.
  # When creating an internal load balancer, the internal annotation must still be specified regardless
  default     = "public"
  description = "The preferred load balancer subnets that OKE will automatically choose when creating a load balancer. valid values are public or internal. if 'public' is chosen, the value for load_balancers must be either 'public' or 'both'. If 'private' is chosen, the value for load_balancers must be either 'internal' or 'both'."
  type        = string
  validation {
    condition     = contains(["public", "internal"], var.preferred_load_balancer)
    error_message = "Accepted values are public or internal."
  }
}
