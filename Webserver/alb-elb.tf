# Application Load Balancer (ALB)
resource "aws_lb" "web_alb" {
  name               = "Project-ALB"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [data.terraform_remote_state.networks.outputs.alb_sg]
  subnets            = [
    data.terraform_remote_state.networks.outputs.public_subnet_1,
    data.terraform_remote_state.networks.outputs.public_subnet_2,
    data.terraform_remote_state.networks.outputs.public_subnet_3,
    data.terraform_remote_state.networks.outputs.public_subnet_4
  ]

  enable_deletion_protection = false

  tags = {
    Name = "Project-ALB"
  }
}

# Target Group for the ALB
resource "aws_lb_target_group" "web_target_group" {
  name        = "web-target-group"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = data.terraform_remote_state.networks.outputs.vpc_id
  target_type = "instance"

  health_check {
    path                = "/"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 3
    unhealthy_threshold = 2
    matcher             = "200"
  }

  tags = {
    Name = "Project-Web-Target-Group"
  }
}

resource "aws_lb_listener" "http_listener" {
  load_balancer_arn = aws_lb.web_alb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.web_target_group.arn
  }
}

# Register Webserver 1 with Target Group
resource "aws_lb_target_group_attachment" "webserver_1_attachment" {
  target_group_arn = aws_lb_target_group.web_target_group.arn
  target_id        = aws_instance.webserver_1.id
  port             = 80
}

# Register Webserver 2 with Target Group
resource "aws_lb_target_group_attachment" "webserver_2_attachment" {
  target_group_arn = aws_lb_target_group.web_target_group.arn
  target_id        = aws_instance.webserver_2.id
  port             = 80
}

# Register Webserver 3 with Target Group
resource "aws_lb_target_group_attachment" "webserver_3_attachment" {
  target_group_arn = aws_lb_target_group.web_target_group.arn
  target_id        = aws_instance.webserver_3.id
  port             = 80
}

# Register Webserver 4 with Target Group
resource "aws_lb_target_group_attachment" "webserver_4_attachment" {
  target_group_arn = aws_lb_target_group.web_target_group.arn
  target_id        = aws_instance.webserver_4.id
  port             = 80
}
