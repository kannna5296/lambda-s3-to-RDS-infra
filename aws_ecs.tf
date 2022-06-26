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
        name      = "mysample-container"
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
  //この番号ってECRに紐づいてるなら、変えないといけない？
  execution_role_arn = "arn:aws:iam::565640681026:role/ecsTaskExecutionRole"
}

//クラスター
resource "aws_ecs_cluster" "my_sample_ecs_cluster_bytf" {
  name = "mysample-cluster"

  setting {
    name  = "containerInsights"
    value = "enabled"
  }

  tags = {
    "Name" = "my_sample_ecs_cluster_bytf"
  }
}


//サービス
//(テスト用)時間かかるので欲しい時のみ有効化
# resource "aws_ecs_service" "my_sample_ecs_service_bytf" {
#   name = "mysample-service"
#   cluster = aws_ecs_cluster.my_sample_ecs_cluster_bytf.name
#   task_definition = aws_ecs_task_definition.my_sample_task_definition_bytf.arn
#   launch_type = "FARGATE"
#   //コレ指定しないとLoadBalancer指定のところで落ちる
#   depends_on      = [aws_lb_target_group.my_sample_targetgroup_bytf]
#   network_configuration {
#     subnets = [aws_subnet.my_sample_private_subnet_a_bytf.id]
#     security_groups = [aws_security_group.my_sample_container_sg_bytf.id]
#   }

#   //ECSタスクの起動数
#   desired_count = 0

#   load_balancer {
#     target_group_arn = aws_lb_target_group.my_sample_targetgroup_bytf.arn
#     container_name = "mysample-container"
#     container_port = 8080
#   }
# }