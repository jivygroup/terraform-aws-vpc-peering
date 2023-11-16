# cross-account-requester

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | 1.6.1 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | 5.4.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 5.4.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_vpc"></a> [vpc](#module\_vpc) | app.terraform.io/OM2/vpc/aws | 0.1.1 |
| <a name="module_vpc_peering_request"></a> [vpc\_peering\_request](#module\_vpc\_peering\_request) | ../../ | n/a |

## Resources

| Name | Type |
|------|------|
| [aws_security_group.peering](https://registry.terraform.io/providers/hashicorp/aws/5.4.0/docs/resources/security_group) | resource |

## Inputs

No inputs.

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_requester_cidr"></a> [requester\_cidr](#output\_requester\_cidr) | n/a |
| <a name="output_vpc_id"></a> [vpc\_id](#output\_vpc\_id) | n/a |
| <a name="output_vpc_peering_id"></a> [vpc\_peering\_id](#output\_vpc\_peering\_id) | n/a |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
