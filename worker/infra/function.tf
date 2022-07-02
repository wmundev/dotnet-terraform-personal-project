data "archive_file" "lambda_hello_world" {
  type = "zip"

  source_dir  = "${path.module}/../publish"
  output_path = "${path.module}/project.zip"
}

resource "aws_s3_object" "lambda_hello_world" {
  bucket = aws_s3_bucket.lambda_bucket.id

  key    = "project.zip"
  source = data.archive_file.lambda_hello_world.output_path

  etag = filemd5(data.archive_file.lambda_hello_world.output_path)
}

resource "aws_lambda_function" "hello_world" {
  function_name = "HelloWorld"

  s3_bucket = aws_s3_bucket.lambda_bucket.id
  s3_key    = aws_s3_object.lambda_hello_world.key

  runtime = "dotnet6"
  handler = "SNSTest::SNSTest.Function::FunctionHandler"
  architectures = ["arm64"]

  source_code_hash = data.archive_file.lambda_hello_world.output_base64sha256

  role = aws_iam_role.lambda_exec.arn
}

resource "aws_cloudwatch_log_group" "hello_world" {
  name = "/aws/lambda/${aws_lambda_function.hello_world.function_name}"

  retention_in_days = 30
}

resource "aws_iam_role" "lambda_exec" {
  name = "dotnet-terraform-worker-lambda-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Sid    = ""
      Principal = {
        Service = "lambda.amazonaws.com"
      }
    }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "lambda_policy" {
  role       = aws_iam_role.lambda_exec.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

#data "aws_iam_policy_document" "sns_policy" {
#  policy_id = "sns-test-policy"
#
#  statement {
#    actions = [
#      "SNS:Subscribe"
#    ]
#
#    effect = "Allow"
#
#    resources = [
#      aws_sns_topic.user_updates.arn
#    ]
#  }
#}
#
#resource "aws_iam_policy" "sns_policy" {
#  name   = "example_policy"
#  path   = "/"
#  policy = data.aws_iam_policy_document.sns_policy.json
#}
#
#resource "aws_iam_role_policy_attachment" "test-attach" {
#  role       = aws_iam_role.lambda_exec.name
#  policy_arn = aws_iam_policy.sns_policy.arn
#}