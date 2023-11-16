output "accept_status" {
  value       = try(coalesce(aws_vpc_peering_connection.requester[*].accept_statusaws_vpc_peering_connection_accepter.accepter[*].accept_status), "")
  description = "Requester VPC peering connection request status"
}

output "accepter_subnet_route_table_map" {
  value       = local.accepter_aws_rt_map
  description = "Map of accepter VPC subnet IDs to route table IDs"
}

output "peering_connection_id" {
  value       = try(coalesce(aws_vpc_peering_connection.requester[0].id, aws_vpc_peering_connection_accepter.accepter[*].id), "")
  description = "ID of the peering connection"
}

output "requester_cidr" {
  value       = try(data.aws_vpc.requester[0].cidr_block, "")
  description = "CIRD of the peering connection"
}