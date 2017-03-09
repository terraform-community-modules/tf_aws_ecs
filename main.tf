resource "aws_launch_configuration" "ecs" {
  #name                 = "ecs-${var.name}"
  name_prefix          = "ecs-${var.name}-"
  image_id             = "${lookup(var.ami, var.region)}"
  instance_type        = "${var.instance_type}"
  key_name             = "${var.key_name}"
  iam_instance_profile = "${aws_iam_instance_profile.ecs_profile.name}"
  security_groups      = ["${aws_security_group.ecs.id}"]
  ebs_block_device {
    device_name = "/dev/xvdcz"
    volume_size = "${var.docker_storage_size}"
    volume_type = "gp2"
    delete_on_termination = true
  }
  user_data = <<EOF
#!/bin/bash
echo ECS_CLUSTER=${aws_ecs_cluster.cluster.name} >> /etc/ecs/ecs.config
echo ECS_ENGINE_AUTH_TYPE=dockercfg >> /etc/ecs/ecs.config
echo 'ECS_ENGINE_AUTH_DATA={"https://index.docker.io/v1/": { "auth": "${var.dockerhub_token}", "email": "${var.dockerhub_email}"}}' >> /etc/ecs/ecs.config
EOF
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "ecs" {
  #name                 = "ecs-asg-${var.name}"
  name                 = "asg-${aws_launch_configuration.ecs.name}"
  vpc_zone_identifier  = ["${var.subnet_id}"]
  launch_configuration = "${aws_launch_configuration.ecs.name}"
  min_size             = 1
  max_size             = 10
  desired_capacity     = "${var.servers}"
  tag {
    key = "Name"
    value = "${var.name} ${var.tagName}"
    propagate_at_launch = true
  }
  lifecycle {
    create_before_destroy = true
  }
}



resource "aws_security_group" "ecs" {
  name        = "ecs-sg-${var.name}"
  description = "Container Instance Allowed Ports"
  vpc_id      = "${var.vpc_id}"
  ingress {
    from_port   = 0
    to_port     = 65535
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags {
    Name = "ecs-sg-${var.name}"
  }
}

# Make this a var that an get passed in?
resource "aws_ecs_cluster" "cluster" {
  name = "${var.name}"
}
