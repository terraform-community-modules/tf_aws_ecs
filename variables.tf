variable "ami" {
  default = ""
}

variable "ami_version" {
  default = "*"
}

variable "name" {
  description = "AWS ECS Cluster Name"
}
variable "key_name" {
  description = "SSH key name in your AWS account for AWS instances."
    default   = "amazonhosts"
}

variable "key_path" {
  description  = "Path to the private key specified by key_name."
    default    = {
      key_path = "/Users/alaric/amazonhosts.pem"
    }
}

variable "region" {
  default     = "us-east-1"
  description = "The region of AWS, for AMI lookups."
}

variable "servers" {
  default     = "1"
  description = "The number of servers to launch."
}

variable "instance_type" {
  default     = "t2.micro"
  description = "AWS Instance type, if you change, make sure it is compatible with AMI, not all AMIs allow all instance types "
}

variable "tagName" {
  default     = "ECS Node"
  description = "Name tag for the servers"
}

variable "subnet_id" {
  type        = "list"
  description = "The AWS Subnet ID in which you want to delpoy your instances"
}

variable "allowed_cidr_blocks" {
  default     = ["0.0.0.0/0"]
  type        = "list"
  description = "List of subnets to allow into the ECS Security Group. Defaults to ['0.0.0.0/0']"
}
variable "vpc_id" {
  description = "The AWS VPC ID which you want to deploy your instances"
}
variable "docker_storage_size" {
  default     = "22"
  description = "EBS Volume size in Gib that the ECS Instance uses for Docker images and metadata "
}

variable "dockerhub_email" {
  default     = ""
  description = "Email Address used to authenticate to dockerhub. http://docs.aws.amazon.com/AmazonECS/latest/developerguide/private-auth.html"
}

variable "dockerhub_token" {
  default     = ""
  description = "Auth Token used for dockerhub. http://docs.aws.amazon.com/AmazonECS/latest/developerguide/private-auth.html"
}
