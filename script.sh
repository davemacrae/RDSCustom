#!/bin/bash

# This is the script that will be used for EC2 instances on the public subnet

# Basic updates
sudo yum update -y

# Install Oracle Tools
cd /tmp

wget https://download.oracle.com/otn_software/linux/instantclient/214000/instantclient-basic-linux.x64-21.4.0.0.0dbru.zip
wget https://download.oracle.com/otn_software/linux/instantclient/214000/instantclient-sqlplus-linux.x64-21.4.0.0.0dbru.zip
sudo mkdir -p /opt/oracle
sudo unzip -d /opt/oracle instantclient-basic-linux.x64-21.4.0.0.0dbru.zip
sudo unzip -d /opt/oracle instantclient-sqlplus-linux.x64-21.4.0.0.0dbru.zip

cat > /tmp/tnsnames.ora << EOF
db=(description=(address=(protocol=tcp)(host=restored.c5fwfl79y6kg.eu-west-2.rds.amazonaws.com)(port=1521))(connect_data=(sid=orcl)))
EOF

sudo mv /tmp/tnsnames.ora /opt/oracle/instantclient_21_4/network/admin/tnsnames.ora

cat >> ~ec2-user/.bash_profile <<EOF
## Set environment variables in your ~/.bash_profile

export ORACLE_HOME=/opt/oracle/instantclient_21_4

export LD_LIBRARY_PATH=/opt/oracle/instantclient_21_4:\$LD_LIBRARY_PATH
export PATH=\$LD_LIBRARY_PATH:\$PATH
EOF

# Set up AWS CLI & AWS-Vault
cd /tmp
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
sudo ./aws/install

wget "https://github.com/99designs/aws-vault/releases/download/v6.6.0/aws-vault-linux-amd64" -O "aws-vault"
chmod +x aws-vault
mv aws-vault /usr/local/bin

# Get the AWS keys from the SSM Parameter Store
export AWS_SECRET_ACCESS_KEY=$(aws ssm get-parameters --names ${secret_key_name} --with-decryption --query "Parameters[*].{Value:Value}" --output text)
export AWS_VAULT_FILE_PASSPHRASE=$(aws ssm get-parameters --names ${passphrase_name} --with-decryption --query "Parameters[*].{Value:Value}" --output text)
export AWS_ACCESS_KEY_ID=$(aws ssm get-parameters --names ${access_key_name} --with-decryption --query "Parameters[*].{Value:Value}" --output text)

cat >> ~ec2-user/.bash_profile <<EOF
## AWS Vault Stuff
export AWS_ACCESS_KEY_ID=$${AWS_ACCESS_KEY_ID} 
export AWS_SECRET_ACCESS_KEY=$${AWS_SECRET_ACCESS_KEY} 
export AWS_VAULT_BACKEND=file 
export AWS_VAULT_FILE_PASSPHRASE=$${AWS_VAULT_FILE_PASSPHRASE}
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

HOME=~ec2-user AWS_VAULT_BACKEND=file /usr/local/bin/aws-vault add ee-master --env 
sudo chown -R ec2-user.ec2-user ~ec2-user/.awsvault

