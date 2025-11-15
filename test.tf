provider "aws" {
    region = "us-west-2"
  
}

resource "aws_instance" "my_first_ec2" {
    ami           = data.aws_ami.latest_amazon_linux.id # Amazon Linux 2 AMI
    instance_type = "t2.micro"
  
    tags = {
      Name = "MyFirstEC2Instance"
    }
  
}

data "aws_ami" "latest_amazon_linux" {
    most_recent = true
  
    filter {
      name   = "name"
      values = ["amzn2-ami-hvm-*-x86_64-gp2"]
    }
  
    filter {
      name   = "virtualization-type"
      values = ["hvm"]
    }
  
    owners = ["137112412989"] # Amazon
}

resource "aws_subnet" "sub1" {
    vpc_id            = "vpc-0bb1c79de3EXAMPLE" # Replace with your VPC ID
    cidr_block       = ""
    availability_zone = "us-west-2a"    
    tags =  {
      Name = "MySubnet"
    }

  
}   

module "MyFirstEC2Instance" {   
    source = "./test.tf"
  
}