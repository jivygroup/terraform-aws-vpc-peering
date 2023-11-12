data "aws_vpc" "requester" {
  count = var.create == true && var.peering_accepter == false ? 1 : 0
  id    = var.requester_vpc_id
}

data "aws_route_tables" "requester" {
  count  = var.create == true && var.peering_accepter == false ? 1 : 0
  vpc_id = data.aws_vpc.requester[0].id
  tags   = var.requester_route_table_tags
}

data "aws_security_group" "requester" {
  count  = alltrue([var.create, var.manage_local_security_group_rule]) ? 1 : 0
  vpc_id = data.aws_vpc.requester[0].id
  filter {
    name   = "group-name"
    values = [var.requester_security_group_name]
  }
}

resource "aws_vpc_peering_connection" "this" {
  count = var.create == true && var.peering_accepter == false ? 1 : 0

  peer_owner_id = var.accepter_owner_id
  peer_vpc_id   = var.accepter_vpc_id
  vpc_id        = var.requester_vpc_id
  peer_region   = var.accepter_owner_id != "" && var.accepter_region != "" ? var.accepter_region : null

  auto_accept = alltrue([var.accepter_owner_id != "", var.auto_accept])

  dynamic "requester" {
    for_each = var.requester_allow_remote_vpc_dns_resolution == true ? [var.requester_allow_remote_vpc_dns_resolution] : []
    content {
      allow_remote_vpc_dns_resolution = requester.value
    }
  }

  tags = merge(var.tags, {
    Name = var.name
  })

  timeouts {
    create = var.create_timeout
    update = var.update_timeout
    delete = var.delete_timeout
  }
}

resource "aws_route" "requester" {
  for_each = var.create == true && var.peering_accepter == false ? toset(data.aws_route_tables.requester[0].ids) : toset([])

  route_table_id            = each.key
  destination_cidr_block    = var.accepter_cidr_block == "" ? data.aws_vpc.accepter[0].cidr_block : var.accepter_cidr_block
  vpc_peering_connection_id = aws_vpc_peering_connection.this[0].id

  depends_on = [
    data.aws_route_tables.requester,
    aws_vpc_peering_connection.this
  ]
}

resource "aws_security_group_rule" "requester" {
  count             = alltrue([var.create, var.manage_local_security_group_rule]) ? 1 : 0
  type              = "ingress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = var.accepter_cidr_block == "" ? [data.aws_vpc.accepter[0].cidr_block] : [var.accepter_cidr_block]
  security_group_id = data.aws_security_group.requester[0].id
}