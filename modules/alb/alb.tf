//=======================================================================================================\\
//                                    Security Group for ALB                                             \\
//=======================================================================================================\\
resource "aws_security_group" "alb_sg" {
  name        = "${var.environment}-alb-sg"
  description = "Security group for Application Load Balancer"
  vpc_id      = var.vpc_id

  ingress {
    description = "Allow HTTP from internet"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Allow HTTPS from internet"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "Allow all outbound"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(
    {
      "Name"        = "${var.environment}-alb-sg"
      "Environment" = var.environment
    },
    var.alb_conf.additional_tags
  )
}

//=======================================================================================================\\
//                                    Application Load Balancer                                          \\
//=======================================================================================================\\
resource "aws_lb" "alb" {
  name               = "${var.environment}-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb_sg.id]
  subnets            = var.public_subnet_ids

  enable_deletion_protection = var.alb_conf.enable_deletion_protection

  tags = merge(
    {
      "Name"        = "${var.environment}-alb"
      "Environment" = var.environment
    },
    var.alb_conf.additional_tags
  )
}

//=======================================================================================================\\
//                                         Target Group                                                  \\
//=======================================================================================================\\
resource "aws_lb_target_group" "tg" {
  name     = "${var.environment}-tg"
  port     = var.alb_conf.target_group.port
  protocol = var.alb_conf.target_group.protocol
  vpc_id   = var.vpc_id

  health_check {
    enabled             = true
    path                = var.alb_conf.target_group.health_check_path
    port                = "traffic-port"
    protocol            = var.alb_conf.target_group.protocol
    healthy_threshold   = 3
    unhealthy_threshold = 3
    timeout             = 5
    interval            = 30
    matcher             = "200-299"
  }

  tags = merge(
    {
      "Name"        = "${var.environment}-tg"
      "Environment" = var.environment
    },
    var.alb_conf.additional_tags
  )
}

//=======================================================================================================\\
//                                      HTTP Listener (port 80)                                          \\
//=======================================================================================================\\
resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.alb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.tg.arn
  }
}
