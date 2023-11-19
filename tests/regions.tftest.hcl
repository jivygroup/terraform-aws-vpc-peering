variables {
  requester_region = "eu-west-1"
  accepter_region  = "eu-west-2"
}

provider "aws" {
  alias  = "requester"
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

provider "aws" {
  alias  = "accepter"
  region = "eu-west-2"
  default_tags {
    tags = {
      managedBy   = "terraform"
      CostGroup   = "Phoenix"
      Environment = "OM2-PhoenixIntegrations"
      repo        = "terraform-aws-vpc-peering"
    }
  }
}

/*
run "vpc_requester" {
  variables {
    az_primary            = "a"
    az_secondary          = "b"
    az_tertiary           = "c"
    az_primary_db_ro      = "a"
    az_secondary_db_ro    = "b"
    az_tertiary_db_ro     = "c"
    domain                = "om2.com"
    name                  = "terraform-awsvpcpeering-requester"
    public_hosted_zone_id = "Z166M0JOPOZR5U"
    region                = var.requester_region
    cidr_prefix           = "10.245"
  }

  providers = {
    aws = aws.requester
  }

  module {
    source  = "app.terraform.io/TOMS/vpc/aws"
    version = "0.2.0"
  }
}

run "vpc_accepter" {
  variables {
    az_primary            = "a"
    az_secondary          = "b"
    az_tertiary           = "c"
    az_primary_db_ro      = "a"
    az_secondary_db_ro    = "b"
    az_tertiary_db_ro     = "c"
    domain                = "om2.com"
    name                  = "terraform-awsvpcpeering-accepter"
    public_hosted_zone_id = "Z166M0JOPOZR5U"
    region                = var.accepter_region
    cidr_prefix           = "10.250"
  }

  providers = {
    aws = aws.accepter
  }

  module {
    source  = "app.terraform.io/TOMS/vpc/aws"
    version = "0.2.0"
  }
}
*/

run "request" {

  variables {
    accepter_allow_remote_vpc_dns_resolution  = true
    #accepter_cidr_block                       = run.vpc_accepter.cidr_block
    accepter_cidr_block                       = "10.128.0.0/16"
    accepter_enabled                          = true
    accepter_region                           = "eu-west-2"
    #accepter_vpc_id                           = run.vpc_accepter.id
    accepter_vpc_id                           = "vpc-0e7f56e28e1e1882d"
    auto_accept                               = false
    create                                    = true
    open_local_security_group_rule            = true
    name                                      = "terraform-awsvpcpeering-test"
    requester_allow_remote_vpc_dns_resolution = true
    #requester_cidr_block                      = run.vpc_requester.cidr_block
    requester_cidr_block                      = "10.127.0.0/16"
    requester_enabled                         = true
    #requester_vpc_id                          = run.vpc_requester.id
    requester_vpc_id                          = "vpc-058cf57c3201ba659"
  }

  providers = {
    aws = aws.requester
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