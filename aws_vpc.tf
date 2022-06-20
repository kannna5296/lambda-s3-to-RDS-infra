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