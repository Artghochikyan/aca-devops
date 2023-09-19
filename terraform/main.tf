
resource "aws_instance" "web" {
  ami           = "ami-053b0d53c279acc90"
  instance_type = "t2.micro"

  tags = {
    Name = "Wordpress"
  }
}





resource "aws_key_pair" "deployer" {
  key_name   = "deployer-key"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQCOM9gLXnL3DNTtue93srMsZXJYAj7UzSWVj+N2OgH3oOASS2prKX7uNizJcxqydmnx00R/OIHuKnglfgmydU+6ZTcxe0jJG5REQ9ANvJdNvTI04yu3TlbQI2TBJQFhXRXuGAcVpbEyVvR+cZM9RdFc23mYXxwamnhnWmBcJWGkPjQ8L/gMjtn0ZgkcfoPnTiCuZ4OF32nrNaviMeUlxn0t1Y3ePl3RVfcl7OxHIXDg3qQqtvzMbOM7VA8fZusDBETMOzt698O20LG7iEZguYAo7Cd4whstYdf5cKi9qmkpuIY4B9teCvJxIfolPrPYzJZw1gUxj6U9iGPnKPrPHzFueGLRt2KsZepg3pwvdcvBFLFCg6GsMCDFPUNbRMGXEZIUI1i7r8HeN3OTZ6uFb/SI1y/5MQXyBvh7fyofDMkEpDx6RpWgG1yxcDDJRZ3KK7MQPUGPbpm3KDu1zAzjPEIZLudvo1GMzBlwKZRyt/pr8g2BNLh0DGUC4/4YWFKvV40= art@art-virtual-machine"
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
