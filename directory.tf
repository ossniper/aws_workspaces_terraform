
#Create a AWS managed Directory AD
resource "aws_directory_service_directory" "os-cloud-ad" {
  name     = "corp.osmancloud.net"
  description = "Os ManagedAD for Workspaces"
  password = "Osman@1234567"
  edition     = "Standard"
  type     = "MicrosoftAD"

  vpc_settings {
    vpc_id     = module.vpc.vpc_id
    subnet_ids = [aws_subnet.a.id, aws_subnet.b.id]

  }
}


resource "aws_subnet" "a" {
  vpc_id            = module.vpc.vpc_id
  availability_zone = "us-east-1a"
  cidr_block        = "192.168.0.0/27"
}

resource "aws_subnet" "b" {
  vpc_id            = module.vpc.vpc_id
  availability_zone = "us-east-1b"
  cidr_block        = "192.168.0.32/27"
}

#DHCP option set

resource "aws_vpc_dhcp_options" "dns_resolver" {
  domain_name_servers = aws_directory_service_directory.os-cloud-ad.dns_ip_addresses
  domain_name = "osmancloud.net"
  #ntp_servers = [""]
  tags = {
    Name = "dhcp-set"
    value = "osmancloud"
  }
}
resource "aws_vpc_dhcp_options_association" "dns_resolver" {
  vpc_id = module.vpc.vpc_id
  dhcp_options_id = aws_vpc_dhcp_options.dns_resolver.id
}