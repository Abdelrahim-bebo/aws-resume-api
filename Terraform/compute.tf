# Application Load Balancer
resource "aws_lb" "alb" {
  name               = "resume-api-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb_sg.id]
  subnets            = [aws_subnet.public1.id, aws_subnet.public2.id]
}

resource "aws_lb_target_group" "tg" {
  name     = "resume-api-TG"
  port     = 8080
  protocol = "HTTP"
  vpc_id   = aws_vpc.main.id

  health_check {
    path    = "/"
    port    = "traffic-port"
    matcher = "200" 
  }
}

resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.alb.arn
  port              = "80"
  protocol          = "HTTP"
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.tg.arn
  }
}

# Launch Template & ASG
resource "aws_launch_template" "lt" {
  name          = "resume-api-lt"
  image_id      = "ami-03500eeac27f0f059" # Custom AMI mentioned
  instance_type = "t3.micro"
  
  network_interfaces {
    security_groups = [aws_security_group.ec2_asg_sg.id]
  }
}

resource "aws_autoscaling_group" "asg" {
  name                = "resume-api-asg"
  vpc_zone_identifier = [aws_subnet.public1.id, aws_subnet.public2.id]
  desired_capacity    = 1
  min_size            = 1
  max_size            = 3
  health_check_type   = "EC2"
  health_check_grace_period = 300

  launch_template {
    id      = aws_launch_template.lt.id
    version = "$Latest"
  }
  target_group_arns = [aws_lb_target_group.tg.arn]
}

resource "aws_autoscaling_policy" "cpu_policy" {
  name                   = "cpu-target-tracking"
  autoscaling_group_name = aws_autoscaling_group.asg.name
  policy_type            = "TargetTrackingScaling"
  
  target_tracking_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ASGAverageCPUUtilization"
    }
    target_value = 70.0
  }
}
