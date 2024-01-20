data "aws_ami" "latest_amazon_linux"{
    most_recent = true
    owners = ["137112412989"]
    filter {
    name   = "name"
    values = ["al2023-ami-2023.3.20231218.0-kernel-6.1-x86_64"]
  }

}

data "aws_vpcs" "default_vpc" {
}
 
