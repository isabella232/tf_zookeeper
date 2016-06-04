variable "name" {
  default = "zookeeper_cluster"
}

variable "ebs_optimized" {
  default = false
}

variable "aws_key_name" {}

variable "aws_instance_type" {
  default = "t2.micro"
}

variable "ami_id" {
  description = "aws-elasticbeanstalk-amzn-2016.03.0.x86_64-php56-hvm-201603311549"
  default     = "ami-b04842da"
}

variable "private_ips" {
  default = "10.0.0.121,10.0.0.122,10.0.0.123"
}

variable "vpc_security_group_ids" {}