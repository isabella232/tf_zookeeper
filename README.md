# tf_zookeeper
Zookeeper Terraform Template


zookeeper cli /usr/lib/zookeeper/bin/zkCli.sh

config path /etc/zookeeper/conf/zoo.cfg


for more info on installation see: https://open.mesosphere.com/advanced-course/installing-zookeeper/

if one of the instances fail, terminate it and run `terraform apply` again.

TODO
use fine grained security groups
https://github.com/terraform-community-modules/tf_aws_sg/tree/master/sg_zookeeper
