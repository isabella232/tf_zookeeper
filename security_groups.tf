resource "aws_security_group" "elb" {
  name        = "${var.aws_security_group_prefix}${var.env_name}-elb"
  description = "ELB Security Group for ${var.env_name}"
  vpc_id      = "${var.vpc_id}"

  tags {
    Name = "${var.aws_security_group_prefix}${var.env_name}-elb"
  }
}

resource "aws_security_group" "eb" {
  name        = "${var.aws_security_group_prefix}${var.env_name}-eb"
  description = "EB Security Group for ${var.env_name}"
  vpc_id      = "${var.vpc_id}"

  tags {
    Name = "${var.aws_security_group_prefix}${var.env_name}-eb"
  }
}

# EB security group config

# Allow all incoming communication within the cluster
resource "aws_security_group_rule" "eb_ingress_allow_all_within_cluster" {
  type                     = "ingress"
  from_port                = 0
  to_port                  = 0
  protocol                 = "-1"
  source_security_group_id = "${aws_security_group.eb.id}"
  security_group_id        = "${aws_security_group.eb.id}"
}

# Allow incoming communication from ELB at port 2181
resource "aws_security_group_rule" "eb_ingress_allow_from_elb_2181" {
  type                     = "ingress"
  from_port                = 2181
  to_port                  = 2181
  protocol                 = "TCP"
  source_security_group_id = "${aws_security_group.elb.id}"
  security_group_id        = "${aws_security_group.eb.id}"
}

# Allow incoming communication from ELB at port 2888
resource "aws_security_group_rule" "eb_ingress_allow_from_elb_2888" {
  type                     = "ingress"
  from_port                = 2888
  to_port                  = 2888
  protocol                 = "TCP"
  source_security_group_id = "${aws_security_group.elb.id}"
  security_group_id        = "${aws_security_group.eb.id}"
}

# Allow incoming communication from ELB at port 3888
resource "aws_security_group_rule" "eb_ingress_allow_from_elb_3888" {
  type                     = "ingress"
  from_port                = 3888
  to_port                  = 3888
  protocol                 = "TCP"
  source_security_group_id = "${aws_security_group.elb.id}"
  security_group_id        = "${aws_security_group.eb.id}"
}

# Allow incoming communication from ELB at port 8181
resource "aws_security_group_rule" "eb_ingress_allow_from_elb_8181" {
  type                     = "ingress"
  from_port                = 8181
  to_port                  = 8181
  protocol                 = "TCP"
  source_security_group_id = "${aws_security_group.elb.id}"
  security_group_id        = "${aws_security_group.eb.id}"
}

# Allow all outgoing communication from the cluster
resource "aws_security_group_rule" "eb_allow_all_egress" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = "${aws_security_group.eb.id}"
}

# ELB security group config

# # Allow on port 80
# resource "aws_security_group_rule" "elb_ingress_allow_80" {
#   type              = "ingress"
#   from_port         = 80
#   to_port           = 80
#   protocol          = "TCP"
#   source_security_group_id = "${aws_security_group.eb.id}"
#   security_group_id = "${aws_security_group.elb.id}"
# }
#
# resource "aws_security_group_rule" "elb_ingress_allow_443" {
#   type              = "ingress"
#   from_port         = 443
#   to_port           = 443
#   protocol          = "TCP"
#   cidr_blocks       = ["0.0.0.0/0"]
#   security_group_id = "${aws_security_group.elb.id}"
# }
#
# resource "aws_security_group_rule" "elb_allow_all_egress" {
#   type              = "egress"
#   from_port         = 78
#   to_port           = 80
#   protocol          = "TCP"
#   cidr_blocks       = ["0.0.0.0/0"]
#   security_group_id = "${aws_security_group.elb.id}"
# }
