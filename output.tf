# Define Output Values
output "ec2_instance_publicip-1" {
  description = "EC2 Instance Public IP"
  value = aws_instance.webtier_ec2-1.public_ip
}

# Attribute Reference - Create Public DNS URL 
output "ec2_publicdns-1" {
  description = "Public DNS URL of an EC2 Instance"
  value = aws_instance.webtier_ec2-1.public_dns
}

output "ec2_instance_publicip-2" {
  description = "EC2 Instance Public IP"
  value = aws_instance.webtier_ec2-2.public_ip
}

# Attribute Reference - Create Public DNS URL 
output "ec2_publicdns-2" {
  description = "Public DNS URL of an EC2 Instance"
  value = aws_instance.webtier_ec2-2.public_dns
}

output "ec2_instance_publicip-3" {
  description = "EC2 Instance Public IP"
  value = aws_instance.apptier_ec2-1.public_ip
}

# Attribute Reference - Create Public DNS URL 
output "ec2_publicdns-3" {
  description = "Public DNS URL of an EC2 Instance"
  value = aws_instance.apptier_ec2-1.public_dns
}

output "ec2_instance_publicip-4" {
  description = "EC2 Instance Public IP"
  value = aws_instance.apptier_ec2-2.public_ip
}

# Attribute Reference - Create Public DNS URL 
output "ec2_publicdns-4" {
  description = "Public DNS URL of an EC2 Instance"
  value = aws_instance.apptier_ec2-2.public_dns
}
