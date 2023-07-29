#main.tf
#defining the provider as aws
provider "aws" {
    region                  = "us-east-1"
    access_key              = "${var.access_key}"
    secret_key              = "${var.secret_key}"
}

###########
# AWS RDS
###########
#create a security group for RDS Database Instance
resource "aws_security_group" "rds_sg" {
  name = "rds_sg"

  # my computer
  ingress {
    from_port               = 5432
    to_port                 = 5432
    protocol                = "tcp"
    cidr_blocks             = ["${var.dev_pc}"]
  }
  # ec2
  ingress {
    from_port               = 5432
    to_port                 = 5432
    protocol                = "tcp"
    security_groups         = ["${aws_security_group.ec2_sg.id}"]
  }
  # hex
  ingress {
    from_port               = 0
    to_port                 = 0
    protocol                = "-1"
    cidr_blocks             = ["3.129.36.245/32"]
  }
  # hex
  ingress {
    from_port               = 0
    to_port                 = 0
    protocol                = "-1"
    cidr_blocks             = ["3.13.16.99/32"]
  }
  # hex
  ingress {
    from_port               = 0
    to_port                 = 0
    protocol                = "-1"
    cidr_blocks             = ["3.18.79.139/32"]
  }
  egress {
    from_port               = 0
    to_port                 = 0
    protocol                = "-1"
    cidr_blocks             = ["0.0.0.0/0"]
  }
}

#create a RDS Database instance
resource "aws_db_instance" "fitness-db" {
  engine                    = "postgres"
  identifier                = "fitness-db"
  allocated_storage         =  10
  #engine_version           = "9.5.4"
  instance_class            = "db.t3.micro"
  username                  = "${var.db_user}"
  password                  = "${var.db_pass}"
  #parameter_group_name     = "default.mysql5.7"
  vpc_security_group_ids    = ["${aws_security_group.rds_sg.id}"]
  skip_final_snapshot       = true
  publicly_accessible       = true
  #storage_encrypted        = true
  storage_type              = "gp2"
}

###########
# AWS EC2
###########
#create a security group for ec2 instance
resource "aws_security_group" "ec2_sg" {
  name = "ec2_sg"
  
  # my computer
  ingress {
    from_port               = 22
    to_port                 = 22
    protocol                = "tcp"
    cidr_blocks             = ["45.46.75.203/32"]
  }
  egress {
    from_port               = 0
    to_port                 = 0
    protocol                = "-1"
    cidr_blocks             = ["0.0.0.0/0"]
  }
}

#create EC2 instance
resource "aws_instance" "fitness-ec2" {
    ami = "${var.ami_id}"
    count = "1"
    #subnet_id = "${var.subnet_id}"
    instance_type = "t2.micro"
    key_name = "${var.ami_key_pair_name}"
    vpc_security_group_ids    = ["${aws_security_group.ec2_sg.id}"]
    associate_public_ip_address = true
} 