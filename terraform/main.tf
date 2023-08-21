provider "aws" {
  region  = "eu-west-3"  
}


data "aws_iam_role" "task_ecs" {
  name = "ecsTaskExecutionRole"
}

data "aws_vpc" "tpk_vpc" {
  id = "vpc-897875e0"  
}

data "aws_subnets" "tpk_subnets" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.tpk_vpc.id]
  }
 # tags = {
 #   Name = "tpk"  # Add a relevant tag to identify your subnets
 # }
}



resource "aws_ecs_cluster" "tpk_cluster" {
  name = "tpk-cluster"
}

resource "aws_ecs_task_definition" "tpk_task" {
  family                   = "tpk-task"
  network_mode             = "awsvpc"
  memory                   = 512
  cpu                      = 256
  requires_compatibilities = ["FARGATE"]
  execution_role_arn       = data.aws_iam_role.task_ecs.arn

  container_definitions = jsonencode([{
    name  = "tpk-container"
    image = "303981612052.dkr.ecr.eu-west-3.amazonaws.com/tpk:latest"
    portMappings = [
        {
          containerPort = 80
          hostPort      = 80
        }
      ]
	
  }])
}

resource "aws_ecs_service" "tpk_service" {
  name                 = "tpk-service"
  cluster              = aws_ecs_cluster.tpk_cluster.id
  task_definition      = aws_ecs_task_definition.tpk_task.arn
  launch_type          = "FARGATE"
  scheduling_strategy  = "REPLICA"
  desired_count        = 2
  force_new_deployment = true

  network_configuration {
    subnets = data.aws_subnets.tpk_subnets.ids
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.tpk_target_group.arn
    container_name   = "tpk-container"
    container_port   = 80
  }

  depends_on = [
    aws_lb.tpk_lb
  ]
}

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
    type = "fixed-response"

    fixed_response {
      content_type = "text/plain"
      message_body = "Hello, ECS!"
      status_code  = "200"
    }
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

