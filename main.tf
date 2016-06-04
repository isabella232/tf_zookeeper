module "aws_asg_zookeeper" {
  source                = "github.com/cihangir/terraform-aws//asg"
  name                  = "${var.name}-zookeeper"
  aws_subnet_subnet_ids = "${var.aws_subnet_subnet_ids}"
  key_name              = "${var.aws_key_name}"
  instance_type         = "${var.aws_instance_type}"
  ami_id                = "${var.ami_id}"
  desired_cluster_size  = "${var.desired_cluster_size}"

  rendered_cloud_init = "${template_file.zookeeper_cloud_init_file.rendered}"
  security_groups     = "${var.aws_sec_group_ids}"
}