# creating Ec2 instances
resource "aws_instance" "apptier_ec2-1" {
  ami                         = "ami-0360c520857e3138f"
  instance_type               = "t3.micro"
  subnet_id                   = aws_subnet.private_subnet3.id
  key_name                    = "project"
  user_data                   = file("apache2.sh")
  vpc_security_group_ids      = [aws_security_group.project3-sg.id]

  associate_public_ip_address = true

  tags = {
    Name = "App-1"
  }
}

resource "aws_instance" "apptier_ec2-2" {
  ami                         = "ami-0360c520857e3138f"
  instance_type               = "t3.micro"
  subnet_id                   = aws_subnet.private_subnet4.id
  key_name                    = "project"
  user_data                   = file("apache2.sh")
  vpc_security_group_ids      = [aws_security_group.project3-sg.id]

  associate_public_ip_address = true

  tags = {
    Name = "App-2"
  }
}


# creating load balancer
resource "aws_lb" "project3-lb-1" {
  name               = "App-lb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.project3-sg.id]
  subnets            = [aws_subnet.private_subnet3.id,aws_subnet.private_subnet4.id]
}

# create Ami 
resource "aws_ami_from_instance" "project3-1" {
  name               = "project3-ami-1"
  source_instance_id = aws_instance.apptier_ec2-1.id
  description        = "AMI created from my EC2 instance"
}

# Launch instance from Ami
# Launch instance from the fetched AMI
resource "aws_instance" "apptier_ec2-b1" {
  ami           ="ami-0360c520857e3138f"
  instance_type = "t3.micro"
}

# Launch Template
resource "aws_launch_template" "project3-temp-1" {
  name_prefix   = "lt-from-instance-2"
  image_id      = aws_ami_from_instance.project3-1.id
  instance_type = "t3.micro"  # Choose as required
}

# creating Auto scaling group
resource "aws_autoscaling_group" "project3-asg-1" {
  name                      = "project-asg-1"
  min_size                  = 1
  max_size                  = 3
  desired_capacity          = 2
   vpc_zone_identifier = [
    aws_subnet.private_subnet3.id,
    aws_subnet.private_subnet4.id
  ]

  launch_template {
    id      = aws_launch_template.project3-temp-1.id
    version = "$Latest"
  }
}