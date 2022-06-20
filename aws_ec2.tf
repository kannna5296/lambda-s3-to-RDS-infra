//DB見る踏み台用
resource "aws_instance" "my_sample_bastion_ec2_bytf" {
  ami                    = "ami-09d28faae2e9e7138" # Amazon Linux 2
  instance_type          = "t2.micro"
  subnet_id              = aws_subnet.my_sample_public_subnet_a_bytf.id
  vpc_security_group_ids = [aws_security_group.my_sample_ec2_sg_bytf.id]

  tags = {
    Name = "my_sample_bation_ec2_bytf"
  }
}

//固定IP
resource "aws_eip" "my_sample_ec2_eip_bytf" {
  instance = aws_instance.my_sample_bastion_ec2_bytf.id
  vpc      = true

  tags = {
    Name = "my_sample_eip_bytf"
  }
}