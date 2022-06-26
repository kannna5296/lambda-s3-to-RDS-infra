# /*
# DB見る踏み台用
# */
# resource "aws_instance" "my_sample_bastion_ec2_bytf" {
#   ami                    = "ami-09d28faae2e9e7138" # Amazon Linux 2
#   instance_type          = "t2.micro"
#   subnet_id              = aws_subnet.my_sample_public_subnet_a_bytf.id
#   vpc_security_group_ids = [aws_security_group.my_sample_ec2_sg_bytf.id]

#   tags = {
#     Name = "my_sample_bation_ec2_bytf"
#   }
# }

# //固定IP
# resource "aws_eip" "my_sample_ec2_eip_bytf" {
#   instance = aws_instance.my_sample_bastion_ec2_bytf.id
#   vpc      = true

#   tags = {
#     Name = "my_sample_eip_bytf"
#   }
# }

/*
ECS接続ALB周り
*/
//ターゲットグループ(ECS接続で利用)
resource "aws_lb_target_group" "my_sample_targetgroup_bytf" {
  name     = "mysample-tag"
  port     = 8080
  protocol = "HTTP"
  target_type = "ip"
  vpc_id   = aws_vpc.my_sample_vpc_bytf.id

  health_check {
    enabled = true
    path = "/health_check"
    protocol = "HTTP"
    port = "traffic-port"
    timeout = 5
  }
}

//Application Load Balancer(ECS接続で利用)
resource "aws_lb" "mysample_alb" {
  name               = "my-sample-alb-bytf"
  internal           = false //internet-facing
  load_balancer_type = "application"
  security_groups    = [aws_security_group.my_sample_alb_sg_bytf.id]
  //ループで書きたい
  subnets            = [aws_subnet.my_sample_public_subnet_a_bytf.id, aws_subnet.my_sample_public_subnet_c_bytf.id]

  enable_deletion_protection = false

  tags = {
    Name = "my_sample_alb_bytf"
  }
}

resource "aws_lb_listener" "my_sample_alb_lisnter_bytf" {
  port = "8080"
  protocol = "HTTP"

  load_balancer_arn = aws_lb.mysample_alb.arn

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.my_sample_targetgroup_bytf.arn
  }
  
}