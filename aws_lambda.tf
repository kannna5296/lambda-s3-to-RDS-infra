//この辺は手でやったほうが便利かもしれん
# resource "aws_lambda_function" "mysample_lambda" {
#   # If the file is not in the current working directory you will need to include a 
#   # path.module in the filename.
#   function_name = "mysample_lambda"
#   role          = aws_iam_role.iam_for_mysample_lambda_myamane.arn
#   # The filebase64sha256() function is available in Terraform 0.11.12 and later
#   # For Terraform 0.11.11 and earlier, use the base64sha256() function and the file() function:
#   # source_code_hash = "${base64sha256(file("lambda_function_payload.zip"))}"
#   //source_code_hash = filebase64sha256("lambda_function_payload.zip")

#   runtime = "python3.7"
#   handler = "lambda_function.lambda_handler"

#   environment {
#     variables = {
#       BUCKET_NAME = aws_s3_bucket.mysample-bucket-myamane.bucket
#       ODBCINI = "/opt/odbc.ini"
#       ODBCSYSINI = "/opt"
#       SRC_FILE_ENCODING = "utf-8"
#     }
#   }
# }

# resource "aws_iam_role" "iam_for_mysample_lambda_myamane" {
#   name = "iam_for_mysample_lambda_myamane"

#   assume_role_policy = <<EOF
# {
#     "Version": "2012-10-17",
#     "Statement": [
#         {
#             "Effect": "Allow",
#             "Principal": {
#                 "Service": "lambda.amazonaws.com"
#             },
#             "Action": "sts:AssumeRole"
#         }
#     ]
# }
# EOF
# }