
## Install terraform
> Please refer to [terraform install doc](https://learn.hashicorp.com/tutorials/terraform/install-cli)


## AWS AccessKey Pair
```bash
export AWS_ACCESS_KEY_ID="anaccesskey"
export AWS_SECRET_ACCESS_KEY="asecretkey"
```

## Deploy EMQ X single node
```bash
cd services/emqx
terraform init
terraform plan
terraform apply -auto-approve
```


## Deploy EMQ X cluster(only support 2 node)
```bash
cd services/emqx_cluster
terraform init
terraform plan
terraform apply -auto-approve
```

## Destroy
```bash
terraform destroy -auto-approve
```

## Version
- os
> ubuntu 20.04

- emqx
> emqx open source 4.3.8

## Config variables(optional)
- emqx_instance_type
> default is 2C2G `t3.small`

- region
> default is `us-east-1`
