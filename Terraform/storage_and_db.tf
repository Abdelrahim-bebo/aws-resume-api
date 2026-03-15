# ECR Repository
resource "aws_ecr_repository" "resume_api" {
  name                 = "resume-api"
  image_tag_mutability = "MUTABLE"
}

# RDS Database
resource "aws_db_subnet_group" "rds_subnet_group" {
  name       = "resume-api-db-subnet"
  subnet_ids = [aws_subnet.private1.id, aws_subnet.private2.id]
}

resource "aws_db_instance" "mysql_db" {
  allocated_storage      = 20
  engine                 = "mysql"
  instance_class         = "db.t3.micro"
  username               = "admin" # Provide via secrets in prod
  password               = "password123" # Provide via secrets in prod
  db_subnet_group_name   = aws_db_subnet_group.rds_subnet_group.name
  vpc_security_group_ids = [aws_security_group.rds_sg.id]
  skip_final_snapshot    = true
}

# S3 Bucket
resource "aws_s3_bucket" "resume_bucket" {
  bucket = "resume-api-bucket-1"
}

resource "aws_s3_bucket_public_access_block" "block_public" {
  bucket                  = aws_s3_bucket.resume_bucket.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_versioning" "versioning" {
  bucket = aws_s3_bucket.resume_bucket.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_cors_configuration" "cors" {
  bucket = aws_s3_bucket.resume_bucket.id
  cors_rule {
    allowed_headers = ["*"]
    allowed_methods = ["GET", "PUT", "POST", "DELETE"]
    allowed_origins = ["*"]
  }
}

# EFS 
resource "aws_efs_file_system" "efs" {
  encrypted = true
  tags = { Name = "resume-api-efs" }
}

resource "aws_efs_mount_target" "efs_mt1" {
  file_system_id  = aws_efs_file_system.efs.id
  subnet_id       = aws_subnet.private1.id
  security_groups = [aws_security_group.efs_sg.id]
}

resource "aws_efs_mount_target" "efs_mt2" {
  file_system_id  = aws_efs_file_system.efs.id
  subnet_id       = aws_subnet.private2.id
  security_groups = [aws_security_group.efs_sg.id]
}
