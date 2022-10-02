
data "tencentcloud_image" "ubuntu" {
  image_name_regex = "Ubuntu Server 20.04 LTS 64bit" # 操作系统镜像名

  filter {
    name   = "image-type"
    values = ["PUBLIC_IMAGE"]
  }
}


// Create a instance
resource "tencentcloud_instance" "CloudNativeOps" {
    instance_name = "CloudNativeOps"
    availability_zone = "ap-beijing-6"
    image_id = "img-eb30mz89"
    instance_type = "S6.MEDIUM4"
    # 高性能云硬盘 
    system_disk_type = "CLOUD_PREMIUM"
    system_disk_size = 50
    allocate_public_ip         = true # 是否分配公网 IP
   internet_max_bandwidth_out = 10 # 公网流量带宽限制：100GB
   internet_charge_type       = "TRAFFIC_POSTPAID_BY_HOUR" # 公网流量计费模式：按使用流量


  
    security_groups = [
       "${tencentcloud_security_group.gogoops.id}" 
    ]

    vpc_id = "${tencentcloud_vpc.CloudNativeOps.id}"
    subnet_id = "${tencentcloud_subnet.subnet_6.id}"
    count = 1
    instance_charge_type                         = "PREPAID"
    instance_charge_type_prepaid_period = 1

    tags = {
      owner = "GoOps"
    }
}

