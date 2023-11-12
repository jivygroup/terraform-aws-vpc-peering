
output "vpc_peering_id" {
  value = values(module.vpc_peering_request)[*].peering_id
}

output "requester_cidr" {
  value = values(module.vpc_peering_request)[*].requester_cidr
}

output "vpc_id" {
  value = try(module.vpc.vpc_id, "")
}