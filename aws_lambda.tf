# resource "aws_lambda_function" "my_sample_lambda_function_bytf" {
#   function_name = "my_sample_lambda_function_bytf"
#   role          = aws_iam_role.iam_for_lambda_bytf.arn
  
#   filename      = "app.zip"
#   source_code_hash = filebase64sha256("lambda_function_payload.zip")
#   handler       = "app.handler"
#   runtime = "python3.9"
# }


# resource "aws_iam_role" "iam_for_lambda_bytf" {
#   name = "iam_for_lambda_bytf"

#   assume_role_policy = <<EOF
# {
#   "Version": "2012-10-17",
#   "Statement": [
#     {
#       "Action": "sts:AssumeRole",
#       "Principal": {
#         "Service": "lambda.amazonaws.com"
#       },
#       "Effect": "Allow",
#       "Sid": ""
#     }
#   ]
# }
# EOF
# }