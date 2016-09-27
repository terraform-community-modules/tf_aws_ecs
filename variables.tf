variable "ami" {
  description           = "ECS AWS AMI Id, if you change, make sure it is compatible with instance type, not all AMIs allow all instance types "
    default = {
        us-east-1      = "ami-03562b14"
        us-west-2      = "ami-492ffd29"
        eu-west-1      = "ami-206e2140"
        eu-central-1   = "ami-b847b5d7"
        ap-northeast-1 = "ami-f2fc2d93"
        ap-southeast-1 = "ami-0b568c68"
        ap-southeast-2 = "ami-809faee3"
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
  description = "The AWS Subnet ID in which you want to delpoy your instances"
}
variable "vpc_id" {
  description = "The AWS VPC ID which you want to deploy your instances"
}
