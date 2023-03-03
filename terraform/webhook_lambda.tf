resource "aws_iam_role" "webhook_lambda_exec" {
  name = "webhook-lambda"

  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
POLICY
}

resource "aws_iam_role_policy_attachment" "hello_lambda_policy" {
  role       = aws_iam_role.webhook_lambda_exec.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

resource "aws_lambda_function" "webhook" {
  function_name = "webhook"

  s3_bucket = aws_s3_bucket.lambda_bucket.id
  s3_key    = aws_s3_object.lambda_webhook.key

  runtime = "python3.8"
  handler = "webhook.handle"

  source_code_hash = data.archive_file.webhook_lambda_package.output_base64sha256

  role = aws_iam_role.webhook_lambda_exec.arn
}

resource "aws_cloudwatch_log_group" "hello" {
  name = "/aws/lambda/${aws_lambda_function.webhook.function_name}"

  retention_in_days = 14
}

data "archive_file" "webhook_lambda_package" {
  type = "zip"
  source_file = "../${path.module}/app/webhook.py"
  output_path = "webhook.zip"
}

resource "aws_s3_object" "lambda_webhook" {
  bucket = aws_s3_bucket.lambda_bucket.id

  key    = "webhook.zip"
  source = data.archive_file.webhook_lambda_package.output_path

  etag = filemd5(data.archive_file.webhook_lambda_package.output_path)
}
