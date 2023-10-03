#!/bin/sh
echo "Running terraform"
terraform init && terraform apply -auto-approve -lock=false
echo "Fetching ip from output"
terraform output | awk -F'"' '/"/ {print $2}' > inventory
echo "Running ansible-wordpress.yaml"
ansible-playbook -i inventory ansible-wordpress.yaml #-e mysql_host=$mysql_host -e wp_pass=${{secrets.WORDPRESS_DB_PASSWORD}} --ssh-common-args='-o Strict