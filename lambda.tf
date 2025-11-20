locals {
  lambda_program_name = "kg_monitoring_check_web"
}

data "archive_file" "check_web_lambda" {
  type        = "zip"
  source_file = "${path.module}/lambda_check_web/lambda_function.py"
  output_path = "${path.module}/lambda_check_web/lambda_function_payload.zip"
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
  runtime          = "python3.13"
  timeout          = 10
  environment {
    variables = {
      site = "https://grafana.kierangee.au/api/health"
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
