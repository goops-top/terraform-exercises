# secret use env
provider "tencentcloud" {}

module "vpc" {
  source = "terraform-tencentcloud-modules/vpc/tencentcloud"

  vpc_name = "CloudNativeOps"
  vpc_cidr = "10.0.0.0/16"

  subnet_name  = "subnet-1"
  subnet_cidrs = ["10.0.0.0/24"]
  

  destination_cidrs = ["1.0.1.0/24"]
  next_type         = ["EIP"]
  next_hub          = ["0"]

  tags = {
    module = "vpc"
  }

  vpc_tags = {
    owner = "GoOps"
  }

  subnet_tags = {
    test = "subnet"
  }
}
