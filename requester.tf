

# Lookup requester VPC so that we can reference the CIDR
data "aws_vpc" "requester" {
  count = local.requester_count
  id    = var.requester_vpc_id
  tags  = var.requester_vpc_tags
}

# Lookup requester subnets
data "aws_subnets" "requester" {
  count = local.requester_count
  filter {
    name   = "vpc-id"
    values = [local.requester_vpc_id]
  }
  tags = var.requester_subnet_tags
}

data "aws_route_tables" "requester" {
  count  = local.requester_count
  vpc_id = data.aws_vpc.requester[0].id
  tags   = var.requester_route_table_tags
}

# If we had more subnets than routetables, we should update the default.
data "aws_route_tables" "requester_default_rts" {
  count    = local.requester_count
  vpc_id   = local.requester_vpc_id
  filter {
    name   = "association.main"
    values = ["true"]
  }
}

data "aws_security_group" "requester" {
  count  = local.requester_count
  vpc_id = data.aws_vpc.requester[0].id
  filter {
    name   = "group-name"
    values = [var.requester_security_group_name]
  }
}

locals {

  #Todo take care of routing tables like in accepter
  requester_subnet_ids       = try(distinct(sort(flatten(data.aws_subnets.requester[*].ids))), [])
  requester_subnet_ids_count = length(local.requester_subnet_ids)
  requester_vpc_id           = join("", data.aws_vpc.requester[*].id)
}

# Lookup requester route tables
data "aws_route_table" "requester" {
  count     = local.requester_enabled ? local.requester_subnet_ids_count : 0
  subnet_id = element(local.requester_subnet_ids, count.index)
}

resource "aws_vpc_peering_connection" "requester" {
  count         = local.requester_count
  vpc_id        = local.requester_vpc_id
  peer_vpc_id   = local.accepter_vpc_id
  peer_owner_id = local.accepter_account_id
  peer_region   = local.accepter_region
  auto_accept   = false

  tags = merge(var.tags, {
    Name = var.name
  })

  timeouts {
    create = var.create_timeout
    update = var.update_timeout
    delete = var.delete_timeout
  }
}


resource "aws_vpc_peering_connection_options" "requester" {
  # Only provision the options if the accepter side of the peering connection is enabled
  count = local.accepter_count

  # As options can't be set until the connection has been accepted
  # create an explicit dependency on the accepter.
  vpc_peering_connection_id = local.active_vpc_peering_connection_id

  requester {
    allow_remote_vpc_dns_resolution = var.requester_allow_remote_vpc_dns_resolution
  }
}

locals {
  requester_aws_route_table_ids           = try(distinct(sort(data.aws_route_table.requester[*].route_table_id)), [])
  requester_aws_route_table_ids_count     = length(local.requester_aws_route_table_ids)
  requester_cidr_block_associations       = flatten(data.aws_vpc.requester[*].cidr_block_associations)
  requester_cidr_block_associations_count = length(local.requester_cidr_block_associations)
}

# Create routes from requester to accepter
resource "aws_route" "requester" {
  count                     = local.requester_enabled ? local.requester_aws_route_table_ids_count * local.accepter_cidr_block_associations_count : 0
  route_table_id            = local.requester_aws_route_table_ids[floor(count.index / local.accepter_cidr_block_associations_count)]
  destination_cidr_block    = local.accepter_cidr_block_associations[count.index % local.accepter_cidr_block_associations_count]["cidr_block"]
  vpc_peering_connection_id = join("", aws_vpc_peering_connection.requester[*].id)
  depends_on = [
    data.aws_route_table.requester,
    aws_vpc_peering_connection.requester,
    aws_vpc_peering_connection_accepter.accepter
  ]

  timeouts {
    create = var.aws_route_create_timeout
    delete = var.aws_route_delete_timeout
  }
}


resource "aws_security_group_rule" "requester" {
  count             = alltrue([var.create, var.open_local_security_group_rule]) ? 1 : 0
  type              = "ingress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = var.accepter_cidr_block == "" ? [data.aws_vpc.accepter[0].cidr_block] : [var.accepter_cidr_block]
  security_group_id = data.aws_security_group.requester[0].id
}
