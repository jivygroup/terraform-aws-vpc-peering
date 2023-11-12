locals {
  peering_connection_id = try(aws_vpc_peering_connection.this[0].id, var.peering_connection_id)
}