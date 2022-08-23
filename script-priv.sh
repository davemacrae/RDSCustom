#!/bin/bash

# This is the script that will be used for EC2 instances on the public subnet

# Basic updates
sudo yum update -y

# Set up AWS CLI & AWS-Vault
cd /tmp
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
sudo ./aws/install

wget "https://github.com/99designs/aws-vault/releases/download/v6.6.0/aws-vault-linux-amd64" -O "aws-vault"
chmod +x aws-vault
mv aws-vault /usr/local/bin

# Get the AWS keys from the SSM Parameter Store
export access_key=$(aws ssm get-parameters --names ${access_key_name} --with-decryption --query "Parameters[*].{Value:Value}" --output text)
export secret_key=$(aws ssm get-parameters --names ${secret_key_name} --with-decryption --query "Parameters[*].{Value:Value}" --output text)
export passphrase=$(aws ssm get-parameters --names ${passphrase_name} --with-decryption --query "Parameters[*].{Value:Value}" --output text)

cat >> ~ec2-user/.bash_profile <<EOF
## AWS Vault Stuff
export AWS_ACCESS_KEY_ID=$${access_key} 
export AWS_SECRET_ACCESS_KEY=$${access_key} 
export AWS_VAULT_BACKEND=file 
export AWS_VAULT_FILE_PASSPHRASE=$${passphrase}
alias ee="aws-vault exec ee-test-account --"

EOF

mkdir -p ~ec2-user/.aws
cat >> ~ec2-user/.aws/credentials <<EOF
[dmacrae]
aws_access_key_id = $${access_key}
aws_secret_access_key = $${secret_key}
EOF

cat >> ~ec2-user/.aws/config <<EOF
[default]
region = eu-west-2

[profile ee-test-account]
role_arn=arn:aws:iam::889772146711:role/OrganizationAccountAccessRole
source_profile=ee-master
mfa_serial=arn:aws:iam::044357138720:mfa/dmacrae

[profile ee-master]
aws_account_id=equalexperts
region=eu-west-2
EOF

HOME=~ec2-user AWS_ACCESS_KEY_ID=$${access_key} AWS_SECRET_ACCESS_KEY=$${secret_key} AWS_VAULT_BACKEND=file AWS_VAULT_FILE_PASSPHRASE=$${passphrase} /usr/local/bin/aws-vault add ee-master --env 
sudo chown -R ec2-user.ec2-user ~ec2-user/.awsvault

