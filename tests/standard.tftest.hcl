variables {
  region = ""

  tags = {
    managedBy   = "terraform"
    CostGroup   = "Phoenix"
    Environment = "OM2-PhoenixIntegrations"
    repo        = "terraform-aws-vpc-peering"
  }

  peering_requests = {
    octopus = {
      create      = true
      peer_vpc_id = ""
      peer_region = ""
      account_id  = ""
      cidr_block  = "172.30.0.0/16"
    }
  }
}

terraform {
  required_version = "~>1.6.0"

  required_providers {

    aws = {
      source  = "hashicorp/aws"
      version = "5.4.0"
    }
  }
}

provider "aws" {
  region = local.region
  default_tags {
    tags = local.tags
  }
}

run "vpc_requester" {
  variables {
    az_primary            = "a"
    az_secondary          = "b"
    az_tertiary           = "c"
    az_primary_db_ro      = "a"
    az_secondary_db_ro    = "b"
    az_tertiary_db_ro     = "c"
    domain                = "om2.com"
    name                  = "om2-cloudamqp-module-vpc"
    public_hosted_zone_id = "Z166M0JOPOZR5U"
    cidr_prefix           = "10.250"
    additional_vpc_tags   = var.tags
  }

  module {
    source  = "app.terraform.io/OM2Phoenix/vpc/aws"
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
    name                  = "om2-cloudamqp-module-vpc"
    public_hosted_zone_id = "Z166M0JOPOZR5U"
    cidr_prefix           = "10.250"
    additional_vpc_tags   = var.tags
  }

  module {
    source  = "app.terraform.io/OM2Phoenix/vpc/aws"
    version = "0.2.0"
  }
}

run "auto_accept" {

  variables {}

  assert {
    condition     = length(regexall("testing", "testing")) > 0
    error_message = "Template test failed"
  }

}