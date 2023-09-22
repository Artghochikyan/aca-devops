user_data = <<EOF
#!/bin/bash
sudo yum update -y
sudo yum install docker -y
sudo service docker start
sudo usermod -a -G docker ec2-user
sudo docker run -d --name wordpress -p 80:80 wordpress
EOF 