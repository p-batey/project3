# create Application Load Balancer, with cross zone load balancing for multi AZ
resource "aws_lb" "web_alb" {
  provider           = aws.region-web
  name               = "web-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.lb-sg.id]
  subnets            = [aws_subnet.public_us_east_1a.id, aws_subnet.public_us_east_1b.id]

  enable_cross_zone_load_balancing = true

  tags = {
    Name = "Web-LB"
  }
}

# Create Load Balancer Target Group to monitor on port 8080
resource "aws_lb_target_group" "app-lb-tg" {
  provider    = aws.region-web
  name        = "app-lb-tg"
  port        = var.webserver-port
  target_type = "instance"
  vpc_id      = aws_vpc.web_vpc.id
  protocol    = "HTTP"
  health_check {
    enabled  = true
    interval = 10
    path     = "/"
    port     = var.webserver-port
    protocol = "HTTP"
    matcher  = "200-299"
  }
  tags = {
    Name = "web-target-group"
  }
}

# Create an HTTP listener on port 80 forwards to the target group
resource "aws_lb_listener" "web-listener-http" {
  provider          = aws.region-web
  load_balancer_arn = aws_lb.web_alb.arn
  port              = "80"
  protocol          = "HTTP"
  default_action {
    type = "forward"
    target_group_arn = aws_lb_target_group.app-lb-tg.id
    }
}
