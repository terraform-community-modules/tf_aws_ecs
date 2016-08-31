ecs terraform module
===========

A terraform module to provide ECS clusters in AWS.


Module Input Variables
----------------------
#### Required
- `name` - ECS cluster name
- `key_name`
- `key_path`
- `subnet_id`
- `vpc_id`

#### Optional
- `region` - AWS Region - defaults to us-east-1
- `servers`  - Number of ECS Servers to start in the cluster - defaults to 2
- `instance_type` - AWS instance type - defaults to t2.micro

Usage
-----

```hcl
module "ecs-cluster" {
  source       = "github.com/tfhartmann/tf_aws_ecs"
  cluster_name = "infra-services"
  servers      = 1
  subnet_id    = "subnet-6e101446"
  vpc_id       = "vpc-99e73dfc"
}

```

Outputs
=======

 - `cluster_id` - ECS Cluster id for use in ECS task and service definitions

Authors
=======

[Tim Hartmann](https://github.com/tfhartmann)

License
=======
