terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
    }
  }
  required_version = ">= 1.2.0"
  backend "s3" {
    bucket         = "idoterraformido"
    key            = "terraformactions.tfstate"
    region         = "ap-northeast-1"
  }
}
variable "sg" {
  type = map(object({
    port = number
    cidr = list(string)
    description = string
  }))
  
  default = {
    "ssh" = {
     	port = 22
    	cidr = ["0.0.0.0/0"]
    	description = "ssh yeah"
    },
    "http" = {
     	port = 80
    	cidr = ["0.0.0.0/0"]
    	description = "http yeah"
    },
    "https" = {
     	port = 443
    	cidr = ["0.0.0.0/0"]
    	description = "https yeah"
    }
  }
}
resource "aws_security_group" "the_sg" {
  name        = "the new sg"
  description = "Security Group for life!"

  dynamic "ingress" {
    for_each = var.sg

    content {
      from_port   = ingress.value.port
      to_port     = ingress.value.port
      protocol    = "tcp"
      cidr_blocks = ingress.value.cidr
      description = ingress.value.description
    }
  }
  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }
}
data "aws_ami" "ubuntu" {
    most_recent = true
    filter {
        name   = "name"
        values = ["ubuntu/images/hvm-ssd/*20.04-amd64-server-*"]
    }
    filter {
        name   = "virtualization-type"
        values = ["hvm"]
    }
    owners = ["099720109477"] # Canonical
}
# provision to us-east-2 region
provider "aws" {
  region  = "ap-northeast-1"
}
resource "aws_instance" "app_server" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = "t2.micro"
  key_name      = "keys"
  vpc_security_group_ids =[aws_security_group.the_sg.id]
  tags = {
    Name = "actions"
  }
  user_data = <<EOF
#!/bin/bash
sudo apt update -y
sudo -y install docker.io
sudo docker run -d idoca/actions:latest
EOF
}
