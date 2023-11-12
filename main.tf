locals {
  requester_enabled = var.create && var.requester_enabled
  requester_count   = var.create && var.requester_enabled ? 1 : 0
  accepter_enabled = var.create && var.accepter_enabled
  accepter_count   = var.create && var.accepter_enabled ? 1 : 0

  requested_vpc_peering_connection_id = (
    local.accepter_enabled 
    ? try(
      var.peering_connection_id_to_accept,
      join("", aws_vpc_peering_connection.requester[*].id)
    ) 
    : null
  )

  active_vpc_peering_connection_id = local.accepter_enabled ? join("", aws_vpc_peering_connection_accepter.accepter[*].id) : null
}
