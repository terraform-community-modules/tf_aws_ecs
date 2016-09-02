/*
resource "aws_instance" "server" {
    ami                  = "${lookup(var.ami, "${var.region}")}"
    instance_type        = "${var.instance_type}"
    key_name             = "${var.key_name}"
    count                = "${var.servers}"
    vpc_security_group_ids = ["${aws_security_group.ecs.id}"]
    subnet_id            = "${var.subnet_id}"
    #iam_instance_profile = "AmazonECSContainerInstanceRole"
    iam_instance_profile = "${aws_iam_instance_profile.ecs_profile.name}"
    depends_on           = ["aws_iam_instance_profile.ecs_profile", "aws_security_group.ecs"]
    user_data = <<EOF
#!/bin/bash
echo ECS_CLUSTER=${aws_ecs_cluster.cluster.name} >> /etc/ecs/ecs.config
EOF
    connection {
        user = "${lookup(var.user, var.platform)}"
        key_file = "${var.key_path}"
    }

    #Instance tags
    tags {
        Name = "${var.name} ${var.tagName}-${count.index}"
    }
}
*/

resource "aws_launch_configuration" "ecs" {
  name                 = "ecs-${var.name}"
  image_id             = "${lookup(var.ami, var.region)}"
  instance_type        = "${var.instance_type}"
  key_name             = "${var.key_name}"
  iam_instance_profile = "${aws_iam_instance_profile.ecs_profile.name}"
  security_groups      = ["${aws_security_group.ecs.id}"]
  user_data = <<EOF
#!/bin/bash
echo ECS_CLUSTER=${aws_ecs_cluster.cluster.name} >> /etc/ecs/ecs.config
EOF
}

resource "aws_autoscaling_group" "ecs" {
  name                 = "ecs-asg-${var.name}"
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
