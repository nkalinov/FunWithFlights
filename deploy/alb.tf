resource "aws_alb" "funwithflights_service" {
  name               = "funwithflights-service-lb"
  internal           = false
  load_balancer_type = "application"

  subnets = [
    aws_subnet.public_a.id,
    aws_subnet.public_b.id,
  ]

  security_groups = [
    aws_security_group.http.id,
    aws_security_group.https.id,
    aws_security_group.egress_all.id,
  ]

  depends_on = [aws_internet_gateway.igw]
}

resource "aws_alb_listener" "funwithflights_service_http" {
  load_balancer_arn = aws_alb.funwithflights_service.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    #    type             = "forward"
    #    target_group_arn = aws_lb_target_group.funwithflights_service.arn
    type = "fixed-response"
    fixed_response {
      status_code  = "404"
      content_type = "text/plain"
      message_body = "Not Found"
    }
  }
}

resource "aws_lb_target_group" "funwithflights_service" {
  name        = "funwithflights-data-service"
  port        = 3000
  protocol    = "HTTP"
  target_type = "ip"
  vpc_id      = aws_vpc.app_vpc.id

  health_check {
    enabled = true
    path    = "/health"
  }

  depends_on = [aws_alb.funwithflights_service]
}

resource "aws_lb_listener_rule" "lb_path_data_service" {
  listener_arn = aws_alb_listener.funwithflights_service_http.arn

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.funwithflights_service.arn
  }

  condition {
    path_pattern {
      values = ["/api/data/*"]
    }
  }
}

output "service_alb_url" {
  value = "http://${aws_alb.funwithflights_service.dns_name}"
}