resource "aws_instance" "zookeeper" {
  count         = "${var.instance_count}"
  ami           = "${var.ami_id}"
  instance_type = "${var.aws_instance_type}"
  key_name      = "${var.aws_key_name}"

  # (Optional) A list of security group IDs to associate with.
  vpc_security_group_ids = ["${split(",", var.vpc_security_group_ids)}"]

  user_data = "${element(template_file.zookeeper_cloud_init_file.*.rendered, count.index)}"

  private_ip = "${element(aws_eip.zookeeper.*.private_ip, count.index)}"

  tags {
    Name = "${format("zookeeper-%03d", count.index + 1)}"
  }
}

# ebs_optimized - (Optional) If true, the launched EC2 instance will be EBS-optimized.


# subnet_id - (Optional) The VPC Subnet ID to launch in.


# associate_public_ip_address - (Optional) Associate a public ip address with an instance in a VPC. Boolean value.


# root_block_device - (Optional) Customize details about the root block device of the instance. See Block Devices below for details.


# ebs_block_device - (Optional) Additional EBS block devices to attach to the instance. See Block Devices below for details.


# ephemeral_block_device - (Optional) Customize Ephemeral (also known as "Instance Store") volumes on the instance. See Block Devices below for details.
