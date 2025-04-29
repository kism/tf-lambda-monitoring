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

import {
  to = aws_iam_policy.cloud_watch_write
  id = "arn:aws:iam::471112518165:policy/service-role/AWSLambdaBasicExecutionRole-b13e47b2-b69a-46ed-8ab7-e421560eec6f"
}

import {
  to = aws_iam_policy.sns_topic_write
  id = "arn:aws:iam::471112518165:policy/service-role/AWSLambdaSNSTopicDestinationExecutionRole-cfd4e103-33bc-47e2-a8e6-7d75fc101dab"
}





resource "aws_iam_policy" "cloud_watch_write" {
  description = null
  name        = "AWSLambdaBasicExecutionRole-b13e47b2-b69a-46ed-8ab7-e421560eec6f"
  name_prefix = null
  path        = "/service-role/"
  policy = jsonencode({
    Statement = [{
      Action   = "logs:CreateLogGroup"
      Effect   = "Allow"
      Resource = "arn:aws:logs:ap-southeast-2:471112518165:*"
      }, {
      Action   = ["logs:CreateLogStream", "logs:PutLogEvents"]
      Effect   = "Allow"
      Resource = ["arn:aws:logs:ap-southeast-2:471112518165:log-group:/aws/lambda/CheckGrafana:*"]
    }]
    Version = "2012-10-17"
  })
  tags     = {}
  tags_all = {}
}
