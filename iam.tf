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
  #   managed_policy_arns   = [aws_iam_policy.cloud_watch_write.arn, aws_iam_policy.sns_topic_write.arn]
}


resource "aws_iam_role_policy_attachment" "cloud_watch_write_grafana" {
  role       = aws_iam_role.check_grafana.name
  policy_arn = aws_iam_policy.cloud_watch_write.arn
}

resource "aws_iam_role_policy_attachment" "sns_topic_write_grafana" {
  role       = aws_iam_role.check_grafana.name
  policy_arn = aws_iam_policy.sns_topic_write.arn
}
