#!/bin/sh
echo "Running terraform"
terraform apply
echo "Fetching ip from output"
terraform output | awk -F'"' '/"/ {print $2}' > inventory
echo "Running ansible"
cd ansible
ansible-playbook -i inventory ansible-wordpress.yaml