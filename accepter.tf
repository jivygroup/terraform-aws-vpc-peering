resource "random_string" "test" {
  length = 10
}

# Lookup accepter's VPC so that we can reference the CIDR
data "aws_vpc" "accepter" {
  count = local.accepter_count
  id    = var.accepter_vpc_id
  tags  = var.accepter_vpc_tags
}

# Lookup accepter subnets
data "aws_subnets" "accepter" {
  count = local.accepter_count
  filter {
    name   = "vpc-id"
    values = [local.accepter_vpc_id]
  }
  tags = var.accepter_subnet_tags
}

locals {
  accepter_subnet_ids = local.accepter_enabled ? data.aws_subnets.accepter[0].ids : []
  accepter_vpc_id     = join("", data.aws_vpc.accepter[*].id)
}

data "aws_route_tables" "accepter" {
  for_each = toset(local.accepter_subnet_ids)
  vpc_id   = local.accepter_vpc_id
  filter {
    name   = "association.subnet-id"
    values = [each.key]
  }
}

# If we had more subnets than routetables, we should update the default.
data "aws_route_tables" "accepter_default_rts" {
  count  = local.accepter_count
  vpc_id = local.accepter_vpc_id
  filter {
    name   = "association.main"
    values = ["true"]
  }
}

data "aws_security_group" "accepter" {
  count  = local.accepter_count
  vpc_id = data.aws_vpc.accepter[0].id
  filter {
    name   = "group-name"
    values = [var.accepter_security_group_name]
  }
}

locals {
  #todo: like here
  accepter_aws_default_rt_id             = join("", flatten(data.aws_route_tables.accepter_default_rts[*].ids))
  accepter_aws_rt_map                    = { for s in local.accepter_subnet_ids : s => try(data.aws_route_tables.accepter[s].ids[0], local.accepter_aws_default_rt_id) }
  accepter_aws_route_table_ids           = distinct(sort(values(local.accepter_aws_rt_map)))
  accepter_aws_route_table_ids_count     = length(local.accepter_aws_route_table_ids)
  accepter_cidr_block_associations       = flatten(data.aws_vpc.accepter[*].cidr_block_associations)
  accepter_cidr_block_associations_count = length(local.accepter_cidr_block_associations)
}

# Accepter's side of the connection.
resource "aws_vpc_peering_connection_accepter" "accepter" {
  count                     = local.accepter_count
  vpc_peering_connection_id = local.requested_vpc_peering_connection_id
  auto_accept               = var.auto_accept
  tags                      = var.tags
}

resource "aws_vpc_peering_connection_options" "accepter" {
  count                     = local.accepter_count
  vpc_peering_connection_id = local.active_vpc_peering_connection_id

  accepter {
    allow_remote_vpc_dns_resolution = var.accepter_allow_remote_vpc_dns_resolution
  }
}

# Create routes from accepter to requester
resource "aws_route" "accepter" {
  count                     = local.accepter_enabled ? local.accepter_aws_route_table_ids_count * local.requester_cidr_block_associations_count : 0
  route_table_id            = local.accepter_aws_route_table_ids[floor(count.index / local.requester_cidr_block_associations_count)]
  destination_cidr_block    = local.requester_cidr_block_associations[count.index % local.requester_cidr_block_associations_count]["cidr_block"]
  vpc_peering_connection_id = local.active_vpc_peering_connection_id
  depends_on = [
    data.aws_route_tables.accepter,
    aws_vpc_peering_connection_accepter.accepter,
    aws_vpc_peering_connection.requester, # may conflict, may not exist in accepter only workspaces
  ]

  timeouts {
    create = var.aws_route_create_timeout
    delete = var.aws_route_delete_timeout
  }
}


resource "aws_security_group_rule" "accepter" {
  count             = local.accepter_count
  type              = "ingress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = var.accepter_cidr_block == "" ? [data.aws_vpc.accepter[0].cidr_block] : [var.accepter_cidr_block]
  security_group_id = data.aws_security_group.accepter[0].id
}
