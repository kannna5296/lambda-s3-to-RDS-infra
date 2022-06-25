//Repository(DockeイメージをPushする先)
resource "aws_ecr_repository" "mysample" {
    name = "mysample"
    image_tag_mutability = "MUTABLE"
    tags = {
      "Name" = "mysample"
    }

    encryption_configuration {
      encryption_type = "AES256"
    }

    image_scanning_configuration {
      scan_on_push = false
    }
}

//タスク定義
resource "aws_ecs_task_definition" "my_sample_task_definition_bytf" {
  family = "mysample-task"
  cpu = 256
  memory = 512

  container_definitions = jsonencode(
    [
      {
        cpu       = 0
        environment = [
          {
            name = "SPRING_PROFILES_ACTIVE",
            value = "dev"
          },
          {
            name = "DB_PASSWORD",
            value = var.secret["db_password"]
          },
          {
            name = "AWS_ACCESS_KEY",
            value = var.secret["aws_access_key"]
          },
          {
            name = "AWS_SECRET_KEY",
            value = var.secret["aws_secret_key"]
          },
        ]
        name      = "mysample-task"
        image     = "hogehoge" //動かないけどタスク定義は作れる
        essential = true
        portMappings = [
          {
           containerPort = 8080
           hostPort      = 8080
         }
        ]
        logConfiguration = {
          logDriver = "awslogs"
          options = {
            awslogs-group = "/ecs/mysample-task"
            awslogs-region = "ap-northeast-1"
            awslogs-stream-prefix = "ecs"
          }
        }
      },
   ]
  )
  network_mode = "awsvpc"
  requires_compatibilities = [
     "FARGATE",
  ]
  //TODO変数化
  execution_role_arn = "arn:aws:iam::565640681026:role/ecsTaskExecutionRole"
}
