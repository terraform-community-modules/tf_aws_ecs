ecs terraform module
===========

A terraform module to provide ECS clusters in AWS.

[![CircleCI](https://circleci.com/gh/terraform-community-modules/tf_aws_ecs.svg?style=svg)](https://circleci.com/gh/terraform-community-modules/tf_aws_ecs)


This Module currently supports Terraform 0.10.x, but does not require it. If you use tfenv, this module contains a `.terraform-version` file which matches the version of Terraform we currently use to test with.


Module Input Variables
----------------------
#### Required
- `name` - ECS cluster name
- `key_name` - An EC2 key pair name
- `subnet_id` - A list of subnet IDs
- `vpc_id` - The VPC ID to place the cluster in

#### Optional

**NOTE About User Data:** The `user_data` parameter overwrites the `user_data` template used by this module, this will break some of the module features (e.g. `docker_storage_size`, `dockerhub_token`, and `dockerhub_email`). However, `additional_user_data_script` will concatenate additional data to the end of the current `user_data` script. It is recomended that you use `additional_user_data_script`. These two parameters are mutually exclusive - you can not pass both into this module and expect it to work.

- `additional_user_data_script` - Additional `user_data` scripts content
- `region` - AWS Region - defaults to us-east-1
- `servers`  - Number of ECS Servers to start in the cluster - defaults to 1
- `min_servers`  - Minimum number of ECS Servers to start in the cluster - defaults to 1
- `max_servers`  - Maximum number of ECS Servers to start in the cluster - defaults to 10
- `load_balancers` - A list of elastic load balancer names to add to the autoscaling group names. - defaults to []
- `instance_type` - AWS instance type - defaults to t2.micro
- `iam_path` - IAM path, this is useful when creating resources with the same name across multiple regions. Defaults to /
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
- `allowed_cidr_blocks` - List of subnets to allow into the ECS Security Group. Defaults to `["0.0.0.0/0"]`.
- `ami` - A specific AMI image to use, eg `ami-95f8d2f3`. Defaults to the latest ECS optimized Amazon Linux AMI.
- `ami_version` - Specific version of the Amazon ECS AMI to use (e.g. `2016.09`). Defaults to `*`. Ignored if `ami` is specified.
- `heartbeat_timeout` - Heartbeat Timeout setting for how long it takes for the graceful shutodwn hook takes to timeout. This is useful when deploying clustered applications like consul that benifit from having a deploy between autoscaling create/destroy actions. Defaults to 180"
- `security_group_ids` - a list of security group IDs to apply to the launch configuration
- `user_data` - The instance user data (e.g. a `cloud-init` config) to use in the `aws_launch_configuration`

- `consul_image` - Image to use when deploying consul, defaults to the hashicorp consul image
- `registrator_image` - Image to use when deploying registrator agent, defaults to the gliderlabs registrator:latest
- `enable_agents` - Enable Consul Agent and Registrator tasks on each ECS Instance. Defaults to false

Usage
-----

```hcl
module "ecs-cluster" {
  source    = "github.com/terraform-community-modules/tf_aws_ecs"
  name      = "infra-services"
  servers   = 1
  subnet_id = ["subnet-6e101446"]
  vpc_id    = "vpc-99e73dfc"
}

```

#### Example cluster with consul and Registrator

In order to start the Consul/Registrator task in ECS, you'll need to pass in a consul config into the `additional_user_data_script` script parameter.  For example, you might pass something like this:

Please note, this module will try to mount `/etc/consul/` into `/consul/config` in the container and assumes that the consul config lives under `/etc/consul` on the docker host.

```Shell
/bin/mkdir -p /etc/consul
cat <<"CONSUL" > /etc/consul/config.json
{
	"raft_protocol": 3,
	"log_level": "INFO",
	"enable_script_checks": true,
  "datacenter": "${datacenter}",
	"retry_join_ec2": {
		"tag_key": "consul_server",
		"tag_value": "true"
	}
}
CONSUL
```


```hcl

data "template_file" "ecs_consul_agent_json" {
  template = "${file("ecs_consul_agent.json.sh")}"

  vars {
    datacenter = "infra-services"
  }
}

module "ecs-cluster" {
  source                      = "github.com/terraform-community-modules/tf_aws_ecs"
  name                        = "infra-services"
  servers                     = 1
  subnet_id                   = ["subnet-6e101446"]
  vpc_id                      = "vpc-99e73dfc"
  additional_user_data_script = "${data.template_file.ecs_consul_agent_json.rendered}"
  enable_agents               = true
}


```


Outputs
=======

- `cluster_id` - _(String)_ ECS Cluster id for use in ECS task and service definitions.
- `autoscaling_group` _(Map)_ A map with keys `id`, `name`, and `arn` of the `aws_autoscaling_group` created.

Authors
=======

* [Tim Hartmann](https://github.com/tfhartmann)
* [Joe Stump](https://github.com/joestump)

License
=======

[MIT](LICENSE)
