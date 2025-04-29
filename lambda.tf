data "archive_file" "check_grafana_lambda" {
  type        = "zip"
  source_file = "${path.module}/lambda/grafana/lambda_function.py"
  output_path = "${path.module}/lambda/grafana/lambda_function_payload.zip"
}

resource "aws_lambda_function" "check_grafana" {
  architectures    = ["arm64"]
  description      = "Performs a periodic check of the given site, erroring out on test failure."
  filename         = "${path.module}/lambda/grafana/lambda_function_payload.zip"
  function_name    = "arn:aws:lambda:ap-southeast-2:471112518165:function:CheckGrafana"
  handler          = "lambda_function.lambda_handler"
  memory_size      = 128
  package_type     = "Zip"
  role             = aws_iam_role.check_grafana.arn
  runtime          = "python3.13"
  timeout          = 10
  source_code_hash = data.archive_file.check_grafana_lambda.output_base64sha256
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
    log_group  = aws_cloudwatch_log_group.lambda_check_grafana.name
  }
  tracing_config {
    mode = "PassThrough"
  }
}
