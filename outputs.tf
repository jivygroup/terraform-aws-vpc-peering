output "accept_status" {
  value       = coalesce(try(aws_vpc_peering_connection.requester[0].accept_status, null), try(aws_vpc_peering_connection_accepter.accepter[0].accept_status, null))
  description = "Requester VPC peering connection request status"
}

output "accepter_subnet_route_table_map" {
  value       = local.accepter_aws_rt_map
  description = "Map of accepter VPC subnet IDs to route table IDs"
}

output "peering_connection_id" {
  value       = coalesce(try(aws_vpc_peering_connection.requester[0].id, null), try(aws_vpc_peering_connection_accepter.accepter[0].id, null))
  description = "ID of the peering connection"
}

output "requester_cidr" {
  value       = try(data.aws_vpc.requester[0].cidr_block, "")
  description = "CIRD of the peering connection"
}