output "cluster_id" {
  description = "ECS cluster ID"
  value       = "${aws_ecs_cluster.cluster.id}"
}

output "autoscaling_group" {
  description = "Map of ID, name, and ARN of Auto Scaling Group associated with ECS cluster"

  value = {
    id   = "${aws_autoscaling_group.ecs.id}"
    name = "${aws_autoscaling_group.ecs.name}"
    arn  = "${aws_autoscaling_group.ecs.arn}"
  }
}

output "security_groups" {
  description = "List of IDs of security groups applied to ECS cluster instances"
  value       = ["${aws_launch_configuration.ecs.security_groups}"]
}
