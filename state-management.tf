locals { # Make sure you copy paste properly, the characters at the end are random per account
  AWSAdministratorAccess_ARN = "arn:aws:iam::471112518165:role/aws-reserved/sso.amazonaws.com/ap-southeast-2/AWSReservedSSO_AdministratorAccess_b38d57d2c0ce229e"
}

resource "aws_s3_bucket" "terraform_state_bucket" {
  bucket = "lambda-monitoring-terraform-state"
}

resource "aws_s3_bucket_versioning" "terraform_state_bucket_versioning" {
  bucket = aws_s3_bucket.terraform_state_bucket.id

  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_policy" "terraform_state_bucket_policy" {
  bucket = aws_s3_bucket.terraform_state_bucket.id

  policy = jsonencode({
    "Version" : "2012-10-17",
    "Id" : "DenyAllForNonAdmin",
    "Statement" : [
      {
        "Sid" : "AllowAll",
        "Effect" : "Allow",
        "Principal" : "*",
        "Action" : "*",
        "Resource" : [
          "arn:aws:s3:::lambda-monitoring-terraform-state",
          "arn:aws:s3:::lambda-monitoring-terraform-state/*"
        ]
      },
      {
        "Sid" : "DenyAllForNonAdmin",
        "Effect" : "Deny",
        "Principal" : "*",
        "Action" : "*",
        "Resource" : [
          "arn:aws:s3:::lambda-monitoring-terraform-state",
          "arn:aws:s3:::lambda-monitoring-terraform-state/*"
        ],
        "Condition" : {
          "ArnNotEquals" : {
            "aws:PrincipalArn" : local.AWSAdministratorAccess_ARN
          }
        }
      }
    ]
  })
}
