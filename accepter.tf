data "aws_vpc" "accepter" {
  count = alltrue([var.create, var.accepter_owner_id == ""])
  id    = var.accepter_vpc_id
}

data "aws_route_tables" "accepter" {
  count  = alltrue([var.create, var.accepter_owner_id == ""])
  vpc_id = data.aws_vpc.accepter[0].id
  tags   = var.accepter_route_table_tags
}

data "aws_security_group" "accepter" {
  count  = alltrue([var.create, var.accepter_owner_id == ""])
  vpc_id = data.aws_vpc.accepter[0].id
  filter {
    name   = "group-name"
    values = [var.accepter_security_group_name]
  }
}

resource "aws_vpc_peering_connection_accepter" "accepter" {
  count                     = alltrue([var.create, var.peering_accepter]) ? 1 : 0
  vpc_peering_connection_id = local.peering_connection_id
  auto_accept               = true
}

resource "aws_vpc_peering_connection_options" "accepter" {
  count                     = alltrue([var.create, var.peering_accepter]) ? 1 : 0
  vpc_peering_connection_id = local.peering_connection_id

  accepter {
    allow_remote_vpc_dns_resolution = var.accepter_allow_remote_vpc_dns_resolution
  }

  depends_on = [
    aws_vpc_peering_connection_accepter.accepter
  ]
}

resource "aws_route" "accepter" {
  for_each = var.create == true && var.accepter_owner_id == "" ? toset(data.aws_route_tables.accepter[0].ids) : toset([])

  route_table_id            = each.key
  destination_cidr_block    = var.peering_accepter == true ? var.requester_cidr_block : data.aws_vpc.requester[0].cidr_block
  vpc_peering_connection_id = var.peering_accepter == true ? var.peering_connection_id : aws_vpc_peering_connection.this[0].id

  depends_on = [
    data.aws_route_tables.accepter,
    aws_vpc_peering_connection_accepter.accepter
  ]
}

resource "aws_security_group_rule" "accepter" {
  count             = alltrue([var.create, var.accepter_owner_id == ""])
  type              = "ingress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = var.peering_accepter == true ? [var.requester_cidr_block] : [data.aws_vpc.requester[0].cidr_block]
  security_group_id = data.aws_security_group.accepter[0].id
}
