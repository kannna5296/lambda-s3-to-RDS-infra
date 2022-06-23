//VPC
resource "aws_vpc" "my_sample_vpc_bytf" {
  cidr_block           = "10.50.0.0/16"
  enable_dns_hostnames = true

  tags = {
    Name = "my_sample_vpc_bytf"
  }
}

//サブネット（パブリック a）
resource "aws_subnet" "my_sample_public_subnet_a_bytf" {
  vpc_id                  = aws_vpc.my_sample_vpc_bytf.id
  cidr_block              = "10.50.1.0/24"
  availability_zone       = "ap-northeast-1a"
  map_public_ip_on_launch = false

  tags = {
    Name = "my_sample_public_subnet_a_bytf"
  }
}

//サブネット（プライベート a）
resource "aws_subnet" "my_sample_private_subnet_a_bytf" {
  vpc_id                  = aws_vpc.my_sample_vpc_bytf.id
  cidr_block              = "10.50.2.0/24"
  availability_zone       = "ap-northeast-1a"
  map_public_ip_on_launch = false

  tags = {
    Name = "my_sample_private_subnet_a_bytf"
  }
}

//サブネット（パブリック c）
resource "aws_subnet" "my_sample_public_subnet_c_bytf" {
  vpc_id                  = aws_vpc.my_sample_vpc_bytf.id
  cidr_block              = "10.50.3.0/24"
  availability_zone       = "ap-northeast-1c"
  map_public_ip_on_launch = false

  tags = {
    Name = "my_sample_public_subnet_c_bytf"
  }
}

//サブネット（プライベート c）
resource "aws_subnet" "my_sample_private_subnet_c_bytf" {
  vpc_id                  = aws_vpc.my_sample_vpc_bytf.id
  cidr_block              = "10.50.4.0/24"
  availability_zone       = "ap-northeast-1c"
  map_public_ip_on_launch = false

  tags = {
    Name = "my_sample_private_subnet_c_bytf"
  }
}

//インターネットゲートウェイ
resource "aws_internet_gateway" "my_sample_igw_bytf" {
  vpc_id                  = aws_vpc.my_sample_vpc_bytf.id
  tags = {
    Name = "my_sample_igw_bytf"
  }
}

//ルートテーブル(パブリック)
resource "aws_route_table" "my_sample_public_rtb_bytf" {
  vpc_id                  = aws_vpc.my_sample_vpc_bytf.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.my_sample_igw_bytf.id
  }
  tags = {
    Name = "my_sample_public_rtb_bytf"
  }
}

//ルートテーブル(プライベート)
resource "aws_route_table" "my_sample_private_rtb_bytf" {
  vpc_id                  = aws_vpc.my_sample_vpc_bytf.id
  tags = {
    Name = "my_sample_private_rtb_bytf"
  }
}

//サブネットとルートテーブルの紐付け
//パブリック
resource "aws_route_table_association" "my_sample_rt_assoc_public_a_bytf" {
  subnet_id      = aws_subnet.my_sample_public_subnet_a_bytf.id
  route_table_id = aws_route_table.my_sample_public_rtb_bytf.id
}
resource "aws_route_table_association" "my_sample_rt_assoc_public_c_bytf" {
  subnet_id      = aws_subnet.my_sample_public_subnet_c_bytf.id
  route_table_id = aws_route_table.my_sample_public_rtb_bytf.id
}
//プライベート
resource "aws_route_table_association" "my_sample_rt_assoc_private_a_bytf" {
  subnet_id      = aws_subnet.my_sample_private_subnet_a_bytf.id
  route_table_id = aws_route_table.my_sample_private_rtb_bytf.id
}
resource "aws_route_table_association" "my_sample_rt_assoc_private_c_bytf" {
  subnet_id      = aws_subnet.my_sample_private_subnet_c_bytf.id
  route_table_id = aws_route_table.my_sample_private_rtb_bytf.id
}

//セキュリティグループ
//ec2
resource "aws_security_group" "my_sample_ec2_sg_bytf" {
  name   = "my_sample_ec2_sg_bytf"
  vpc_id = aws_vpc.my_sample_vpc_bytf.id
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

//db
resource "aws_security_group" "my_sample_db_sg_bytf" {
  name   = "my_sample_db_sg_bytf"
  vpc_id = aws_vpc.my_sample_vpc_bytf.id
  ingress {
    from_port   = 1433
    to_port     = 1433
    protocol    = "tcp"
    cidr_blocks = ["10.50.0.0/16"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

//alb
resource "aws_security_group" "my_sample_alb_sg_bytf" {
  name   = "my_sample_alb_sg_bytf"
  vpc_id = aws_vpc.my_sample_vpc_bytf.id
  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

//container
resource "aws_security_group" "my_sample_container_sg_bytf" {
  name   = "my_sample_container_sg_bytf"
  vpc_id = aws_vpc.my_sample_vpc_bytf.id
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

//privatelink
resource "aws_security_group" "my_sample_privatelink_sg_bytf" {
  name   = "my_sample_privatelink_sg_bytf"
  vpc_id = aws_vpc.my_sample_vpc_bytf.id
  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    security_groups = [aws_security_group.my_sample_container_sg_bytf.id]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

//lambda
resource "aws_security_group" "my_sample_lambda_sg_bytf" {
  name   = "my_sample_lambda_sg_bytf"
  vpc_id = aws_vpc.my_sample_vpc_bytf.id
  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  # egress {
  #   from_port   = 0
  #   to_port     = 0
  #   protocol    = "-1"
  #   cidr_blocks = ["0.0.0.0/0"]
  # }
}

resource "aws_security_group_rule" "my_sample_lambda_sg_engress_all_bytf" {
  type        = "egress"
  from_port   = 0
  to_port     = 0
  protocol    = "-1"
  cidr_blocks = ["0.0.0.0/0"]
  security_group_id = "${aws_security_group.my_sample_lambda_sg_bytf.id}"
}

resource "aws_security_group_rule" "my_sample_lambda_sg_engress_db_bytf" {
  type        = "egress"
  from_port   = 1433
  to_port     = 1433
  protocol    = "tcp"
  cidr_blocks = ["10.50.0.0/16"]
  security_group_id = "${aws_security_group.my_sample_lambda_sg_bytf.id}"
}

//VPCエンドポイント
//ecr_api(ECS-ECR接続に利用)
resource "aws_vpc_endpoint" "my_sample_privatelink_ecr_api_bytf" {
  vpc_id            = aws_vpc.my_sample_vpc_bytf.id
  service_name      = "com.amazonaws.ap-northeast-1.ecr.api"
  vpc_endpoint_type = "Interface"

  security_group_ids = [
    aws_security_group.my_sample_privatelink_sg_bytf.id
  ]
  tags = {
    Name = "my_sample_privatelink_ecr_api_bytf"
  }
}

//ecr_dkr(ECS-ECR接続に利用)
resource "aws_vpc_endpoint" "my_sample_privatelink_ecr_dkr_bytf" {
  vpc_id            = aws_vpc.my_sample_vpc_bytf.id
  service_name      = "com.amazonaws.ap-northeast-1.ecr.dkr"
  vpc_endpoint_type = "Interface"

  security_group_ids = [
    aws_security_group.my_sample_privatelink_sg_bytf.id
  ]
  tags = {
    Name = "my_sample_privatelink_ecr_dkr_bytf"
  }
}

//logs(ECS-CloudWatch logs接続に利用)
resource "aws_vpc_endpoint" "my_sample_privatelink_logs_bytf" {
  vpc_id            = aws_vpc.my_sample_vpc_bytf.id
  service_name      = "com.amazonaws.ap-northeast-1.logs"
  vpc_endpoint_type = "Interface"

  security_group_ids = [
    aws_security_group.my_sample_privatelink_sg_bytf.id
  ]
  tags = {
    Name = "my_sample_privatelink_logs_bytf"
  }
}

//S3(ECS-S3接続に利用)
resource "aws_vpc_endpoint" "my_sample_privatelink_s3_bytf" {
    vpc_id          = aws_vpc.my_sample_vpc_bytf.id
    service_name      = "com.amazonaws.ap-northeast-1.s3"
    policy = <<POLICY
    {
        "Statement": [
            {
                "Action": "*",
                "Effect": "Allow",
                "Resource": "*",
                "Principal": "*"
            }
        ]
    }
    POLICY
  tags = {
    Name = "my_sample_privatelink_s3_bytf"
  }
}

resource "aws_vpc_endpoint_route_table_association" "my_sample_privatelink_s3_route_table_assoc_bytf" {
    vpc_endpoint_id = aws_vpc_endpoint.my_sample_privatelink_s3_bytf.id
    route_table_id  = aws_route_table.my_sample_private_rtb_bytf.id
}