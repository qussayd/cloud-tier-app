resource "aws_db_subnet_group" "db_subnet" {
  name       = "main-db-subnet-group"
  subnet_ids = [aws_subnet.private_1.id, aws_subnet.private_2.id]
}

resource "aws_security_group" "db_sg" {
  name        = "db-security-group"
  description = "Allow inbound traffic from within VPC"
  vpc_id      = aws_vpc.main.id

  ingress {
    description = "PostgreSQL access from within VPC"
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/16"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_db_instance" "postgres" {
  identifier             = "cloud-tier-db"
  allocated_storage      = 20
  engine                 = "postgres"
  engine_version         = "16"
  instance_class         = "db.t4g.micro"
  db_name                = "appdb"
  username               = "cloudadmin"
  password               = var.db_password
  db_subnet_group_name   = aws_db_subnet_group.db_subnet.name
  vpc_security_group_ids = [aws_security_group.db_sg.id]
  skip_final_snapshot    = true
  publicly_accessible    = false
}
