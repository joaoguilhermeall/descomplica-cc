output "api_endpoint" {
  description = "API Gateway endpoint URL for the temperature converter"
  value       = "${aws_apigatewayv2_api.temperature_api.api_endpoint}/convert"
}

output "api_endpoint_with_example" {
  description = "Complete URL with example usage"
  value       = "${aws_apigatewayv2_api.temperature_api.api_endpoint}/convert?celsius=25"
}

output "api_endpoint_weather" {
  description = "URL to fetch current Belo Horizonte temperature"
  value       = "${aws_apigatewayv2_api.temperature_api.api_endpoint}/convert"
}

output "lambda_function_name" {
  description = "Name of the Lambda function"
  value       = aws_lambda_function.temperature_converter.function_name
}

output "lambda_function_arn" {
  description = "ARN of the Lambda function"
  value       = aws_lambda_function.temperature_converter.arn
}

output "lambda_role_arn" {
  description = "ARN of the Lambda execution role"
  value       = aws_iam_role.lambda_role.arn
}

output "cloudwatch_log_group" {
  description = "CloudWatch Log Group name for Lambda logs"
  value       = aws_cloudwatch_log_group.lambda_logs.name
}

output "api_gateway_id" {
  description = "ID of the API Gateway"
  value       = aws_apigatewayv2_api.temperature_api.id
}

output "usage_instructions" {
  description = "Instructions for using the API"
  value       = <<-EOT
    Temperature Converter API Endpoints:

    1. Convert specific temperature:
       curl "${aws_apigatewayv2_api.temperature_api.api_endpoint}/convert?celsius=25"

    2. Get current Belo Horizonte temperature:
       curl "${aws_apigatewayv2_api.temperature_api.api_endpoint}/convert"

    3. View Lambda logs:
       aws logs tail ${aws_cloudwatch_log_group.lambda_logs.name} --follow
  EOT
}
