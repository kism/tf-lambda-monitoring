locals {
  sns_topic_name = "kg-homelab-alerts"
}

resource "aws_sns_topic" "kg_homelab_alerts" {
  name        = local.sns_topic_name
  name_prefix = null
  policy = jsonencode({
    Id = "__default_policy_ID"
    Statement = [{
      Action = ["SNS:GetTopicAttributes", "SNS:SetTopicAttributes", "SNS:AddPermission", "SNS:RemovePermission", "SNS:DeleteTopic", "SNS:Subscribe", "SNS:ListSubscriptionsByTopic", "SNS:Publish"]
      Condition = {
        StringEquals = {
          "AWS:SourceOwner" = var.kism_account_id
        }
      }
      Effect = "Allow"
      Principal = {
        AWS = "*"
      }
      Resource = "arn:aws:sns:${var.region}:${var.kism_account_id}:${local.sns_topic_name}"
      Sid      = "__default_statement_ID"
    }]
    Version = "2008-10-17"
  })

  tags           = {}
  tags_all       = {}
  tracing_config = "PassThrough"
}
