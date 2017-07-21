data "template_file" "user_data" {
  template = "${file("${path.module}/templates/user_data.tpl")}"

  vars {
    cluster_name        = "${aws_ecs_cluster.cluster.name}"
    docker_storage_size = "${var.docker_storage_size}"
    dockerhub_token     = "${var.dockerhub_token}"
    dockerhub_email     = "${var.dockerhub_email}"
  }
}
