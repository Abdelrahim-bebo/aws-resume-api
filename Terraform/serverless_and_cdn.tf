# CloudFront OAC
resource "aws_cloudfront_origin_access_control" "oac" {
  name                              = "resume-api-oac"
  origin_access_control_origin_type = "s3"
  signing_behavior                  = "always"
  signing_protocol                  = "sigv4"
}

resource "aws_cloudfront_distribution" "s3_distribution" {
  origin {
    domain_name              = aws_s3_bucket.resume_bucket.bucket_regional_domain_name
    origin_id                = "resume-api-bucket-1.s3.us-east-1.amazonaws.com"
    origin_access_control_id = aws_cloudfront_origin_access_control.oac.id
  }
  enabled             = true
  default_cache_behavior {
    allowed_methods  = ["GET", "HEAD"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = "resume-api-bucket-1.s3.us-east-1.amazonaws.com"
    viewer_protocol_policy = "redirect-to-https"
    forwarded_values {
      query_string = false
      cookies { forward = "none" }
    }
  }
  price_class = "PriceClass_All"
  viewer_certificate {
    cloudfront_default_certificate = true
  }
}

# SNS Topic
resource "aws_sns_topic" "notifications" {
  name = "Task-Notifications"
}

# SQS Queue
resource "aws_sqs_queue" "cv_queue" {
  name = "CV-Processing-Queue"
}

# SQS Policy allowing S3
resource "aws_sqs_queue_policy" "s3_sqs_policy" {
  queue_url = aws_sqs_queue.cv_queue.id
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = { Service = "s3.amazonaws.com" }
        Action   = "sqs:SendMessage"
        Resource = aws_sqs_queue.cv_queue.arn
        Condition = {
          ArnLike = { "aws:SourceArn" : aws_s3_bucket.resume_bucket.arn }
        }
      }
    ]
  })
}

# S3 Notification to SQS
resource "aws_s3_bucket_notification" "bucket_notification" {
  bucket = aws_s3_bucket.resume_bucket.id
  queue {
    queue_arn     = aws_sqs_queue.cv_queue.arn
    events        = ["s3:ObjectCreated:*"]
    filter_prefix = "resumes/"
  }
}
