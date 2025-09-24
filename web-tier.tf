# creating Ec2 instances
resource "aws_instance" "webtier_ec2-1" {
  ami                         = "ami-0360c520857e3138f"
  instance_type               = "t3.micro"
  subnet_id                   = aws_subnet.public_subnet1.id
  key_name                    = "project"
  user_data                   = file("apache2.sh")
  vpc_security_group_ids      = [aws_security_group.project3-sg.id]

  associate_public_ip_address = true

  tags = {
    Name = "web-1"
  }
}

resource "aws_instance" "webtier_ec2-2" {
  ami                         = "ami-0360c520857e3138f"
  instance_type               = "t3.micro"
  subnet_id                   = aws_subnet.public_subnet2.id
  key_name                    = "project"
  user_data                   = file("apache2.sh")
  vpc_security_group_ids      = [aws_security_group.project3-sg.id]

  associate_public_ip_address = true

  tags = {
    Name = "web-2"
  }
}


# creating Target group
resource "aws_lb_target_group" "project3-tg1" {
  name     = "public-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.project3-vpc.id
}

resource "aws_lb_target_group" "project3-tg2" {
  name     = "private-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.project3-vpc.id
}


# target group attachement
resource "aws_lb_target_group_attachment" "project3-attach1" {
  target_group_arn = aws_lb_target_group.project3-tg1.arn
  target_id        = aws_instance.webtier_ec2-1.id
  port             = 80
}

resource "aws_lb_target_group_attachment" "project3-attach2" {
  target_group_arn = aws_lb_target_group.project3-tg2.arn
  target_id        = aws_instance.webtier_ec2-2.id
  port             = 80
}


# creating load balancer
resource "aws_lb" "project3-lb" {
  name               = "web-lb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.project3-sg.id]
  subnets            = [aws_subnet.public_subnet1.id,aws_subnet.public_subnet2.id]
}

# create ami
resource "aws_ami_from_instance" "Ali-Ami" {
  name               = "pj-ami-1"
  source_instance_id = aws_instance.webtier_ec2-1.id
  description        = "AMI created from my EC2 instance"
}

# Launch instance from Ami
# Launch instance from the fetched AMI
resource "aws_instance" "webtier_ec2-a1" {
  ami           ="ami-0360c520857e3138f"
  instance_type = "t3.micro"
}

# Launch Template
resource "aws_launch_template" "project3-temp" {
  name_prefix   = "lt-from-instance-1"
  image_id      = aws_ami_from_instance.Ali-Ami.id
  instance_type = "t3.micro"  # Choose as required
}
  
# creating Auto scaling group
resource "aws_autoscaling_group" "project3-asg" {
  name                      = "project-asg"
  min_size                  = 1
  max_size                  = 3
  desired_capacity          = 2
  vpc_zone_identifier = [
    aws_subnet.public_subnet1.id,
    aws_subnet.public_subnet2.id
  ]

  launch_template {
    id      = aws_launch_template.project3-temp.id
    version = "$Latest"
  }
}
