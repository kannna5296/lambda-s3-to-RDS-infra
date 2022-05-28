//VPC
resource "aws_vpc" "my_sample_vpc_bytf" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true

  tags = {
    Name = "my_sample_vpc_bytf"
  }
}

//サブネット（パブリック）
resource "aws_subnet" "my_sample_public_subnet_a_bytf" {
  vpc_id                  = aws_vpc.my_sample_vpc_bytf.id
  cidr_block              = "10.0.0.0/24"
  availability_zone       = "ap-northeast-1a"
  map_public_ip_on_launch = true

  tags = {
    Name = "my_sample_public_subnet_a_bytf"
  }
}

//サブネット（プライベート）
resource "aws_subnet" "my_sample_private_subnet_a_bytf" {
  vpc_id                  = aws_vpc.my_sample_vpc_bytf.id
  cidr_block              = "10.0.100.0/24"
  availability_zone       = "ap-northeast-1a"
  map_public_ip_on_launch = false

  tags = {
    Name = "my_sample_private_subnet_a_bytf"
  }
}

resource "aws_subnet" "my_sample_private_subnet_c_bytf" {
  vpc_id                  = aws_vpc.my_sample_vpc_bytf.id
  cidr_block              = "10.0.101.0/24"
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

//ルートテーブル
resource "aws_route_table" "my_sample_rtb_bytf" {
  vpc_id                  = aws_vpc.my_sample_vpc_bytf.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.my_sample_igw_bytf.id
  }
  tags = {
    Name = "my_sample_rtb_bytf"
  }
}

//サブネットとルートテーブルの紐付け
//mainじゃないルートテーブルが1つ増える
resource "aws_route_table_association" "my_sample_rt_assoc_public_a_bytf" {
  subnet_id      = aws_subnet.my_sample_public_subnet_a_bytf.id
  route_table_id = aws_route_table.my_sample_rtb_bytf.id
}
resource "aws_route_table_association" "my_sample_rt_assoc_private_a_bytf" {
  subnet_id      = aws_subnet.my_sample_private_subnet_a_bytf.id
  route_table_id = aws_route_table.my_sample_rtb_bytf.id
}
resource "aws_route_table_association" "my_sample_rt_assoc_private_c_bytf" {
  subnet_id      = aws_subnet.my_sample_private_subnet_c_bytf.id
  route_table_id = aws_route_table.my_sample_rtb_bytf.id
}

//セキュリティグループ
resource "aws_security_group" "my_sample_sg_bytf" {
  name   = "my_sample_sg_bytf"
  vpc_id = aws_vpc.my_sample_vpc_bytf.id
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [local.allowed-cidr]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

variable allowed-cidr {
  default = null
}
data http ifconfig {
  url = "https://ifconfig.co/ip"
}
locals {
  current-ip = chomp(data.http.ifconfig.body)
  allowed-cidr  = (var.allowed-cidr == null) ? "${local.current-ip}/32" : var.allowed-cidr
}

//DB用セキュリティグループ
resource "aws_security_group" "my_sample_db_sg_bytf" {
  name   = "my_sample_db_sg_bytf"
  vpc_id = aws_vpc.my_sample_vpc_bytf.id
  ingress {
    from_port   = 3306
    to_port     = 3306
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

//ネットワークACLはなんか勝手にできてた
