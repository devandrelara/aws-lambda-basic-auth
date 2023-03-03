data "aws_iam_policy_document" "get_ssm_parameter_policy" {
  statement {
    actions = [
      "ssm:GetParameters",
      "ssm:GetParameter",
      "ssm:GetParametersByPath"
    ]
    effect = "Allow"
    resources = ["arn:aws:ssm:ca-central-1::parameter/*"]
  }
}
resource "aws_iam_role" "webhook_authorizer_exec" {
  name = "webhook-authorizer"
  inline_policy {
    name = "AWSParameterStoreReadOnly"

    policy = jsonencode({
      Version = "2012-10-17"
      Statement = [
        {
          Action   = ["ssm:GetParameter*"]
          Effect   = "Allow"
          Resource = "*"
        },
      ]
    })
  }
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

resource "aws_iam_role_policy_attachment" "webhook_authorizer_policy" {
  role       = aws_iam_role.webhook_authorizer_exec.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}


resource "aws_lambda_function" "authorizer" {
  function_name = "authorizer"

  s3_bucket = aws_s3_bucket.lambda_bucket.id
  s3_key    = aws_s3_object.lambda_authorizer.key

  runtime = "python3.8"
  handler = "authorizer.handle"

  source_code_hash = data.archive_file.webhook_authorizer_package.output_base64sha256

  role = aws_iam_role.webhook_authorizer_exec.arn
}

resource "aws_cloudwatch_log_group" "authorizer" {
  name = "/aws/lambda/${aws_lambda_function.authorizer.function_name}"

  retention_in_days = 14
}

data "archive_file" "webhook_authorizer_package" {
  type = "zip"
  source_file = "../${path.module}/app/authorizer.py"
  output_path = "authorizer.zip"
}

resource "aws_s3_object" "lambda_authorizer" {
  bucket = aws_s3_bucket.lambda_bucket.id

  key    = "authorizer.zip"
  source = data.archive_file.webhook_authorizer_package.output_path

  etag = filemd5(data.archive_file.webhook_authorizer_package.output_path)
}
