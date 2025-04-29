
resource "aws_cloudwatch_log_group" "lambda_check_grafana" {
  log_group_class   = "STANDARD"
  name              = "/aws/lambda/CheckGrafana"
  retention_in_days = 7
  skip_destroy      = false
}

resource "aws_iam_policy" "cloud_watch_write" { # Rename
  description = null
  name        = "AWSLambdaBasicExecutionRole-b13e47b2-b69a-46ed-8ab7-e421560eec6f"
  name_prefix = null
  path        = "/service-role/"
  policy = jsonencode({
    Statement = [{
      Action   = "logs:CreateLogGroup"
      Effect   = "Allow"
      Resource = "arn:aws:logs:${var.region}:${var.kism_account_id}:*"
      }, {
      Action   = ["logs:CreateLogStream", "logs:PutLogEvents"]
      Effect   = "Allow"
      Resource = ["arn:aws:logs:${var.region}:${var.kism_account_id}:log-group:${aws_cloudwatch_log_group.lambda_check_grafana.name}:*"]
    }]
    Version = "2012-10-17"
  })
}
