variable "key_pair_name" {
  default = "key-koding-eb-deployment-dev"
}

variable "s3_bucket_name" {
  default = "kodingdev-exhibitor"
}

variable "ami_id" {
  default = "ami-5b35104c"
}

variable "vpc_id" {
  default = "vpc-54a53133"
}

variable "vpc_subnets" {
  default = "subnet-2a2e1b00,subnet-f4dbefac"
}

variable "elb_subnet_ids" {
  default = "subnet-2a2e1b00,subnet-f4dbefac"
}

variable "env_name" {
  default = "koding-zookeeper"
}

variable "env_cname" {
  default = "koding-zookeeper"
}

variable "app_name" {
  default = "koding"
}

variable "solution_stack_name" {
  default = "64bit Amazon Linux 2016.09 v2.2.0 running PHP 5.6"
}

variable "instance_type" {
  default = "c3.2xlarge"
}

variable "iaminstanceprofile" {
  default = "aws-elasticbeanstalk-ec2-role"
}

variable "healthCheckEndpoint" {
  default = "HTTP:8181/exhibitor/v1/cluster/status"
}

variable "deployment_type" {
  description = "Choose a deployment policy for application version deployments. (AllAtOnce, Rolling, RollingWithAdditionalBatch, Immutable)"
  default     = "Rolling"
}

variable "deployment_command_timeout" {
  description = "Number of seconds to wait for an instance to complete executing commands. (1 to 3600)"
  default     = "600"
}

variable "deployment_batch_size_type" {
  description = "The type of number that is specified in BatchSize. (Percentage, Fixed)"
  default     = "Fixed"
}

variable "deployment_batch_size" {
  description = " Percentage or fixed number of Amazon EC2 instances in the Auto Scaling group on which to simultaneously perform deployments. Valid values vary per BatchSizeType setting. (1 to 100 (Percentage). 1 to aws:autoscaling:asg::MaxSize (Fixed))"
  default     = "1"
}

variable "service_role_name" {
  description = "The name of an IAM role that Elastic Beanstalk uses to manage resources for the environment."
  default     = "aws-elasticbeanstalk-service-role"
}

variable "aws_security_group_prefix" {
  default = "sec-group-"
}
