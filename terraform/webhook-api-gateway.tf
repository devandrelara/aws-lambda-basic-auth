resource "aws_apigatewayv2_integration" "lambda_webhook" {
  api_id = aws_apigatewayv2_api.main.id

  integration_uri    = aws_lambda_function.webhook.invoke_arn
  integration_type   = "AWS_PROXY"
  integration_method = "POST"
}

resource "aws_apigatewayv2_route" "get_webhook" {
  api_id = aws_apigatewayv2_api.main.id
  authorization_type = "CUSTOM"
  authorizer_id = aws_apigatewayv2_authorizer.auth.id
  route_key = "GET /webhook"
  target    = "integrations/${aws_apigatewayv2_integration.lambda_webhook.id}"
}

resource "aws_lambda_permission" "api_gw" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.webhook.function_name
  principal     = "apigateway.amazonaws.com"

  source_arn = "${aws_apigatewayv2_api.main.execution_arn}/*/*"
}

output "webhook_base_url" {
  value = aws_apigatewayv2_stage.dev.invoke_url
}
