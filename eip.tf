resource "aws_eip" "zookeeper" {
  vpc   = true
  count = "${var.instance_count}"
}