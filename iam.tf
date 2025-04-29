import {
  to = aws_iam_role.check_grafana
  id = "CheckGrafana-role-bgihua7g"
}

resource "aws_iam_role" "check_grafana" {
  assume_role_policy = jsonencode({
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        Service = "lambda.amazonaws.com"
      }
    }]
    Version = "2012-10-17"
  })
  description           = null
  force_detach_policies = false
  max_session_duration  = 3600
  name                  = "CheckGrafana-role-bgihua7g"
  name_prefix           = null
  path                  = "/service-role/"
  permissions_boundary  = null
  tags                  = {}
  tags_all              = {}
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
      Resource = ["arn:aws:logs:${var.region}:${var.kism_account_id}:log-group:/aws/lambda/CheckGrafana:*"]
    }]
    Version = "2012-10-17"
  })
  tags     = {}
  tags_all = {}
}
