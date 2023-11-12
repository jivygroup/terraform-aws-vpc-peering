# TODO : fix the output
output "peering_id" {
  value       = try(aws_vpc_peering_connection.this[0].id, "")
  description = "ID of the peering connection"
}

output "requester_cidr" {
  value       = try(data.aws_vpc.requester[0].cidr_block, "")
  description = "CIRD of the peering connection"
}