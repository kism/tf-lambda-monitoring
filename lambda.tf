locals {
  lambda_program_name = "kg_monitoring_check_web"
}

data "archive_file" "check_web_lambda" {
  type        = "zip"
  source_file = "${path.module}/src/lambda_check_web/lambda_function.py"
  output_path = "${path.module}/src/lambda_check_web/lambda_function_payload.zip"
}

resource "aws_lambda_function" "check_web" {
  architectures    = ["arm64"]
  description      = "Performs a periodic check of the given site, erroring out on test failure."
  filename         = data.archive_file.check_web_lambda.output_path
  source_code_hash = data.archive_file.check_web_lambda.output_base64sha256
  function_name    = "arn:aws:lambda:${var.region}:${var.kism_account_id}:function:${local.lambda_program_name}"
  handler          = "lambda_function.lambda_handler"
  memory_size      = 128
  package_type     = "Zip"
  role             = aws_iam_role.check_web.arn
  runtime          = "python3.15"
  timeout          = 90
  environment {
    variables = {
      # From nginx_exposure on rproxy. Lambda runs in ap-southeast-2, so "geofence OR allowlist" = open.
      checks = jsonencode({
        "https://auth.kierangee.au/"              = "open"
        "https://grafana.kierangee.au/api/health" = "open"
        "https://hs.kierangee.au/health"          = "open"
        "https://hs.kierangee.au/admin/"          = "open"
        "https://kierangee.au/"                   = "open"
        "https://homeassistant.kierangee.au/"     = "open"
        "https://jf.kierangee.au/"                = "open"
        "https://jsee.kierangee.au/"              = "open"
        "https://grafana.kierangee.au/"           = "blocked"
        "https://grafana.kierangee.au/api/live/"  = "blocked"
        "https://kierangee.au/private/"           = "blocked"
        "https://myr.kierangee.au/"               = "blocked"
        "https://opnsense.kierangee.au/"          = "blocked"
        "https://qbt.kierangee.au/"               = "blocked"
        "https://stream.kierangee.au/"            = "blocked"
        "https://vic.kierangee.au/"               = "blocked"
        "https://wazuh.kierangee.au/"             = "blocked"
      })
    }
  }
  ephemeral_storage {
    size = 512
  }
  logging_config {
    log_format = "Text"
    log_group  = aws_cloudwatch_log_group.lambda_check_web.name
  }
  tracing_config {
    mode = "PassThrough"
  }
}

resource "aws_lambda_permission" "allow_eventbridge" {
  statement_id  = "AllowExecutionFromEventBridge"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.check_web.function_name
  principal     = "scheduler.amazonaws.com"
  source_arn    = aws_scheduler_schedule.check_web_hourly.arn
}
