#output "ecs_cluster" {
#  value = ["${aws_subnet.private.*.id}"]
#}

output "cluster_id" {
  value = "${aws_ecs_cluster.cluster.id}"
}
# ECS servers
