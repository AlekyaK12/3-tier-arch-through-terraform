# creating Subnet groups in rds
resource "aws_db_subnet_group" "project3" {
  name       = "project3_subnetgroup"
  subnet_ids = [aws_subnet.private_subnet5.id, aws_subnet.private_subnet6.id]

  tags = {
    Name = "project3_subnetgroup"
  }
}

# creating Rds instance
resource "aws_db_instance" "rds-1" {
  allocated_storage    = 10
  db_name              = "project3"
  engine               = "mysql"
  engine_version       = "8.0"
  instance_class       = "db.t3.micro"
  username             = "admin"
  password             = "Alekya1389#"
  skip_final_snapshot  = true
  
  tags ={
    Name = "Alidb"
  }
}
