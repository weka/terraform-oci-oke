# Copyright (c) 2017, 2023 Oracle Corporation and/or its affiliates.
# Licensed under the Universal Permissive License v 1.0 as shown at https://oss.oracle.com/licenses/upl

variable "worker_type" {
  default     = "private"
  description = "Whether to provision public or private workers."
  type        = string
  validation {
    condition     = contains(["public", "private"], var.worker_type)
    error_message = "Accepted values are public or private."
  }
}

variable "availability_domains" {
  description = "Availability Domains where to provision non-OKE resources"
  default = {
    bastion  = 1
    operator = 1
    fss      = 1
  }
  type = map(any)
}

variable "freeform_tags" {
  default = {
    # vcn, bastion and operator tags are required
    # add more tags in each as desired
    vcn = {
      environment = "dev"
    }
    bastion = {
      environment = "dev"
      role        = "bastion"
    }
    operator = {
      environment = "dev"
      role        = "operator"
    }
    oke = {

      cluster = {
        environment = "dev"
      }

      persistent_volume = {
        environment = "dev"
      }

      service_lb = {
        environment = "dev"
        role        = "load balancer"
      }
      node_pool = {}
    }
  }
  description = "Tags to apply to different resources."
  type = object({
    vcn      = map(any),
    bastion  = map(any),
    operator = map(any),
    oke      = map(map(any))
  })
}

variable "defined_tags" {
  default = {
    # vcn, oke are required
    # add more tags in each as desired
    vcn = {}
    oke = {
      cluster           = {}
      persistent_volume = {}
      service_lb        = {}
      node_pool         = {}
      node              = {}
    }
  }
  description = "Tags to apply to different resources."
  type = object({
    vcn = map(any),
    oke = map(any)
  })
}
