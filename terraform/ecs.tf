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
