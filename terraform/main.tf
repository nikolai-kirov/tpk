provider "aws" {
  region  = "eu-west-3"  
}

data "aws_iam_role" "task_ecs" {
  name = "ecsTaskExecutionRole"
}

data "aws_vpc" "tpk_vpc" {
  id = aws_vpc.tpk_vpc.id
}

data "aws_subnets" "tpk_subnets" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.tpk_vpc.id]
  }
}


resource "aws_ecs_cluster" "tpk_cluster" {
  name = "tpk-cluster"
}

