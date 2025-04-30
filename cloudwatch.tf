
resource "aws_cloudwatch_log_group" "lambda_check_web" {
  log_group_class   = "STANDARD"
  name              = "/aws/lambda/kg_web_monitoring"
  retention_in_days = 7
  skip_destroy      = false
}

resource "aws_iam_policy" "cloud_watch_write" { # Rename
  description = null
  name        = "kg_monitoring_cloudwatch_write"
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
      Resource = ["arn:aws:logs:${var.region}:${var.kism_account_id}:log-group:${aws_cloudwatch_log_group.lambda_check_web.name}:*"]
    }]
    Version = "2012-10-17"
  })
}

resource "aws_cloudwatch_metric_alarm" "kg_homelab_alert" {
  actions_enabled     = true
  alarm_actions       = [aws_sns_topic.kg_homelab_alerts.arn]
  alarm_description   = "Hello, grafana.kierangee.au appears to be down."
  alarm_name          = "grafana_is_down"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  datapoints_to_alarm = 1
  dimensions = {
    FunctionName = "kg_web_monitoring"
  }
  evaluation_periods = 1
  metric_name        = "Errors"
  namespace          = "AWS/Lambda"
  period             = 3600
  statistic          = "Sum"
  threshold          = 1
  treat_missing_data = "missing"
}
