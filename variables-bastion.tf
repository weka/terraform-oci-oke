# Copyright (c) 2017, 2023 Oracle Corporation and/or its affiliates.
# Licensed under the Universal Permissive License v 1.0 as shown at https://oss.oracle.com/licenses/upl

variable "create_bastion_host" {
  default     = true
  description = "Whether to create a bastion host."
  type        = bool
}

variable "bastion_public_ip" {
  default     = ""
  description = "The IP address of an existing bastion host, if create_bastion_host: false."
  type        = string
}

variable "bastion_access" {
  default     = ["anywhere"]
  description = "A list of CIDR blocks to which ssh access to the bastion host must be restricted. *anywhere* is equivalent to 0.0.0.0/0 and allows ssh access from anywhere."
  type        = list(string)
}

variable "bastion_image_id" {
  default     = "Autonomous"
  description = "The image id to use for bastion."
  type        = string
}

variable "bastion_os_version" {
  description = "In case Autonomous Linux is used, allow specification of Autonomous version"
  default     = "7.9"
  type        = string
}

variable "bastion_user" {
  default     = "opc"
  description = "User for SSH access through bastion host."
  type        = string
}

variable "bastion_shape" {
  default = {
    shape            = "VM.Standard.E4.Flex",
    ocpus            = 1,
    memory           = 4,
    boot_volume_size = 50
  }
  description = "The shape of bastion instance."
  type        = map(any)
}

variable "bastion_state" {
  description = "The target state for the bastion instance. Could be set to RUNNING or STOPPED. (Updatable)"
  default     = "RUNNING"
  type        = string
  validation {
    condition     = contains(["RUNNING", "STOPPED"], var.bastion_state)
    error_message = "Accepted values are RUNNING or STOPPED."
  }
}

variable "bastion_timezone" {
  default     = "Etc/UTC"
  description = "The preferred timezone for the bastion host."
  type        = string
}

variable "bastion_type" {
  description = "Whether to make the bastion host public or private."
  default     = "public"
  type        = string

  validation {
    condition     = contains(["public", "private"], var.bastion_type)
    error_message = "Accepted values are public or private."
  }
}

variable "upgrade_bastion" {
  default     = true
  description = "Whether to upgrade the bastion host packages after provisioning. it’s useful to set this to false during development so the bastion is provisioned faster."
  type        = bool
}

## bastion notification parameters
variable "enable_bastion_notification" {
  default     = false
  description = "Whether to enable notification on the bastion host."
  type        = bool
}

variable "bastion_notification_endpoint" {
  default     = "none"
  description = "The subscription notification endpoint for the bastion. The email address to be notified."
  type        = string
}

variable "bastion_notification_protocol" {
  default     = "EMAIL"
  description = "The notification protocol used."
  type        = string
}

variable "bastion_notification_topic" {
  default     = "bastion"
  description = "The name of the notification topic."
  type        = string
}

# bastion service parameters
variable "create_bastion_service" {
  default     = false
  description = "Whether to create a bastion service that allows access to private hosts."
  type        = bool
}

variable "bastion_service_access" {
  default     = ["0.0.0.0/0"]
  description = "A list of CIDR blocks to which ssh access to the bastion service must be restricted. *anywhere* is equivalent to 0.0.0.0/0 and allows ssh access from anywhere."
  type        = list(string)
}

variable "bastion_service_name" {
  default     = ""
  description = "The name of the bastion service."
  type        = string
}

variable "bastion_service_target_subnet" {
  default     = "operator"
  description = "The name of the subnet that the bastion service can connect to."
  type        = string
}
