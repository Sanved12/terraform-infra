//=======================================================================================================\\
//                                    Security Group for EC2                                             \\
//=======================================================================================================\\
resource "aws_security_group" "ec2_sg" {
  name        = "${var.environment}-ec2-sg"
  description = "Security group for EC2 instances"
  vpc_id      = var.vpc_id

  ingress {
    description     = "Allow HTTP traffic from ALB only"
    from_port       = var.ec2_conf.app_port
    to_port         = var.ec2_conf.app_port
    protocol        = "tcp"
    security_groups = [var.alb_security_group_id]
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
      "Name"        = "${var.environment}-ec2-sg"
      "Environment" = var.environment
    },
    var.common_tags
  )
}

//=======================================================================================================\\
//                                         EC2 Key Pair                                                  \\
//=======================================================================================================\\
resource "aws_key_pair" "ec2_key" {
  count      = var.ec2_conf.public_key != "" ? 1 : 0
  key_name   = "${var.environment}-ec2-key"
  public_key = var.ec2_conf.public_key

  tags = merge(
    {
      "Name"        = "${var.environment}-ec2-key"
      "Environment" = var.environment
    },
    var.common_tags
  )
}

//=======================================================================================================\\
//                                         EC2 Instances                                                 \\
//=======================================================================================================\\
resource "aws_instance" "app_servers" {
  count                  = var.ec2_conf.instance_count
  ami                    = var.ec2_conf.ami_id
  instance_type          = var.ec2_conf.instance_type
  subnet_id              = var.private_app_subnet_ids[count.index % length(var.private_app_subnet_ids)]
  vpc_security_group_ids = [aws_security_group.ec2_sg.id]
  key_name               = var.ec2_conf.public_key != "" ? aws_key_pair.ec2_key[0].key_name : null

  root_block_device {
    volume_type           = var.ec2_conf.root_volume.type
    volume_size           = var.ec2_conf.root_volume.size_gb
    encrypted             = true
    delete_on_termination = true
  }

  user_data = base64encode(<<-EOF
    #!/bin/bash
    dnf update -y
    dnf install -y httpd
    echo "<h1>Hello from ${var.environment} - Instance ${count.index + 1}</h1>" > /var/www/html/index.html
    echo "OK" > /var/www/html/health
    systemctl enable httpd
    systemctl start httpd
  EOF
  )

  tags = merge(
    {
      "Name"        = "${var.environment}-app-server-${count.index + 1}"
      "Environment" = var.environment
    },
    var.common_tags
  )
}

//=======================================================================================================\\
//                              Attach EC2 Instances to ALB Target Group                                 \\
//=======================================================================================================\\
resource "aws_lb_target_group_attachment" "ec2_tg_attachment" {
  count            = var.ec2_conf.instance_count
  target_group_arn = var.target_group_arn
  target_id        = aws_instance.app_servers[count.index].id
  port             = var.ec2_conf.app_port
}
