resource "aws_scheduler_schedule" "check_web_hourly" {
  name = "kg_monitoring_check_web_hourly"

  flexible_time_window {
    mode                      = "FLEXIBLE"
    maximum_window_in_minutes = 30
  }

  schedule_expression = "rate(1 hour)"

  target {
    arn      = aws_lambda_function.check_web.arn
    role_arn = aws_iam_role.scheduler_check_web.arn
  }
}
