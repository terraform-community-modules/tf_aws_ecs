ecs terraform module
===========

A terraform module to provide ECS clusters in AWS.


Module Input Variables
----------------------
#### Required
- `name` - ECS cluster name
- `key_name`
- `key_path`
- `subnet_id` - list of subnets
- `vpc_id`

#### Optional
- `region` - AWS Region - defaults to us-east-1
- `servers`  - Number of ECS Servers to start in the cluster - defaults to 2
- `instance_type` - AWS instance type - defaults to t2.micro
- `associate_public_ip_address` - assign a publicly-routable IP address to every instance in the cluster - default: `false`.
- `docker_storage_size` - EBS Volume size in Gib that the ECS Instance uses for Docker images and metadata - defaults to 22
- `dockerhub_email` - Email Address used to authenticate to dockerhub. http://docs.aws.amazon.com/AmazonECS/latest/developerguide/private-auth.html
- `dockerhub_token` - Auth Token used for dockerhub. http://docs.aws.amazon.com/AmazonECS/latest/developerguide/private-auth.html
- `extra_tags` - Additional tags to be added to the ECS autoscaling group. Must be in the form of an array of hashes. See https://www.terraform.io/docs/providers/aws/r/autoscaling_group.html for examples.
```
extra_tags = [
    {
      key                 = "consul_server"
      value               = "true"
      propagate_at_launch = true
    },
  ]
```
- `allowed_cidr_blocks` - List of subnets to allow into the ECS Security Group. Defaults to ["0.0.0.0/0"]
- `ami` - specific AMI image to use, eg `ami-95f8d2f3`.
- `ami_version` - specific version of the Amazon ECS AMI to use, eg `2016.09`
- `heartbeat_timeout` - Heartbeat Timeout setting for how long it takes for the graceful shutodwn hook takes to timeout. This is useful when deploying clustered applications like consul that benifit from having a deploy between autoscaling create/destroy actions. Defaults to 180"

Usage
-----

```hcl
module "ecs-cluster" {
  source       = "github.com/terraform-community-modules/tf_aws_ecs"
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
