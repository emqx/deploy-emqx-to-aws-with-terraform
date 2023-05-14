<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | ~> 1.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 3.27 |
| <a name="requirement_random"></a> [random](#requirement\_random) | >= 2.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_http"></a> [http](#provider\_http) | 3.3.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_elb"></a> [elb](#module\_elb) | ../../modules/elb | n/a |
| <a name="module_elb_subnet"></a> [elb\_subnet](#module\_elb\_subnet) | ../../modules/subnet | n/a |
| <a name="module_emqx4_cluster"></a> [emqx4\_cluster](#module\_emqx4\_cluster) | ../../modules/emqx4_cluster | n/a |
| <a name="module_emqx5_cluster"></a> [emqx5\_cluster](#module\_emqx5\_cluster) | ../../modules/emqx5_cluster | n/a |
| <a name="module_emqx_security_group"></a> [emqx\_security\_group](#module\_emqx\_security\_group) | ../../modules/security_group | n/a |
| <a name="module_emqx_subnet"></a> [emqx\_subnet](#module\_emqx\_subnet) | ../../modules/subnet | n/a |
| <a name="module_vpc"></a> [vpc](#module\_vpc) | ../../modules/vpc | n/a |

## Resources

| Name | Type |
|------|------|
| [http_http.workstation-external-ip](https://registry.terraform.io/providers/hashicorp/http/latest/docs/data-sources/http) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_access_key"></a> [access\_key](#input\_access\_key) | AWS access key | `string` | `""` | no |
| <a name="input_associate_public_ip_address"></a> [associate\_public\_ip\_address](#input\_associate\_public\_ip\_address) | Whether to associate a public IP address with an instance in a VPC | `bool` | `true` | no |
| <a name="input_base_cidr_block"></a> [base\_cidr\_block](#input\_base\_cidr\_block) | base cidr block | `string` | `""` | no |
| <a name="input_certificate_arn"></a> [certificate\_arn](#input\_certificate\_arn) | the arn of the certificate | `string` | `""` | no |
| <a name="input_egress_with_cidr_blocks"></a> [egress\_with\_cidr\_blocks](#input\_egress\_with\_cidr\_blocks) | egress with cidr blocks | `list(any)` | <pre>[<br>  {<br>    "cidr_blocks": "0.0.0.0/0",<br>    "description": "all",<br>    "from_port": 0,<br>    "protocol": "-1",<br>    "to_port": 0<br>  }<br>]</pre> | no |
| <a name="input_elb_namespace"></a> [elb\_namespace](#input\_elb\_namespace) | elb namespace | `string` | `""` | no |
| <a name="input_elb_zone"></a> [elb\_zone](#input\_elb\_zone) | Map of AZ to a number that should be used for elb subnets | `map(number)` | `{}` | no |
| <a name="input_emqx4_package"></a> [emqx4\_package](#input\_emqx4\_package) | (Required) The install package of emqx4 | `string` | `""` | no |
| <a name="input_emqx5_core_count"></a> [emqx5\_core\_count](#input\_emqx5\_core\_count) | (Required) The count of emqx core node | `number` | `1` | no |
| <a name="input_emqx5_package"></a> [emqx5\_package](#input\_emqx5\_package) | (Required) The install package of emqx5 | `string` | `""` | no |
| <a name="input_emqx_cookie"></a> [emqx\_cookie](#input\_emqx\_cookie) | (Optional) The cookie of emqx | `string` | `"emqx_secret_cookie"` | no |
| <a name="input_emqx_ingress_with_cidr_blocks"></a> [emqx\_ingress\_with\_cidr\_blocks](#input\_emqx\_ingress\_with\_cidr\_blocks) | ingress of emqx with cidr blocks | `list(any)` | <pre>[<br>  {<br>    "cidr_blocks": "0.0.0.0/0",<br>    "description": "ssh",<br>    "from_port": 22,<br>    "protocol": "tcp",<br>    "to_port": 22<br>  },<br>  {<br>    "cidr_blocks": "0.0.0.0/0",<br>    "description": "mqtt",<br>    "from_port": 1883,<br>    "protocol": "tcp",<br>    "to_port": 1883<br>  },<br>  {<br>    "cidr_blocks": "0.0.0.0/0",<br>    "description": "mqtts",<br>    "from_port": 8883,<br>    "protocol": "tcp",<br>    "to_port": 8883<br>  },<br>  {<br>    "cidr_blocks": "0.0.0.0/0",<br>    "description": "ws",<br>    "from_port": 8083,<br>    "protocol": "tcp",<br>    "to_port": 8083<br>  },<br>  {<br>    "cidr_blocks": "0.0.0.0/0",<br>    "description": "wss",<br>    "from_port": 8084,<br>    "protocol": "tcp",<br>    "to_port": 8084<br>  },<br>  {<br>    "cidr_blocks": "0.0.0.0/0",<br>    "description": "dashboard",<br>    "from_port": 18083,<br>    "protocol": "tcp",<br>    "to_port": 18083<br>  },<br>  {<br>    "cidr_blocks": "0.0.0.0/0",<br>    "description": "cluster ekka",<br>    "from_port": 4370,<br>    "protocol": "tcp",<br>    "to_port": 4370<br>  },<br>  {<br>    "cidr_blocks": "0.0.0.0/0",<br>    "description": "cluster rpc",<br>    "from_port": 5370,<br>    "protocol": "tcp",<br>    "to_port": 5370<br>  }<br>]</pre> | no |
| <a name="input_emqx_instance_count"></a> [emqx\_instance\_count](#input\_emqx\_instance\_count) | the count of the emqx instance | `number` | `3` | no |
| <a name="input_emqx_instance_type"></a> [emqx\_instance\_type](#input\_emqx\_instance\_type) | the type of the emqx instance | `string` | `"t3.small"` | no |
| <a name="input_emqx_lic"></a> [emqx\_lic](#input\_emqx\_lic) | the content of the license | `string` | `""` | no |
| <a name="input_emqx_namespace"></a> [emqx\_namespace](#input\_emqx\_namespace) | emqx namespace | `string` | `""` | no |
| <a name="input_emqx_zone"></a> [emqx\_zone](#input\_emqx\_zone) | Map of AZ to a number that should be used for emqx subnets | `map(number)` | `{}` | no |
| <a name="input_forwarding_config"></a> [forwarding\_config](#input\_forwarding\_config) | forwarding config of nlb | `map(any)` | <pre>{<br>  "18083": {<br>    "description": "dashboard",<br>    "dest_port": 18083,<br>    "protocol": "TCP"<br>  },<br>  "1883": {<br>    "description": "mqtt",<br>    "dest_port": 1883,<br>    "protocol": "TCP"<br>  },<br>  "8083": {<br>    "description": "ws",<br>    "dest_port": 8083,<br>    "protocol": "TCP"<br>  }<br>}</pre> | no |
| <a name="input_forwarding_config_ssl"></a> [forwarding\_config\_ssl](#input\_forwarding\_config\_ssl) | forwarding ssl config of nlb | `map(any)` | <pre>{<br>  "8084": {<br>    "description": "wss",<br>    "dest_port": 8083,<br>    "protocol": "TLS"<br>  },<br>  "8883": {<br>    "description": "mqtts",<br>    "dest_port": 1883,<br>    "protocol": "TLS"<br>  }<br>}</pre> | no |
| <a name="input_is_emqx5"></a> [is\_emqx5](#input\_is\_emqx5) | (Optional) Is emqx5 or not | `bool` | `false` | no |
| <a name="input_region"></a> [region](#input\_region) | aws region | `string` | `""` | no |
| <a name="input_secret_key"></a> [secret\_key](#input\_secret\_key) | AWS secret key | `string` | `""` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_emqx_cluster_address"></a> [emqx\_cluster\_address](#output\_emqx\_cluster\_address) | dns name of the elb |
<!-- END_TF_DOCS -->