
output "ec2instance" {
  value = aws_instance.linux-ec2.public_ip
}

output "private-ec2instance" {
  value = aws_instance.private-linux-ec2.private_ip
}

output "ec2-id" {
  value = aws_instance.linux-ec2.id
}

###output "win-ec2instance" {
###  value = aws_instance.windows-server.public_ip
###}
###
###output "win-ec2-id" {
###  value = aws_instance.windows-server.id
###}
