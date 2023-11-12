variable "accepter_region" {
  type        = string
  description = "Region for accepter's VPC"
  default     = ""
}

variable "accepter_allow_remote_vpc_dns_resolution" {
  type        = bool
  default     = true
  description = "Allow accepter VPC to resolve public DNS hostnames to private IP addresses when queried from instances in the requester VPC"
}

variable "accepter_security_group_name" {
  type        = string
  default     = "Internal-Peering"
  description = <<DOC
  The name of the security group in the accepter VPC to allow traffic from the requester VPC
  The security group should already exist in the accepter VPC
  DOC
}

variable "accepter_cidr_block" {
  type        = string
  description = "cidr block for accepter's VPC"
  default     = ""
}

variable "accepter_route_table_tags" {
  type        = map(string)
  description = "Only add peer routes to accepter VPC route tables matching these tags"
  default     = {}
}

variable "accepter_owner_id" {
  type        = string
  description = "accepter account ID"
  default     = ""
}

variable "accepter_vpc_id" {
  type        = string
  description = "accepter VPC ID"
  default     = ""
}

variable "auto_accept" {
  type        = bool
  default     = true
  description = "Automatically accept the peering (both VPCs need to be in the same AWS account)"
}

variable "create" {
  type        = bool
  description = "A boolean value to control creation of VPC peering connection"
  default     = true
}

variable "create_timeout" {
  type        = string
  description = "VPC peering connection create timeout. For more details, see https://www.terraform.io/docs/configuration/resources.html#operation-timeouts"
  default     = "30m"
}

variable "delete_timeout" {
  type        = string
  description = "VPC peering connection delete timeout. For more details, see https://www.terraform.io/docs/configuration/resources.html#operation-timeouts"
  default     = "5m"
}

variable "manage_local_security_group_rule" {
  type        = bool
  description = "Define whether or not to inject the required security group rule into the local Phoenix security group. If not then this rule should be added in the calling module directly to the Phoenix SG"
}

variable "name" {
  type        = string
  description = "Name of the peering connection"
}

variable "requested_vpc_peering_connection_id" {
  type        = string
  description = "The ID of the requested VPC peering connection which is pending accceptance"
  default     = ""
}

variable "requester_vpc_id" {
  description = "requester VPC ID"
  default     = ""
}

variable "requester_route_table_tags" {
  type        = map(string)
  description = "Only add peer routes to requester VPC route tables matching these tags"
  default     = {}
}

variable "requester_cidr_block" {
  description = "The CIDR block of the requester that will be used in accepter"
  default     = ""
}

variable "requester_security_group_name" {
  type        = string
  default     = "Internal-Peering"
  description = <<DOC
  The name of the security group in the requester VPC to allow traffic from the accepter VPC
  The security group should already exist in the requester VPC
  DOC
}

variable "peering_accepter" {
  type        = bool
  description = "Whether or not to accept peering connection requested from remote account"
  default     = false
}

variable "peering_connection_id" {
  type        = string
  description = "ID of the VPC Peering connection to accept. Only in-use for peering_accepters."
  default     = null
}

variable "requester_allow_remote_vpc_dns_resolution" {
  type        = bool
  default     = true
  description = "Allow requester VPC to resolve public DNS hostnames to private IP addresses when queried from instances in the accepter VPC"
}

variable "tags" {
  type        = map(string)
  description = "A map of tags to assign to the VPC peering connection"
  default     = {}
}

variable "update_timeout" {
  type        = string
  description = "VPC peering connection update timeout. For more details, see https://www.terraform.io/docs/configuration/resources.html#operation-timeouts"
  default     = "30m"
}
