# 1. Security Group: resume-api-PassAll
resource "aws_security_group" "pass_all" {
  name        = "resume-api-PassAll"
  description = "Testing Only: Allows all inbound and outbound traffic."
  vpc_id      = aws_vpc.main.id

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "resume-api-PassAll"
  }
}

# 2. Security Group: resume-api-PassSSH
resource "aws_security_group" "pass_ssh" {
  name        = "resume-api-PassSSH"
  description = "Allows secure shell access to the instances for administration."
  vpc_id      = aws_vpc.main.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # ⚠️ Note: Should be restricted to your IP in production
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "resume-api-PassSSH"
  }
}

# 3. Security Group: resume-api-PassHTTP Used with ALB
resource "aws_security_group" "pass_http" {
  name        = "resume-api-PassHTTP"
  description = "Allows unencrypted web traffic to access the API or web servers."
  vpc_id      = aws_vpc.main.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "resume-api-PassHTTP"
  }
}


# EC2 ASG Security Group
resource "aws_security_group" "ec2_asg_sg" {
  name        = "EC2-ASG-SG"
  description = "Accept traffic originating from ALB"
  vpc_id      = aws_vpc.main.id

  ingress {
    from_port       = 8080
    to_port         = 8080
    protocol        = "tcp"
    security_groups = [aws_security_group.alb_sg.id]
  }
  

# RDS Security Group
resource "aws_security_group" "rds_sg" {
  name        = "RDS-SG"
  vpc_id      = aws_vpc.main.id

  ingress {
    from_port       = 3306
    to_port         = 3306
    protocol        = "tcp"
    security_groups = [aws_security_group.ec2_asg_sg.id]
  }
}

# EFS Security Group
resource "aws_security_group" "efs_sg" {
  name        = "EFS-Server"
  vpc_id      = aws_vpc.main.id

  ingress {
    from_port       = 2049
    to_port         = 2049
    protocol        = "tcp"
    security_groups = [aws_security_group.ec2_asg_sg.id]
  }
}
