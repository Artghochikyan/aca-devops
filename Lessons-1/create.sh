#!/bin/sh
echo "Running terraform"
terraform init
terraform apply
echo "Fetching ip from output"
terraform output | awk -F'"' '/"/ {print $2}' > inventory
echo "Running ansible-wordpress.yaml"
ansible-playbook -i inventory ansible-wordpress.yaml