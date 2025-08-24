# ALB SG (80 from anywhere)
resource "aws_security_group" "alb" {
  name   = "${var.project_name}-alb-sg"
  vpc_id = var.vpc_id

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

  tags = var.tags
}

# EC2 SG (80 from ALB SG, 22 from my IP)
resource "aws_security_group" "ec2" {
  name   = "${var.project_name}-ec2-sg"
  vpc_id = var.vpc_id

  ingress {
    description     = "HTTP from ALB"
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = [aws_security_group.alb.id]
  }

  ingress {
    description = "SSH from my IP"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.my_ip]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = var.tags
}

resource "aws_lb" "app" {
  name               = "${var.project_name}-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb.id]
  subnets            = var.public_subnets
  tags               = var.tags
}

resource "aws_lb_target_group" "tg" {
  name     = "${var.project_name}-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = var.vpc_id

  health_check {
    path                = "/"
    matcher             = "200"
    interval            = 30
    healthy_threshold   = 2
    unhealthy_threshold = 2
  }

  tags = var.tags
}

resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.app.arn
  port              = 80
  protocol          = "HTTP"
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.tg.arn
  }
}

data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"] # Canonical
  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }
}

# replace user_data from template with runtime values
data "template_file" "userdata" {
  template = file("${path.module}/user_data.sh.tmpl")
  vars = {
    name         = var.project_name
    today        = timestamp()
    region       = var.region
    secret_arn   = var.secret_arn
    rds_endpoint = var.rds_endpoint
    db_name      = "appdb"
    bucket_name  = var.s3_bucket_name
  }
}


resource "aws_launch_template" "lt" {
  name_prefix   = "${var.project_name}-lt-"
  image_id      = data.aws_ami.ubuntu.id
  instance_type = var.instance_type

  iam_instance_profile {
    name = var.instance_profile
  }

  network_interfaces {
    associate_public_ip_address = true
    security_groups             = [aws_security_group.ec2.id]
  }

  user_data = base64encode(data.template_file.userdata.rendered)

  tag_specifications {
    resource_type = "instance"
    tags          = var.tags
  }

  tags = var.tags
}

resource "aws_autoscaling_group" "asg" {
  name                      = "${var.project_name}-asg"
  min_size                  = 2
  max_size                  = 4
  desired_capacity          = 2
  vpc_zone_identifier       = var.public_subnets
  health_check_type         = "ELB"
  health_check_grace_period = 90

  launch_template {
    id      = aws_launch_template.lt.id
    version = "$Latest"
  }

  target_group_arns = [aws_lb_target_group.tg.arn]

  tag {
    key                 = "Name"
    value               = var.project_name
    propagate_at_launch = true
  }

  lifecycle {
    create_before_destroy = true
  }
}

# if cpu utilz > 50 then add another instance
resource "aws_autoscaling_policy" "scale_out" {
  name                   = "${var.project_name}-scaleout"
  autoscaling_group_name = aws_autoscaling_group.asg.name
  policy_type            = "TargetTrackingScaling"
  target_tracking_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ASGAverageCPUUtilization"
    }
    target_value = 50
  }
}
