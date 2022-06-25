# resource "aws_db_instance" "my_sample_db_instance_bytf" {
#     identifier = "mysampledb"
#     allocated_storage = 20
#     engine = "sqlserver-ex"
#     engine_version = "15.00.4198.2.v1"
#     storage_type = "gp2"
#     instance_class = "db.t3.small"
#     availability_zone = "ap-northeast-1a"
#     username = "sa"
#     password = var.sqlsv["password"]
#     port = 1433
#     skip_final_snapshot = true
#     publicly_accessible = true

#     db_subnet_group_name = aws_db_subnet_group.my_sample_db_subnet_group_bytf.name
#     parameter_group_name = aws_db_parameter_group.my_sample_db_parameter_group_bytf.name
#     option_group_name = aws_db_option_group.my_sample_db_option_group_bytf.name
# }

resource "aws_db_subnet_group" "my_sample_db_subnet_group_bytf" {
    name = "my_sample_db_subnet_group_bytf"
    subnet_ids = [
        aws_subnet.my_sample_private_subnet_a_bytf.id,
        aws_subnet.my_sample_private_subnet_c_bytf.id,
    ]
    tags = {
        Name = "my_sample_db_subnet_group_bytf"
    }
}

resource "aws_db_parameter_group" "my_sample_db_parameter_group_bytf" {
    description = "Paramter Group for sql-server-ex-15.0"
    family = "sqlserver-ex-15.0"
    name = "my-sample-db-parameter-group-bytf"
    tags = {
        Name = "my_sample_db_parameter_group_bytf"
    }
  
}

resource "aws_db_option_group" "my_sample_db_option_group_bytf" {
    name = "my-sample-db-option-group-bytf"
    option_group_description = "Option Group"
    engine_name = "sqlserver-ex"
    major_engine_version = "15.00"
    tags = {
        Name = "my_sample_db_option_group_bytf"
    }
}