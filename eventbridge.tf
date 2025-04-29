data "aws_cloudwatch_event_bus" "default" {
  name = "default"
}

resource "aws_cloudwatch_event_rule" "check_web_hourly" {
  description         = "Rule to run Lambda function every hour"
  event_bus_name      = data.aws_cloudwatch_event_bus.default.name
  name                = "kg_monitoring_check_web_hourly"
  schedule_expression = "rate(1 hour)"
  state               = "ENABLED"
}

resource "aws_cloudwatch_event_target" "check_web" {
  arn            = aws_lambda_function.check_web.arn
  event_bus_name = data.aws_cloudwatch_event_bus.default.name
  rule           = aws_cloudwatch_event_rule.check_web_hourly.name
}
