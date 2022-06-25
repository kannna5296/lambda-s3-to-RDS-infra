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