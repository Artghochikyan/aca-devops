terraform {
  backend "s3" {
    bucket = "myartsbucketaws"
    key    = "state"
    region = "us-east-1"
  }
}


data "aws_ami" "al" {
  most_recent = true

  filter {
    name   = "name"
    values = ["al2023-ami-2023.1.20230912.0-kernel-6.1-x86_64"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["137112412989"] # Canonical
}
provider "aws" {
  region = "us-east-1"
}
resource "aws_eip" "my_static_ip" {
  instance = aws_instance.web.id

}

resource "aws_db_instance" "my_base" {
  allocated_storage    = 10
  storage_type         = "gp2"
  engine               = "mysql"
  engine_version       = "5.7"
  instance_class       = "db.t2.micro"
  db_name              = "db"
  username             = "user"
  password             = "userroot"
  parameter_group_name = "default.mysql5.7"
}

resource "aws_security_group" "ec2_sg" {
  name        = "ec2-security-group"
  description = "Security group for EC2 instance"
  vpc_id      = "vpc-020f81b49e586f534"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "rds_sg" {
  name        = "rds-security-group"
  description = "Security group for RDS instance"
  vpc_id      = "vpc-020f81b49e586f534"

  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_key_pair" "deployer" {
  key_name   = "deployer-key"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQCOM9gLXnL3DNTtue93srMsZXJYAj7UzSWVj+N2OgH3oOASS2prKX7uNizJcxqydmnx00R/OIHuKnglfgmydU+6ZTcxe0jJG5REQ9ANvJdNvTI04yu3TlbQI2TBJQFhXRXuGAcVpbEyVvR+cZM9RdFc23mYXxwamnhnWmBcJWGkPjQ8L/gMjtn0ZgkcfoPnTiCuZ4OF32nrNaviMeUlxn0t1Y3ePl3RVfcl7OxHIXDg3qQqtvzMbOM7VA8fZusDBETMOzt698O20LG7iEZguYAo7Cd4whstYdf5cKi9qmkpuIY4B9teCvJxIfolPrPYzJZw1gUxj6U9iGPnKPrPHzFueGLRt2KsZepg3pwvdcvBFLFCg6GsMCDFPUNbRMGXEZIUI1i7r8HeN3OTZ6uFb/SI1y/5MQXyBvh7fyofDMkEpDx6RpWgG1yxcDDJRZ3KK7MQPUGPbpm3KDu1zAzjPEIZLudvo1GMzBlwKZRyt/pr8g2BNLh0DGUC4/4YWFKvV40= art@art-virtual-machine"
}

resource "aws_instance" "web" {
  ami           = data.aws_ami.al.id
  instance_type = "t2.micro"

  key_name = aws_key_pair.deployer.key_name


  vpc_security_group_ids = [aws_security_group.allow_ssh_http.id]


}


resource "aws_security_group" "allow_ssh_http" {
  name        = "allow_ssh_http"
  description = "Allow inbound traffic"
  vpc_id      = "vpc-020f81b49e586f534"

  ingress {
    description      = "SSH"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  ingress {
    description      = "HTTP"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]

  }
}

output "instance_ip_addr" {
  value = aws_instance.web.public_ip
}
