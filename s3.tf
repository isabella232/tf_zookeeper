# CREATE THE BUCKET
resource "aws_s3_bucket" "exhibitor_bucket" {
    bucket = "${var.s3_bucket_name}"
    acl = "private"
    force_destroy = true
}

resource "aws_iam_user" "user_for_bucket" {
    name = "user_exhibitor"
    path = "/"
}

resource "aws_iam_policy" "bucket_policy" {
    name = "policy_exhibitor_${var.s3_bucket_name}_bucket"
    path = "/"
    description = "Policy for exhibitor configuration sharing under ${var.s3_bucket_name} bucket"
    policy = "${data.template_file.bucket_policy_json.rendered}"
}

resource "aws_iam_policy_attachment" "attach" {
    name = "attachment_for_user_exhibitor"
    users = ["${aws_iam_user.user_for_bucket.name}"]
    policy_arn = "${aws_iam_policy.bucket_policy.arn}"
}

resource "aws_iam_access_key" "access_key_for_exhibitor" {
    user = "${aws_iam_user.user_for_bucket.name}"
}

data "template_file" "bucket_policy_json" {
  template = "${file("data/bucket_policy.json.tpl")}"

  vars = {
    BUCKET_NAME = "${var.s3_bucket_name}"
  }
}
