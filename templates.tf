resource "template_file" "zookeeper_cloud_init_file" {
  template = "${file("cloud_init/zookeeper.yaml")}"
  count    = "${length(split(",", var.private_ips))}"

  vars = {
    self_private_ip = "${element(split(",", var.private_ips), count.index)}"
    private_ips     = "${var.private_ips}"
    region          = "${var.region}"
  }
}
