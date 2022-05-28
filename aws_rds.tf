//RDSインスタンス（mysql）
resource "aws_db_instance" "my_sample_rds_bytf" {
  db_subnet_group_name = aws_db_subnet_group.my_sample_rds_subnet_group_bytf.name
  identifier = "mysampledb"
  availability_zone = "ap-northeast-1a"
  allocated_storage    = 20
  engine               = "mysql"
  engine_version       = "8.0"
  instance_class       = "db.t3.micro"
  db_name              = "mysampledb"
  username             = "admin"
  //TODO SecretManager化
  password             = "pa"
  parameter_group_name = "default.mysql8.0"
  skip_final_snapshot  = true

  #Storage暗号化
  storage_encrypted = true
  kms_key_id        = aws_kms_key.my_sample_rds_storage_kms_bytf.arn

  # ライフサイクル設定。
  lifecycle {
    # passwordの変更はTerraformとして無視する。セキュリティの観点からインスタンス構築後、手動でパスワードを変更するため。
    ignore_changes = [password]
  }
}

resource "aws_db_subnet_group" "my_sample_rds_subnet_group_bytf" {
  name       = "my_sample_rds_subnet_group_bytf"
  subnet_ids = [aws_subnet.my_sample_private_subnet_a_bytf.id, aws_subnet.my_sample_private_subnet_c_bytf.id]

  tags = {
    Name = "my_sample_rds_subnet_group_bytf"
  }
}

