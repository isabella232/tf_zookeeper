variable "name" {
  default = "zookeeper_cluster"
}

variable "aws_subnet_subnet_ids" {}

variable "aws_key_name" {}

variable "aws_instance_type" {
  default = "t2.micro"
}

variable "ami_id" {
  description = "aws-elasticbeanstalk-amzn-2016.03.0.x86_64-php56-hvm-201603311549"
  default     = "ami-b04842da"
}

variable "desired_cluster_size" {}

variable "aws_sec_group_ids" {}

variable "instance_count" {
  default = 3
}

variable "vpc_security_group_ids" {}