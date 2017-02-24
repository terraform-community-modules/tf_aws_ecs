variable "ami" {
  description           = "ECS AWS AMI Id, if you change, make sure it is compatible with instance type, not all AMIs allow all instance types "
    default = {
        us-east-1      = "ami-b2df2ca4"
        us-east-2      = "ami-832b0ee6"
        us-west-1      = "ami-dd104dbd"
        us-west-2      = "ami-022b9262"
        eu-west-1      = "ami-a7f2acc1"
        eu-west-2      = "ami-3fb6bc5b"
        eu-central-1   = "ami-ec2be583"
        ap-northeast-1 = "ami-c393d6a4"
        ap-southeast-1 = "ami-a88530cb"
        ap-southeast-2 = "ami-8af8ffe9"
        ca-central-1   = "ami-ead5688e"
    }
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
variable "vpc_id" {
  description = "The AWS VPC ID which you want to deploy your instances"
}
variable "docker_storage_size" {
  default     = "22"
  description = "EBS Volume size in Gib that the ECS Instance uses for Docker images and metadata "
}
