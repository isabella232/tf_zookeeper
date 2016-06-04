resource "template_file" "zookeeper_cloud_init_file" {
  template = "${file("cloud_init/zookeeper.yaml")}"

  vars = {
    REGION = "${var.region}"
  }
}
