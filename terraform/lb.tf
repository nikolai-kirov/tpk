
resource "aws_lb" "tpk_lb" {
  name               = "tpk-lb"
  internal           = false
  load_balancer_type = "application"
  subnets            = data.aws_subnets.tpk_subnets.ids
}

resource "aws_lb_target_group" "tpk_target_group" {
  name        = "tpk-target-group"
  port        = 80
  protocol    = "HTTP"
  target_type = "ip"
  vpc_id      = data.aws_vpc.tpk_vpc.id
}

resource "aws_lb_listener" "tpk_listener" {
  load_balancer_arn = aws_lb.tpk_lb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.tpk_target_group.id
  }
}

resource "aws_lb_listener_rule" "tpk_listener_rule" {
  listener_arn = aws_lb_listener.tpk_listener.arn
  priority     = 100

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.tpk_target_group.arn
  }

  condition {
    path_pattern {
      values = ["/"]
    }
  }
}
