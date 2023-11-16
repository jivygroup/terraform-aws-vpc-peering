variables {
  region                = "eu-west-1"
  az_primary            = "a"
  az_secondary          = "b"
  az_tertiary           = "c"
  az_primary_db_ro      = "a"
  az_secondary_db_ro    = "b"
  az_tertiary_db_ro     = "c"
  domain                = "om2.com"
  public_hosted_zone_id = "Z166M0JOPOZR5U"
}

provider "aws" {
  region = "eu-west-1"
  default_tags {
    tags = {
      managedBy   = "terraform"
      CostGroup   = "Phoenix"
      Environment = "OM2-PhoenixIntegrations"
      repo        = "terraform-aws-vpc-peering"
    }
  }
}


run "vpc_requester" {
  variables {
    name        = "terraform-awsvpcpeering-requester"
    cidr_prefix = "10.245"
  }

  module {
    source  = "app.terraform.io/OM2Phoenix/vpc/aws"
    version = "0.2.0"
  }
}

run "vpc_accepter" {
  variables {
    name        = "terraform-awsvpcpeering-accepter"
    cidr_prefix = "10.250"
  }

  module {
    source  = "app.terraform.io/OM2Phoenix/vpc/aws"
    version = "0.2.0"
  }
}

run "request" {

  variables {
    accepter_allow_remote_vpc_dns_resolution  = true
    accepter_cidr_block                       = run.vpc_accepter.cidr_block
    accepter_enabled                          = true
    accepter_vpc_id                           = run.vpc_accepter.id
    auto_accept                               = false
    create                                    = true
    open_local_security_group_rule            = true
    name                                      = "terraform-awsvpcpeering-test"
    requester_allow_remote_vpc_dns_resolution = true
    requester_cidr_block                      = run.vpc_requester.cidr_block
    requester_enabled                         = true
    requester_vpc_id                          = run.vpc_requester.id
  }

  assert {
    condition     = can(outputs.peering_connection_id)
    error_message = "Peering connection not created successfully. Missing connection ID"
  }

  assert {
    condition     = outputs.accept_status == "active"
    error_message = "Peering connection statuys not active."
  }
}