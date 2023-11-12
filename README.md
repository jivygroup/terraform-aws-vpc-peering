## terraform-aws-vpc-peering

A module allowing for easy request and acceptance of VPC peering connections between two VPCs.
VPCs may be in different accounts and/or different regions.
The requester should be configured and run first, followed by the accepter.
If both requester and accepter are in the same account then the connection can be auto-accepted.

## Usage

In order to use this in a single account it is enough to configure a single provider.
In this auto_accept can be set to true and the accepter will automatically accept the peering connection.

In order to configure a peering connection between separate accounts it is recommended to define the module twice, 
once for the requester and once for the accepter.
Each definition should be assigend a provider with the relvant permissions in the relevant accounts

This module can be used to create one-way peering connection requests which will only be accepted later
This will only require defining the requester. The accpeter will need to accept and configure the required
security posture on the other end.



<!-- BEGIN_TF_DOCS -->
## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_route.accepter](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route) | resource |
| [aws_route.requester](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route) | resource |
| [aws_security_group_rule.accepter](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.requester](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |
| [aws_vpc_peering_connection.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc_peering_connection) | resource |
| [aws_vpc_peering_connection_accepter.accepter](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc_peering_connection_accepter) | resource |
| [aws_vpc_peering_connection_options.accepter](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc_peering_connection_options) | resource |
| [aws_route_tables.accepter](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/route_tables) | data source |
| [aws_route_tables.requester](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/route_tables) | data source |
| [aws_security_group.accepter](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/security_group) | data source |
| [aws_security_group.requester](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/security_group) | data source |
| [aws_vpc.accepter](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/vpc) | data source |
| [aws_vpc.requester](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/vpc) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_accepter_allow_remote_vpc_dns_resolution"></a> [accepter\_allow\_remote\_vpc\_dns\_resolution](#input\_accepter\_allow\_remote\_vpc\_dns\_resolution) | Allow accepter VPC to resolve public DNS hostnames to private IP addresses when queried from instances in the requester VPC | `bool` | `true` | no |
| <a name="input_accepter_cidr_block"></a> [accepter\_cidr\_block](#input\_accepter\_cidr\_block) | cidr block for accepter's VPC | `string` | `""` | no |
| <a name="input_accepter_owner_id"></a> [accepter\_owner\_id](#input\_accepter\_owner\_id) | accepter account ID | `string` | `""` | no |
| <a name="input_accepter_region"></a> [accepter\_region](#input\_accepter\_region) | Region for accepter's VPC | `string` | `""` | no |
| <a name="input_accepter_route_table_tags"></a> [accepter\_route\_table\_tags](#input\_accepter\_route\_table\_tags) | Only add peer routes to accepter VPC route tables matching these tags | `map(string)` | `{}` | no |
| <a name="input_accepter_security_group_name"></a> [accepter\_security\_group\_name](#input\_accepter\_security\_group\_name) | The name of the security group in the accepter VPC to allow traffic from the requester VPC<br>  The security group should already exist in the accepter VPC | `string` | `"Internal-Peering"` | no |
| <a name="input_accepter_vpc_id"></a> [accepter\_vpc\_id](#input\_accepter\_vpc\_id) | accepter VPC ID | `string` | `""` | no |
| <a name="input_auto_accept"></a> [auto\_accept](#input\_auto\_accept) | Automatically accept the peering (both VPCs need to be in the same AWS account) | `bool` | `true` | no |
| <a name="input_create"></a> [create](#input\_create) | A boolean value to control creation of VPC peering connection | `bool` | `true` | no |
| <a name="input_create_timeout"></a> [create\_timeout](#input\_create\_timeout) | VPC peering connection create timeout. For more details, see https://www.terraform.io/docs/configuration/resources.html#operation-timeouts | `string` | `"30m"` | no |
| <a name="input_delete_timeout"></a> [delete\_timeout](#input\_delete\_timeout) | VPC peering connection delete timeout. For more details, see https://www.terraform.io/docs/configuration/resources.html#operation-timeouts | `string` | `"5m"` | no |
| <a name="input_manage_local_security_group_rule"></a> [manage\_local\_security\_group\_rule](#input\_manage\_local\_security\_group\_rule) | Define whether or not to inject the required security group rule into the local Phoenix security group. If not then this rule should be added in the calling module directly to the Phoenix SG | `bool` | n/a | yes |
| <a name="input_name"></a> [name](#input\_name) | Name of the peering connection | `string` | n/a | yes |
| <a name="input_peering_accepter"></a> [peering\_accepter](#input\_peering\_accepter) | Whether or not to accept peering connection requested from remote account | `bool` | `false` | no |
| <a name="input_peering_connection_id"></a> [peering\_connection\_id](#input\_peering\_connection\_id) | ID of the VPC Peering connection to accept. Only in-use for peering\_accepters. | `string` | `null` | no |
| <a name="input_requested_vpc_peering_connection_id"></a> [requested\_vpc\_peering\_connection\_id](#input\_requested\_vpc\_peering\_connection\_id) | The ID of the requested VPC peering connection which is pending accceptance | `string` | `""` | no |
| <a name="input_requester_allow_remote_vpc_dns_resolution"></a> [requester\_allow\_remote\_vpc\_dns\_resolution](#input\_requester\_allow\_remote\_vpc\_dns\_resolution) | Allow requester VPC to resolve public DNS hostnames to private IP addresses when queried from instances in the accepter VPC | `bool` | `true` | no |
| <a name="input_requester_cidr_block"></a> [requester\_cidr\_block](#input\_requester\_cidr\_block) | The CIDR block of the requester that will be used in accepter | `string` | `""` | no |
| <a name="input_requester_route_table_tags"></a> [requester\_route\_table\_tags](#input\_requester\_route\_table\_tags) | Only add peer routes to requester VPC route tables matching these tags | `map(string)` | `{}` | no |
| <a name="input_requester_security_group_name"></a> [requester\_security\_group\_name](#input\_requester\_security\_group\_name) | The name of the security group in the requester VPC to allow traffic from the accepter VPC<br>  The security group should already exist in the requester VPC | `string` | `"Internal-Peering"` | no |
| <a name="input_requester_vpc_id"></a> [requester\_vpc\_id](#input\_requester\_vpc\_id) | requester VPC ID | `string` | `""` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | A map of tags to assign to the VPC peering connection | `map(string)` | `{}` | no |
| <a name="input_update_timeout"></a> [update\_timeout](#input\_update\_timeout) | VPC peering connection update timeout. For more details, see https://www.terraform.io/docs/configuration/resources.html#operation-timeouts | `string` | `"30m"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_peering_id"></a> [peering\_id](#output\_peering\_id) | ID of the peering connection |
| <a name="output_requester_cidr"></a> [requester\_cidr](#output\_requester\_cidr) | CIRD of the peering connection |
<!-- END_TF_DOCS -->