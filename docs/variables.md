| name | description | type | default value |  |
| --- | --- | --- | --- | --- |
| region |  a physical location around the world where we cluster data centers | string | empty |  |
| access_key | long-term credentials for an IAM user or the AWS
 account root user | string | empty |  |
| secret_key | secrets, like your password | string | empty |  |
| emqx_namespace |  a kind of tags use to name different emqx resources | string | empty |  |
| elb_namespace |  a kind of tags use to name different emqx resources | string | empty |  |
| base_cidr_block | the base cidr block of the vpc | string | empty |  |
| emqx_ingress_with_cidr_blocks | the inbound rule of the security group | list(any) | emqx_ingress_with_cidr_blocks  |  |
| egress_with_cidr_blocks | the outbound rule of the security group | list(any) | egress_with_cidr_blocks |  |
| emqx_zone | Map of AZ to a number that should be used for emqx subnets.  | map(number) | {} |  |
| elb_zone | Map of AZ to a number that should be used for elb subnets. | map(number) | {} |  |
| associate_public_ip_address | Whether to associate a public IP address with an instance in a VPC | bool | true |  |
| emqx_package | emqx installation package | string | empty |  |
| ee_lic | the content of the license | string | empty |  |
| emqx_instance_count | the count of the emqx instance | number | 3 |  |
| emqx_instance_type | the type of the emqx instance | string | "t3.small” |  |
| certificate_arn | the arn of the server certificate | string | empty |  |
| forwarding_config | forwarding config of nlb | map(any) | forwarding_config |  |
| forwarding_config_ssl | forwarding ssl config of nlb | map(any) | forwarding_config_ssl |  |

emqx_ingress_with_cidr_blocks:

```yaml
default = [
    {
      description = "ssh"
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"
      cidr_blocks = "0.0.0.0/0"
    },
    {
      description = "mqtt"
      from_port   = 1883
      to_port     = 1883
      protocol    = "tcp"
      cidr_blocks = "0.0.0.0/0"
    },
    {
      description = "mqtts"
      from_port   = 8883
      to_port     = 8883
      protocol    = "tcp"
      cidr_blocks = "0.0.0.0/0"
    },
    {
      description = "ws"
      from_port   = 8083
      to_port     = 8083
      protocol    = "tcp"
      cidr_blocks = "0.0.0.0/0"
    },
    {
      description = "wss"
      from_port   = 8084
      to_port     = 8084
      protocol    = "tcp"
      cidr_blocks = "0.0.0.0/0"
    },
    {
      description = "dashboard"
      from_port   = 18083
      to_port     = 18083
      protocol    = "tcp"
      cidr_blocks = "0.0.0.0/0"
    },
    {
      description = "cluster ekka"
      from_port   = 4370
      to_port     = 4370
      protocol    = "tcp"
      cidr_blocks = "0.0.0.0/0"
    },
    {
      description = "cluster rpc"
      from_port   = 5370
      to_port     = 5370
      protocol    = "tcp"
      cidr_blocks = "0.0.0.0/0"
    }
 ]
```

egress_with_cidr_blocks:

```yaml
default = [
    {
      description = "all"
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      cidr_blocks = "0.0.0.0/0"
    }
  ]
```

forwarding_config:

```yaml
{
    "1883" = {
      dest_port   = 1883,
      protocol    = "TCP"
      description = "mqtt"
    },
    "8083" = {
      dest_port   = 8083,
      protocol    = "TCP"
      description = "ws"
    }
}
```

forwarding_config_ssl:

```yaml
{
    "8883" = {
      dest_port   = 1883,
      protocol    = "TLS"
      description = "mqtts"
    },
    "8084" = {
      dest_port   = 8083,
      protocol    = "TLS"
      description = "wss"
    },
    "18083" = {
      dest_port   = 18083,
      protocol    = "TCP"
      description = "dashboard"
    }
}
```
