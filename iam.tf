resource "aws_iam_instance_profile" "ecs_profile" {
    name = "ecs_test_profile"
    roles = ["${aws_iam_role.ecs-role.name}"]
}

resource "aws_iam_role" "ecs-role" {
    name               = "tf-created-AmazonECSContainerInstanceRole"

    assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
      "Service": ["ecs.amazonaws.com", "ec2.amazonaws.com"]

    },
    "Effect": "Allow",
    "Sid": ""
    }
  ]
}
EOF
}

resource "aws_iam_policy" "ecs-policy" {
    name        = "tf-created-AmazonECSContainerInstancePolicy"
    description = "A terraform created policy for ECS"
    policy      = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
          "ecs:CreateCluster",
          "ecs:RegisterContainerInstance",
          "ecs:DeregisterContainerInstance",
          "ecs:DiscoverPollEndpoint",
          "ecs:Submit*",
          "ecs:Poll"
        ],
        "Resource": [
          "*"
        ]
      }
  ]
}
EOF
}

resource "aws_iam_policy_attachment" "attach-ecs" {
  name       = "ecs-attachment"
  roles      = ["${aws_iam_role.ecs-role.name}"]
  policy_arn = "${aws_iam_policy.ecs-policy.arn}"
}
