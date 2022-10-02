
// create a vpc 
resource "tencentcloud_vpc" "CloudNativeOps" {
        name = "CloudNativeOps"
        cidr_block = "10.0.0.0/16"
}

// Create a route table
resource "tencentcloud_route_table" "rtb_goops" {
    name = "rtb-goops"
    vpc_id = "${tencentcloud_vpc.CloudNativeOps.id}"
}

// create a subnet
resource "tencentcloud_subnet" "subnet_6" {
    name = "subnet-6"
    cidr_block = "10.0.64.0/18"
    availability_zone = "ap-beijing-6"
    vpc_id = "${tencentcloud_vpc.CloudNativeOps.id}"
    route_table_id = "${tencentcloud_route_table.rtb_goops.id}"
}


// Create a security group and rule
resource "tencentcloud_security_group" "gogoops" {
    name = "sg-test"    
}

resource "tencentcloud_security_group_rule" "sg_rule_test" {
    security_group_id = "${tencentcloud_security_group.gogoops.id}"
    type = "ingress"
    cidr_ip = "0.0.0.0/0"
    ip_protocol = "tcp"
    port_range = "22,80"
    policy = "accept"
}

