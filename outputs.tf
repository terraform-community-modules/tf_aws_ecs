output "cluster_id" {
  value = "${aws_ecs_cluster.cluster.id}"
}

output "cluster_name" {
  value = "${aws_ecs_cluster.cluster.name}"
}

output "autoscaling_group" {
  value = {
    id   = "${aws_autoscaling_group.ecs.id}"
    name = "${aws_autoscaling_group.ecs.name}"
    arn  = "${aws_autoscaling_group.ecs.arn}"
  }
}
output "iam_role" {
  value = {
    name = "${aws_iam_role.ecs_role.name}"
    arn = "${aws_iam_role.ecs_role.arn}"
  }
}
