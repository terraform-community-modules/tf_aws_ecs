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
        Name = "${var.cluster_name} ${var.tagName}-${count.index}"
    }
}

resource "aws_security_group" "ecs" {
  name        = "ecs-sg"
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
    Name = "ecs-sg"
  }
}

# Make this a var that an get passed in?
resource "aws_ecs_cluster" "cluster" {
  name = "${var.cluster_name}"
}
