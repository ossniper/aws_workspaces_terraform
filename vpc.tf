# Create a VPC module 
module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = "vpc-workspace"
  cidr = "192.168.0.0/22"

 
  azs             = ["us-east-1c"]
  private_subnets = ["192.168.0.64/27"]
  public_subnets  = ["192.168.1.32/28"]

  enable_nat_gateway = false
  single_nat_gateway = true
  one_nat_gateway_per_az = false

  enable_vpn_gateway = false

  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Environment = "IT"
    Name = "awsworkspace_vpc"
  }
}

