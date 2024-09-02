data "aws_ami" "ubuntu" {
    most_recent = true
    filter {
        name   = "name"
        values = ["ubuntu/images/hvm-ssd/*24.04-amd64-server-*"]
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
  tags = {
    Name = "actions"
  }
}
