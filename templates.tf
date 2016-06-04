resource "template_file" "zookeeper_cloud_init_file" {
  template = "${file("cloud_init/zookeeper.yaml")}"
  count    = "${var.instance_count}"

  vars = {
    self_private_ip = "${element(aws_eip.zookeeper.*.private_ip, count.index)}"
    private_ips     = "${join(",", aws_eip.zookeeper.*.private_ip)}"
    region          = "${var.region}"
  }
}