
# RDSCustom

Build some EC2 instances to test out an RDS Custom database

This set of Terraform builds:

    *An EC2 Instance (Linux) in a public Subnet
    *An EC2 Instance (windows) in a public subnet
    *An EC2 Instance (Linux) in a private Subnet (pre-defined)
    *Updates a route table (pre-defined)
    *Sets up Secrets Manager parameter store for AWS keys etc.

You will need to create a terraform.tfvars files containing your access keys etc.

    *access_key = "fred"
    *secret_key = "joe"
    *passphrase = "Fred"

This is to prevent the keys being stored in GIT and means that they are not in user_data.
