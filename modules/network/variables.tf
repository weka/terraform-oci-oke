# Copyright (c) 2017, 2023 Oracle Corporation and/or its affiliates.
# Licensed under the Universal Permissive License v 1.0 as shown at https://oss.oracle.com/licenses/upl

variable "control_plane_type" {
  default     = "public"
  description = "Whether to allow public or private access to the control plane endpoint"
  type        = string

  validation {
    condition     = contains(["public", "private"], var.control_plane_type)
    error_message = "Accepted values are public, or private."
  }
}

variable "cni_type" {
  # Keep flannel as default so users can upgrade without impact. Give a grace period for users to plan and change
  default     = "flannel"
  description = "The CNI for the cluster. Choose between flannel or npn."
  type        = string
  validation {
    condition     = contains(["flannel", "npn"], var.cni_type)
    error_message = "Accepted values are flannel or npn."
  }
}

variable "worker_type" {
  default     = "private"
  description = "Whether to provision public or private workers."
  type        = string
  validation {
    condition     = contains(["public", "private"], var.worker_type)
    error_message = "Accepted values are public or private."
  }
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

# File Storage Service (FSS)
variable "create_fss" {
  description = "Whether to enable provisioning for FSS"
  default     = false
  type        = bool
}

variable "create_operator" {
  default     = true
  description = "Whether to create an operator server in a private subnet."
  type        = bool
}
