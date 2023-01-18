# Copyright (c) 2017, 2023 Oracle Corporation and/or its affiliates.
# Licensed under the Universal Permissive License v 1.0 as shown at https://oss.oracle.com/licenses/upl

variable "create_vcn" {
  type        = bool
  description = "Whether to create a Virtual Cloud Network."
  default     = true
}

variable "vcn_display_name" {
  type        = string
  description = "Existing VCN name where the resources will be created"
  default     = ""
}

variable "vcn_id" {
  type        = string
  description = "Existing VCN id where the resources will be created"
  default     = ""
}

variable "ig_route_table_display_name" {
  type        = string
  description = "Existing Internet Gateway route table name"
  default     = ""
}

variable "ig_route_id" {
  type        = string
  description = "Existing Internet Gateway Route table id"
  default     = ""
}

variable "nat_route_table_display_name" {
  type        = string
  description = "Existing NAT Gateway route table name"
  default     = ""
}

variable "nat_route_id" {
  type        = string
  description = "Existing NAT Gateway Route table id"
  default     = ""
}

variable "create_drg" {
  description = "whether to create Dynamic Routing Gateway. If set to true, creates a Dynamic Routing Gateway and attach it to the VCN."
  type        = bool
  default     = false
}

variable "drg_display_name" {
  description = "(Updatable) Name of Dynamic Routing Gateway. Does not have to be unique."
  type        = string
  default     = "drg"
}

variable "drg_id" {
  description = "ID of an external created Dynamic Routing Gateway to be attached to the VCN"
  type        = string
  default     = null
}

variable "internet_gateway_route_rules" {
  description = "(Updatable) List of routing rules to add to Internet Gateway Route Table"
  type        = list(map(string))
  default     = null
}

variable "local_peering_gateways" {
  description = "Map of Local Peering Gateways to attach to the VCN."
  type        = map(any)
  default     = null
}

variable "lockdown_default_seclist" {
  description = "whether to remove all default security rules from the VCN Default Security List"
  default     = true
  type        = bool
}

variable "nat_gateway_route_rules" {
  description = "(Updatable) List of routing rules to add to NAT Gateway Route Table"
  type        = list(map(string))
  default     = null
}

variable "nat_gateway_public_ip_id" {
  description = "OCID of reserved IP address for NAT gateway. The reserved public IP address needs to be manually created."
  default     = "none"
  type        = string
}

variable "subnets" {
  description = "parameters to cidrsubnet function to calculate subnet masks within the VCN."
  default = {
    bastion  = { netnum = 0, newbits = 13 }
    operator = { netnum = 1, newbits = 13 }
    cp       = { netnum = 2, newbits = 13 }
    int_lb   = { netnum = 16, newbits = 11 }
    pub_lb   = { netnum = 17, newbits = 11 }
    workers  = { netnum = 1, newbits = 2 }
    pods     = { netnum = 2, newbits = 2 }
    fss      = { netnum = 18, newbits = 11 }
  }
  type = any
}

variable "vcn_cidrs" {
  default     = ["10.0.0.0/16"]
  description = "The list of IPv4 CIDR blocks the VCN will use."
  type        = list(string)
}

variable "vcn_dns_label" {
  default     = "oke"
  description = "A DNS label for the VCN, used in conjunction with the VNIC's hostname and subnet's DNS label to form a fully qualified domain name (FQDN) for each VNIC within this subnet. DNS resolution of hostnames in the VCN is disabled when null."
  type        = string
}

variable "assign_dns" {
  default     = true
  description = "Whether to assign DNS records to created instances"
  type        = bool
}

variable "vcn_name" {
  default     = "oke-vcn"
  description = "name of vcn"
  type        = string
}

variable "allow_node_port_access" {
  default     = false
  description = "Whether to allow access to NodePorts when worker nodes are deployed in public mode."
  type        = bool
}

variable "allow_worker_internet_access" {
  default     = true
  description = "Allow worker nodes to egress to internet. Required if container images are in a registry other than OCIR."
  type        = bool
}

variable "allow_pod_internet_access" {
  default     = true
  description = "Allow pods to egress to internet. Required if the pods are invoking Internet services."
  type        = bool
}

variable "allow_worker_ssh_access" {
  default     = false
  description = "Whether to allow ssh access to worker nodes."
  type        = bool
}

variable "control_plane_allowed_cidrs" {
  default     = []
  description = "The list of CIDR blocks from which the control plane can be accessed."
  type        = list(string)
}

variable "pods_cidr" {
  default     = "10.244.0.0/16"
  description = "The CIDR range used for IP addresses by the pods. A /16 CIDR is generally sufficient. This CIDR should not overlap with any subnet range in the VCN (it can also be outside the VCN CIDR range)."
  type        = string
}

variable "services_cidr" {
  default     = "10.96.0.0/16"
  description = "The CIDR range used by exposed Kubernetes services (ClusterIPs). This CIDR should not overlap with the VCN CIDR range."
  type        = string
}

variable "internal_lb_allowed_cidrs" {
  default     = ["0.0.0.0/0"]
  description = "The list of CIDR blocks from which the internal load balancer can be accessed."
  type        = list(string)

  validation {
    condition     = length(var.internal_lb_allowed_cidrs) > 0
    error_message = "At least 1 CIDR block is required."
  }
}

variable "internal_lb_allowed_ports" {
  default     = [80, 443]
  description = "List of allowed ports for internal load balancers."
  type        = list(any)

  validation {
    condition     = length(var.internal_lb_allowed_ports) > 0
    error_message = "At least 1 port is required."
  }
}

variable "public_lb_allowed_cidrs" {
  default     = ["0.0.0.0/0"]
  description = "The list of CIDR blocks from which the public load balancer can be accessed."
  type        = list(string)

  validation {
    condition     = length(var.public_lb_allowed_cidrs) > 0
    error_message = "At least 1 CIDR block is required."
  }
}

variable "public_lb_allowed_ports" {
  default     = [443]
  description = "List of allowed ports for public load balancers."
  type        = list(any)

  validation {
    condition     = length(var.public_lb_allowed_ports) > 0
    error_message = "At least 1 port is required."
  }
}

variable "enable_waf" {
  description = "Whether to enable WAF monitoring of load balancers"
  type        = bool
  default     = false
}
