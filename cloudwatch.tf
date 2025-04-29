
resource "aws_cloudwatch_log_group" "lambda_check_grafana" {
  log_group_class   = "STANDARD"
  name              = "/aws/lambda/CheckGrafana"
  retention_in_days = 7
  skip_destroy      = false
}
